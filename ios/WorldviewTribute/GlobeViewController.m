//
//  GlobeViewController.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "GlobeViewController.h"

@interface LocalLayer : NSObject
@property MaplyQuadImageTilesLayer *wgLayer;
@property WVTLayer *wvtLayer;
@end

@implementation LocalLayer
@end

@interface GlobeViewController ()

@end

@implementation GlobeViewController
{
    NSMutableArray *activeLayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activeLayers = [NSMutableArray array];
    
    self.keepNorthUp = true;
    
    // Start over SF
    [self animateToPosition:MaplyCoordinateMakeWithDegrees(-122.416667, 37.783333) time:1.0];
}

- (LocalLayer *)findLocalLayer:(WVTLayer *)wvtLayer
{
    for (LocalLayer *layer in activeLayers)
    {
        if (layer.wvtLayer == wvtLayer)
            return layer;
    }
    
    return nil;
}

- (void)addWVTLayer:(WVTLayer *)layer forTime:(NSString *)timeStr
{
    if ([self findLocalLayer:layer])
        return;
    
    LocalLayer *localLayer = [[LocalLayer alloc] init];
    localLayer.wvtLayer = layer;

    MaplyRemoteTileSource *tileSource = [layer buildTileSource:timeStr];
    if (tileSource)
    {
        MaplyQuadImageTilesLayer *wgLayer = [[MaplyQuadImageTilesLayer alloc] initWithTileSource:tileSource];
        wgLayer.flipY = true;
        if (layer.baseLayer)
        {
            wgLayer.coverPoles = true;
            wgLayer.handleEdges = true;
        } else{
            wgLayer.coverPoles = false;
            wgLayer.handleEdges = false;
        }
        wgLayer.drawPriority = layer.drawPriority*100;
        localLayer.wgLayer = wgLayer;
        [self addLayer:wgLayer];
    } else {
        NSLog(@"Failed to build tile source for layer %@",layer.name);
        return;
    }
    
    [activeLayers addObject:localLayer];
}

- (void)removeWVTLayer:(WVTLayer *)layer
{
    LocalLayer *localLayer = [self findLocalLayer:layer];
    if (localLayer)
    {
        [self removeLayer:localLayer.wgLayer];
        [activeLayers removeObject:localLayer];
    }
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
