//
//  LayerManager.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "LayerManager.h"

@implementation LayerManager
{
    GlobeViewController *globeViewC;
    WVTConfig *config;
    NSMutableArray *activeLayers;
    SimpleDate *date;
}

static LayerManager *theManager = nil;

+ (LayerManager *)sharedLayerManager:(GlobeViewController *)globeViewC config:(WVTConfig *)config
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                   ^{
                       if (globeViewC)
                           theManager = [[self alloc] initWithGlobe:globeViewC config:config];
                   });
    return theManager;
}

+ (LayerManager *)sharedLayerManager
{
    return theManager;
}

- (id)init
{
    return nil;
}

- (id)initWithGlobe:(GlobeViewController *)inGlobeViewC config:(WVTConfig *)inConfig
{
    self = [super init];
    globeViewC = inGlobeViewC;
    config = inConfig;
    activeLayers = [NSMutableArray array];
    date = [[SimpleDate alloc] initWithYear:2016 month:4 day:20];
    
    return self;
}

// Add a layer to be displayed
- (void)addLayer:(WVTLayer *)layer
{
    if (![activeLayers containsObject:layer])
    {
        layer.isActive = true;
        [activeLayers addObject:layer];
    }
    
    if (!layer.isDisplayed)
    {
        [globeViewC addWVTLayer:layer forTime:[date description]];
        layer.isDisplayed = true;
    }
}

// Remove a layer form the possible display list
- (void)removeLayer:(WVTLayer *)layer
{
    if ([activeLayers containsObject:layer])
    {
        layer.isActive = false;
        [activeLayers removeObject:layer];
    }
    
    if (layer.isDisplayed)
    {
        [globeViewC removeWVTLayer:layer];
        layer.isDisplayed = false;
    }
}

// Turn a layer on if it was off
- (void)enableLayer:(WVTLayer *)layer
{
    if (!layer.isDisplayed)
        [self addLayer:layer];
}

// Turn a layer off it it was on
- (void)disableLayer:(WVTLayer *)layer
{
    if (![activeLayers containsObject:layer])
        return;
    
    if (layer.isDisplayed)
    {
        layer.isDisplayed = false;
        [globeViewC removeWVTLayer:layer];
    }
}

// Get base layers or overlay layers
- (NSArray *)getLayers:(bool)baseLayer
{
    NSMutableArray *ret = [NSMutableArray array];
    for (WVTLayer *layer in activeLayers)
    {
        if (baseLayer && layer.baseLayer)
            [ret addObject:layer];
        else if (!baseLayer && !layer.baseLayer)
            [ret addObject:layer];
    }
    
    return ret;
}

- (void)setDate:(SimpleDate *)inDate
{
    date = inDate;
    // Note: Refresh all the various layers
}

- (SimpleDate *)getDate
{
    return date;
}

@end
