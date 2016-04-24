//
//  LayerManager.h
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobeViewController.h"
#import "WVTConfig.h"

// Simple date as Worldview sees it
@interface SimpleDate : NSObject

- (id)initWithYear:(int)year month:(int)month day:(int)day;

@property (assign) int year;
@property (assign) int month;
@property (assign) int day;

@end

/// Manages overall layer display
@interface LayerManager : NSObject

+ (LayerManager *)sharedManager:(GlobeViewController *)globeViewC config:(WVTConfig *)config;

- (id)initWithGlobe:(GlobeViewController *)globeViewC config:(WVTConfig *)config;

// Get or set the date
- (void)setDate:(NSDate *)date;
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
