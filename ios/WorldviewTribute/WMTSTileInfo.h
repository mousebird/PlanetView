//
//  WMTSTileInfo.h
//  WorldviewTribute
//
//  Created by Steve Gifford on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WhirlyGlobeComponent.h>

@interface WMTSTileInfo : MaplyRemoteTileInfo

// Pass in the base URL.  This will mess with the levels to get the calls right
- (id)initWithBaseURL:(NSString *)baseURL maxZoom:(int)maxZoom;

@end
