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
    
    // Start over SF
    [self animateToPosition:MaplyCoordinateMakeWithDegrees(-122.416667, 37.783333) time:1.0];
}

// Look up the layer by name and parse out its various connection info
- (void)addLayerByName:(NSString *)layerName
{
    // Get the layer
    WVTLayer *layer = [_config findLayer:layerName];
    if (!layer)
    {
        NSLog(@"Failed to find layer %@",layerName);
        return;
    }
    
    MaplyRemoteTileSource *tileSource = [layer buildTileSource];
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
        [self addLayer:wgLayer];
    } else {
        NSLog(@"Failed to build tile source for layer %@",layerName);
        return;
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
