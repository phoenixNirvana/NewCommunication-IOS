//
//  YURLRequestCachePolicy.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Facts concerning cache policies:
 *
 * - Using NoCache will also disable Etag support.
 */
typedef enum {
    YURLRequestCachePolicyNone    = 0,
    YURLRequestCachePolicyMemory  = 1,
    YURLRequestCachePolicyDisk    = 2,
    YURLRequestCachePolicyNetwork = 4,
    YURLRequestCachePolicyNoCache = 8,
    YURLRequestCachePolicyEtag    = 16 | YURLRequestCachePolicyDisk,
    YURLRequestCachePolicyLocal
    = (YURLRequestCachePolicyMemory | YURLRequestCachePolicyDisk),
    YURLRequestCachePolicyDefault
    = (YURLRequestCachePolicyMemory | YURLRequestCachePolicyDisk
       | YURLRequestCachePolicyNetwork),
} YURLRequestCachePolicy;

