//
//  YURLRequestQueue+YRequestLoader.h
//  yushiyi
//
//  Created by yu shiyi on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YURLRequestQueue.h"

@interface YURLRequestQueue (YRequestLoader)

- (void)                       loader: (YRequestLoader*)loader
    didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge*)challenge;

- (void)     loader: (YRequestLoader*)loader
    didLoadResponse: (NSHTTPURLResponse*)response
               data: (id)data;

- (void)               loader:(YRequestLoader*)loader
    didLoadUnmodifiedResponse:(NSHTTPURLResponse*)response;

- (void)loader:(YRequestLoader*)loader didFailLoadWithError:(NSError*)error;
- (void)loaderDidCancel:(YRequestLoader*)loader wasLoading:(BOOL)wasLoading;


@end
