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
    
    [self testAdding];
}

// Test adding a couple of layers by name
- (void)testAdding
{
    [globeViewC addLayerByName:@"MODIS_Terra_CorrectedReflectance_TrueColor"];
    [globeViewC addLayerByName:@"MODIS_Terra_Aerosol"];
}

@end
