//
//  ViewController.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "ViewController.h"
#import "GlobeViewController.h"
#import "WVTConfig.h"

@interface ViewController ()
{
    GlobeViewController *globeViewC;
    WVTConfig *config;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the globe
    globeViewC = [[GlobeViewController alloc] init];
    [self.view addSubview:globeViewC.view];
    [self addChildViewController:globeViewC];
    
    // Configuration file for the UI
    NSString *configName = [[NSBundle mainBundle] pathForResource:@"wv" ofType:@"json"];
    config = [[WVTConfig alloc] initWithFile:configName];
    globeViewC.config = config;
    
//    [self testAdding];
    [self testCategory];
}

// Test adding a couple of layers by name
- (void)testAdding
{
    [globeViewC addLayerByName:@"VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1"];
//    [globeViewC addLayerByName:@"MODIS_Terra_CorrectedReflectance_TrueColor"];
    [globeViewC addLayerByName:@"AIRS_Dust_Score"];
//    [globeViewC addLayerByName:@"MODIS_Terra_Aerosol"];
}

- (void)testCategory
{
    // Look for the cards and then pick one
    NSArray *cards = [config findCardsForCategory:@"hazards and disasters"];
    WVTCard *card = [cards objectAtIndex:1];
    
    // Display some of the layers in this card
    // There's some overlap in the layers
    NSMutableSet *layers = [NSMutableSet set];
    for (WVTMeasurement *measure in card.measurements)
    {
        for (WVTMeasurementSource *source in measure.sources)
        {
            for (WVTLayer *layer in source.layers)
            {
                [layers addObject:layer];
                
                break;
            }
            
            break;
        }
    }
    
    // Add the base layers first
    for (WVTLayer *layer in layers)
    {
        if (layer.baseLayer)
        {
            [globeViewC addLayerByName:layer.name];
            break;
        }
    }
    
    // Then the overlays
    for (WVTLayer *layer in layers)
        if (!layer.baseLayer)
            [globeViewC addLayerByName:layer.name];
}

@end
