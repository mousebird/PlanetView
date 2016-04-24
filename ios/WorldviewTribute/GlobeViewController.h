//
//  GlobeViewController.h
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import <WhirlyGlobeComponent.h>
#import "WVTConfig.h"

@interface GlobeViewController : WhirlyGlobeViewController

// Configuration file we'll look up into
@property WVTConfig *config;

// Add a specific layer definition
- (void)addWVTLayer:(WVTLayer *)layer forTime:(NSString *)timeStr;

// Remove a specific layer
- (void)removeWVTLayer:(WVTLayer *)layer;

@end
