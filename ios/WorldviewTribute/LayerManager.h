//
//  LayerManager.h
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeComponent.h>
#import "GlobeViewController.h"
#import "WVTConfig.h"
#import "SimpleDate.h"

/// Manages overall layer display
@interface LayerManager : NSObject

+ (LayerManager *)sharedLayerManager:(GlobeViewController *)globeViewC config:(WVTConfig *)config;
+ (LayerManager *)sharedLayerManager;

- (id)init;

- (id)initWithGlobe:(GlobeViewController *)globeViewC config:(WVTConfig *)config;

// Get or set the date
- (void)setDate:(SimpleDate *)date;
- (SimpleDate *)getDate;

// Add a layer to be displayed
- (void)addLayer:(WVTLayer *)layer;

// Remove a layer form the possible display list
- (void)removeLayer:(WVTLayer *)layer;

// Turn a layer on if it was off
- (void)enableLayer:(WVTLayer *)layer;

// Turn a layer off it it was on
- (void)disableLayer:(WVTLayer *)layer;

// Get base layers or overlay layers
- (NSArray *)getLayers:(bool)baseLayer;

@end
