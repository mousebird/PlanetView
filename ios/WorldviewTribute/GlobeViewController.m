//
//  GlobeViewController.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "GlobeViewController.h"

@interface GlobeViewController ()

@end

@implementation GlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keepNorthUp = true;

    // Note: This is just a test set of layers
    [self addLayer:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/" ext:@"jpg" baseLayer:true];
    [self addLayer:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/Sea_Surface_Temp_Blended/default/2015-06-25/GoogleMapsCompatible_Level7/{z}/{y}/{x}" ext:@"png" baseLayer:false];
    
    // Start over SF
    [self animateToPosition:MaplyCoordinateMakeWithDegrees(-122.416667, 37.783333) time:1.0];
}

// Add an image layer with URL and extension.
- (void)addLayer:(NSString *)url ext:(NSString *)ext baseLayer:(bool)isBaseLayer
{
    MaplyRemoteTileSource *tileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:url ext:ext minZoom:0 maxZoom:7];
    MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithTileSource:tileSource];
    if (isBaseLayer)
    {
        layer.coverPoles = true;
        layer.handleEdges = true;
    } else{
        layer.coverPoles = false;
        layer.handleEdges = false;
    }
    [self addLayer:layer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
