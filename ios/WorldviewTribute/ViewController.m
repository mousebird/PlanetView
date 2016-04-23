//
//  ViewController.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "ViewController.h"
#import "GlobeViewController.h"

@interface ViewController ()
{
    GlobeViewController *globeViewC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the globe
    globeViewC = [[GlobeViewController alloc] init];
    [self.view addSubview:globeViewC.view];
    [self addChildViewController:globeViewC];    
}

@end
