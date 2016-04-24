//
//  SimpleDate.h
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeComponent.h>

// Simple date as Worldview sees it
@interface SimpleDate : NSObject

- (id)initWithYear:(int)year month:(int)month day:(int)day;

@property (assign) int year;
@property (assign) int month;
@property (assign) int day;

- (SimpleDate *)previousDay;
- (SimpleDate *)nextDay;

@end
