//
//  YGlobalNetwork.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Y_DEFAULT_CACHE_INVALIDATION_AGE (60*60*24)    // 1 day
#define Y_DEFAULT_CACHE_EXPIRATION_AGE   (60*60*24*7)  // 1 week
#define Y_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf

/**
 * Increment the number of active network requests.
 *
 * The status bar activity indicator will be spinning while there are active requests.
 *
 * @threadsafe
 */
void YNetworkRequestStarted();

/**
 * Decrement the number of active network requests.
 *
 * The status bar activity indicator will be spinning while there are active requests.
 *
 * @threadsafe
 */
void YNetworkRequestStopped();

///////////////////////////////////////////////////////////////////////////////////////////////////
// Images

#define YIMAGE(_URL) [[YURLCache sharedCache] imageForURL:_URL]