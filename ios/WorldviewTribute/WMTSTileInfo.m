//
//  WMTSTileInfo.m
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import "WMTSTileInfo.h"

@implementation WMTSTileInfo

- (id)initWithBaseURL:(NSString *)baseURL maxZoom:(int)maxZoom
{
//    self = [super initWithBaseURL:baseURL ext:nil minZoom:1 maxZoom:maxZoom+1];
    self = [super initWithBaseURL:baseURL ext:nil minZoom:3 maxZoom:maxZoom+1];
    
    return self;
}

- (NSURLRequest *)requestForTile:(MaplyTileID)tileID
{
    int adjLevel = tileID.level - 1;
    int y = ((int)(1<<tileID.level)-tileID.y)-1;
//    int y = tileID.y;
    
    // Fetch the traditional way
    NSString *fullURLStr = [[[self.baseURL stringByReplacingOccurrencesOfString:@"{z}" withString:[@(adjLevel) stringValue]]
                             stringByReplacingOccurrencesOfString:@"{x}" withString:[@(tileID.x) stringValue]]
                            stringByReplacingOccurrencesOfString:@"{y}" withString:[@(y) stringValue]];
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURLStr]];
    
    NSLog(@"Requesting: %@",fullURLStr);
    
    return urlReq;
}

@end
