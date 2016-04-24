//
//  WVTConfig.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "WVTConfig.h"
#import "WMTSTileInfo.h"

@implementation WVTObject

- (id)initWithDict:(NSDictionary *)dict config:(WVTConfig *)config
{
    self = [super init];
    _config = config;
    _dict = dict;
    
    return self;
}

@end

@implementation WVTMatrixSet

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)name config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = name;

    // Figure out how many zoom levels from the resolutions available
    NSArray *res = dict[@"resolutions"];
    if (![res isKindOfClass:[NSArray class]])
        return nil;
    _maxZoom = [res count];
    
    // Note: Don't hardwire this
    _pixelsPerTile = 512;
    
    return self;
}

@end

@implementation WVTSource

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)name config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = name;
    _url = dict[@"url"];
    
    // Note: Should be parsing their regular expression here
    if ([_url isEqualToString:@"//map1{a-c}.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi"])
        _url = @"//map1b.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi";
    
    return self;
}

- (WVTMatrixSet *)findMatrixSet:(NSString *)name
{
    NSDictionary *matrixSets = self.dict[@"matrixSets"];
    NSDictionary *matrixSet = matrixSets[name];
    if (!matrixSet)
        return nil;
    
    return [[WVTMatrixSet alloc] initWithDict:matrixSet name:name config:self.config];
}

@end

@implementation WVTLayer

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)inName config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = inName;
    _title = dict[@"title"];
    NSString *group = dict[@"group"];
    _baseLayer = [group isEqualToString:@"baselayers"];
    
    return self;
}

// Can't load the geographic data sets quite right at the moment
static const bool UseSphericalMercatorHack = true;

- (MaplyRemoteTileSource *)buildTileSource
{
// https://map1c.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi?TIME=2016-04-23&layer=MODIS_Terra_CorrectedReflectance_TrueColor&tilematrixset=EPSG4326_250m&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=2&TileCol=1&TileRow=1
// https://map1b.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi/TIME=2016-04-23&layer=MODIS_Terra_CorrectedReflectance_TrueColor&tilematrixset=EPSG4326_250m&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=2&TileCol=1&TileRow=1
// https://map1b.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi?TIME=2016-04-23&layer=MODIS_Terra_CorrectedReflectance_TrueColor&tilematrixset=EPSG4326_250m&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=2&TileCol=2&TileRow=2
// https://map1b.vis.earthdata.nasa.gov/wmts-geo/wmts.cgi?TIME=2016-04-23&layer=MODIS_Terra_CorrectedReflectance_TrueColor&tilematrixset=EPSG4326_250m&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=0&TileCol=1&TileRow=0

    // Look through the projections for geographic
    // Note: Geographic is hard coded for now.  We can do others, of course.
    NSDictionary *projDict = self.dict[@"projections"];
    if (!projDict)  return nil;
    NSDictionary *geoDict = projDict[@"geographic"];
    if (!geoDict) {
        NSLog(@"Layer does not support geographic in WVTLayer buildTileSource");
        return nil;
    }
    NSString *sourceName = geoDict[@"source"];
    NSString *matrixSetName = geoDict[@"matrixSet"];
    if (![sourceName isKindOfClass:[NSString class]] || ![matrixSetName isKindOfClass:[NSString class]])
        return nil;
    
    // Figure out the extension
    // Note: Fill out the other types
    NSString *ext = nil;
    NSString *format = self.dict[@"format"];
    if ([format isEqualToString:@"image/jpeg"])
        ext = @"jpg";
    else if ([format isEqualToString:@"image/png"])
        ext = @"png";
    if (!ext)
    {
        NSLog(@"Unknown extension in WVTLayer buildTileSource");
        return nil;
    }
    
    // Now for the source and matrix set
    WVTSource *source = [self.config findSource:sourceName];
    if (!source)
        return nil;
    
    WVTMatrixSet *matrixSet = [source findMatrixSet:matrixSetName];
    
    MaplyRemoteTileSource *tileSource = nil;
    NSString *timeStr = @"2016-04-22";
    if (UseSphericalMercatorHack)
    {
        // Translate from the geographic version to the spherical mercator version (sort of)
        NSString *matrixSetSubst = [NSString stringWithFormat:@"GoogleMapsCompatible_Level%d",matrixSet.maxZoom];
        NSString *baseURL = [NSString stringWithFormat:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/%@/default/%@/%@/{z}/{y}/{x}",self.name,timeStr,matrixSetSubst];
        
        tileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:baseURL ext:ext minZoom:0 maxZoom:matrixSet.maxZoom];
    } else {    
        // Note: Coordinate system is hardwired at the moment.  For shame!
        // This one is a little weird because it extends out past the valid boundaries
        MaplyBoundingBox bbox;
        bbox.ll = MaplyCoordinateMakeWithDegrees(-180,-(576-90));
        bbox.ur = MaplyCoordinateMakeWithDegrees(576-180.0,90.0);
        MaplyCoordinateSystem *coordSys = [[MaplyPlateCarree alloc] initWithBoundingBox:bbox];
        // Note: Shouldn't have to set this twice
        [coordSys setBounds:bbox];
        MaplyBoundingBox validBbox;
        validBbox.ll = MaplyCoordinateMakeWithDegrees(-180,-90);
        validBbox.ur = MaplyCoordinateMakeWithDegrees(180, 90);
        
        // From this we can construct a remote tile info and the tile source
        NSString *baseURL = [NSString stringWithFormat:@"https:%@?TIME=%@&layer=%@&tilematrixset=%@&Service=WMTS&Request=GetTile&Version=1.0.0&Format=%@&TileMatrix={z}&TileCol={x}&TileRow={y}",timeStr,source.url,self.name,matrixSet.name,[format stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];

    //    WMTSTileInfo *tileInfo = [[WMTSTileInfo alloc] initWithBaseURL:baseURL maxZoom:matrixSet.maxZoom];
        WMTSTileInfo *tileInfo = [[WMTSTileInfo alloc] initWithBaseURL:baseURL maxZoom:matrixSet.maxZoom];
        [tileInfo addBoundingBox:&validBbox];
        tileInfo.coordSys = coordSys;
        
        tileInfo.pixelsPerSide = matrixSet.pixelsPerTile;
        tileSource = [[MaplyRemoteTileSource alloc] initWithInfo:tileInfo];
    }
    
    return tileSource;
}

@end

@implementation WVTMeasurementSource

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)inName config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = inName;
    _title = dict[@"title"];
    
    // Look for the layers
    NSArray *settings = dict[@"settings"];
    NSMutableArray *layers = [NSMutableArray array];
    for (NSString *layerName in settings)
    {
        WVTLayer *layer = [config findLayer:layerName];
        if (layer)
            [layers addObject:layer];
        else
            NSLog(@"Can't find layer %@ in WVTMeasurementsource init",layerName);
    }
    _layers = layers;
    
    return self;
}

@end

@implementation WVTMeasurement

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)inName config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = inName;
    _title = dict[@"title"];
    _subTitle = dict[@"subtitle"];
    
    // Look for all the layers
    NSMutableArray *sources = [NSMutableArray array];
    NSDictionary *sourcesDict = dict[@"sources"];
    for (NSString *key in sourcesDict.allKeys)
    {
        NSDictionary *sourceDict = sourcesDict[key];
        WVTMeasurementSource *source = [[WVTMeasurementSource alloc] initWithDict:sourceDict name:key config:config];
        [sources addObject:source];
    }
    _sources = sources;
    
    return self;
}

@end

@implementation WVTCard

- (id)initWithDict:(NSDictionary *)dict name:(NSString *)inName config:(WVTConfig *)config
{
    self = [super initWithDict:dict config:config];
    _name = inName;
    _title = dict[@"title"];
    _imageName = dict[@"image"];
    
    // Look up the measurements
    NSArray *measuresDict = dict[@"measurements"];
    NSMutableArray *measures = [NSMutableArray array];
    for (NSString *measureName in measuresDict)
    {
        WVTMeasurement *measure = [config findMeasurement:measureName];
        if (measure)
            [measures addObject:measure];
        else
            NSLog(@"Missing measurement %@ in WVTCard init",measureName);
    }
    _measurements = measures;
    
    return self;
}

@end

@implementation WVTConfig
{
    NSDictionary *mainDict;
    NSMutableDictionary *layers;
    NSMutableDictionary *sources;
    NSMutableDictionary *measures;
    NSMutableDictionary *cats;
}

- (id)initWithFile:(NSString *)fname
{
    self = [super init];
    
    NSData *data = [NSData dataWithContentsOfFile:fname];

    NSError *error = nil;
    mainDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"Unable to parse configuration file because:\n%@",error);
        return nil;
    }

    // Process the sources
    sources = [NSMutableDictionary dictionary];
    NSDictionary *sourcesDict = mainDict[@"sources"];
    for (NSString *key in sourcesDict.allKeys)
    {
        NSDictionary *sourceDict = sourcesDict[key];
        WVTSource *source = [[WVTSource alloc] initWithDict:sourceDict name:key config:self];
        sources[key] = source;
    }

    // Process the layers
    NSDictionary *layersDict = mainDict[@"layers"];
    if (!layersDict)
        return nil;
    layers = [NSMutableDictionary dictionary];
    for (NSString *key in layersDict.allKeys)
    {
        NSDictionary *layerDict = layersDict[key];
        WVTLayer *layer = [[WVTLayer alloc] initWithDict:layerDict name:key config:self];
        layers[key] = layer;
    }
    
    // Process the measurements
    NSDictionary *measuresDict = mainDict[@"measurements"];
    if (!measuresDict)
        return nil;
    measures = [NSMutableDictionary dictionary];
    for (NSString *key in measuresDict.allKeys)
    {
        NSDictionary *measureDict = measuresDict[key];
        WVTMeasurement *measure = [[WVTMeasurement alloc] initWithDict:measureDict name:key config:self];
        measures[key] = measure;
    }

    // Work through categories and their cards
    cats = [NSMutableDictionary dictionary];
    NSDictionary *catsDict = mainDict[@"categories"];
    for (NSString *key in catsDict.allKeys)
    {
        NSDictionary *catDict = catsDict[key];
        
        // Now for the cards
        NSMutableArray *cards = [NSMutableArray array];
        for (NSString *catKey in catDict.allKeys)
        {
            NSDictionary *cardDict = catDict[catKey];
            WVTCard *card = [[WVTCard alloc] initWithDict:cardDict name:key config:self];
            [cards addObject:card];
        }
        cats[key] = cards;
    }
    
    
    return self;
}

// Look up a layer by its name (rather than id)
- (WVTLayer *)findLayer:(NSString *)name
{
    WVTLayer *layer = layers[name];
    
    return layer;
}

- (WVTSource *)findSource:(NSString *)name
{
    return sources[name];
}

- (WVTMeasurement *)findMeasurement:(NSString *)name
{
    return measures[name];
}

- (NSArray *)findCardsForCategory:(NSString *)category
{
    return cats[category];
}

@end
