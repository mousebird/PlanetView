//
//  SimpleDate.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "SimpleDate.h"

@implementation SimpleDate

- (id)initWithYear:(int)year month:(int)month day:(int)day
{
    self = [super init];
    _year = year;
    _month = month;
    _day = day;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%04d-%02d-%02d",_year,_month,_day];
}

@end
