//
//  YUserInfo.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YUserInfo.h"

@implementation YUserInfo
@synthesize topic     = _topic;
@synthesize strongRef = _strongRef;
@synthesize weakRef   = _weakRef;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)topic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef {
    return [[[YUserInfo alloc] initWithTopic:topic strongRef:strongRef weakRef:weakRef] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)topic:(NSString*)topic {
    return [[[YUserInfo alloc] initWithTopic:topic strongRef:nil weakRef:nil] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)weakRef:(id)weakRef {
    return [[[YUserInfo alloc] initWithTopic:nil strongRef:nil weakRef:weakRef] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTopic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef {
	self = [super init];
    if (self) {
        self.topic      = topic;
        self.strongRef  = strongRef;
        self.weakRef    = weakRef;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    LY_RELEASE_SAFELY(_topic);
    LY_RELEASE_SAFELY(_strongRef);
    [super dealloc];
}
@end
