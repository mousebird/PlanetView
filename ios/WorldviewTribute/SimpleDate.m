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

- (SimpleDate *)previousDay
{
    int newDay = _day-1;
    int newMonth = _month;
    int newYear = _year;
    if (newDay < 1)
    {
        newDay = 28;
        newMonth--;
    }
    if (newMonth < 1)
    {
        newMonth = 12;
        newYear--;
    }
    
    return [[SimpleDate alloc] initWithYear:newYear month:newMonth day:newDay];
}

- (SimpleDate *)nextDay
{

    int newDay = _day+1;
    int newMonth = _month;
    int newYear = _year;
    if (newDay > 28)
    {
        newDay = 1;
        newMonth++;
    }
    if (newMonth > 12)
    {
        newMonth = 1;
        newYear++;
    }
    
    return [[SimpleDate alloc] initWithYear:newYear month:newMonth day:newDay];
}

@end
