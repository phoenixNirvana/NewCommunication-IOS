//
//  YRequestLoader.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLRequestCachePolicy.h"
#import "LYUserfulMacros.h"

@class YURLRequestQueue;
@class YURLRequest;

/**
 * The loader manages a set of TTURLRequests and makes the necessary callbacks for each.
 * It implements the NSURLConnectionDelegate protocol and calls the required operations on the
 * queue as the protocol methods are invoked.
 *
 * NSURLErrorCannotFindHost errors are retried at least twice before completely giving up.
 *
 * The loader collects identical GET TTURLRequests into a single object. This logic is handled in
 * TTURLRequestQueue's sendRequest.
 * For all other TTURLRequest types, they will each have their own loader.
 */
@interface YRequestLoader : NSObject
{
    NSString*               _urlPath;
    
    YURLRequestQueue*      _queue;
    
    NSString*               _cacheKey;
    YURLRequestCachePolicy _cachePolicy;
    NSTimeInterval          _cacheExpirationAge;
    
    NSMutableArray*         _requests;
    NSURLConnection*        _connection;
    
    NSHTTPURLResponse*      _response;
    NSMutableData*          _responseData;
    
    /**
     * When load requests fail we'll attempt the request again, as many as 2 times by default.
     */
    int                     _retriesLeft;
}

/**
 * The list of TTURLRequests currently attached to this loader.
 */
@property (nonatomic, readonly) NSArray* requests;

/**
 * The common urlPath shared by every request.
 */
@property (nonatomic, readonly) NSString* urlPath;

/**
 * The common cacheKey shared by every request.
 */
@property (nonatomic, readonly) NSString* cacheKey;

/**
 * The common cache policy shared by every request.
 */
@property (nonatomic, readonly) YURLRequestCachePolicy cachePolicy;

/**
 * The common cache expiration age shared by ever request.
 */
@property (nonatomic, readonly) NSTimeInterval cacheExpirationAge;

/**
 * Whether or not any of the requests in this loader are loading.
 */
@property (nonatomic, readonly) BOOL isLoading;

/**
 * Deprecated due to name ambiguity. Use urlPath instead.
 * Remove after May 6, 2010.
 */
@property (nonatomic, readonly) NSString* URL __YDEPRECATED_METHOD;


- (id)initForRequest:(YURLRequest*)request queue:(YURLRequestQueue*)queue;

/**
 * Duplication is possible due to the use of an NSArray for the request list.
 */
- (void)addRequest:(YURLRequest*)request;
- (void)removeRequest:(YURLRequest*)request;

/**
 * If the loader isn't already active, create the NSURLRequest from the first TTURLRequest added
 * to this loader and fire it off.
 */
- (void)load:(NSURL*)URL;

/**
 * As with load:, will create the NSURLRequest from the first TTURLRequest added to the loader.
 * Unlike load:, this method will not return until the request has been fully completed.
 *
 * This is useful for threads that need to block while waiting for resources from the net.
 */
- (void)loadSynchronously:(NSURL*)URL;

/**
 * Cancel only the given request.
 *
 * @return NO   If there are no requests left.
 *         YES  If there are any requests left.
 */
- (BOOL)cancel:(YURLRequest*)request;

- (NSError*)processResponse:(NSHTTPURLResponse*)response data:(id)data;
- (void)dispatchError:(NSError*)error;
- (void)dispatchLoaded:(NSDate*)timestamp;
- (void)dispatchLoaded304;
- (void)dispatchAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge;
- (void)cancel;

@end
