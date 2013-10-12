//
//  YURLRequestQueue.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YURLRequest;

@interface YURLRequestQueue : NSObject {
@private
    NSMutableDictionary*  _loaders;
    
    NSMutableArray*       _loaderQueue;
    NSTimer*              _loaderQueueTimer;
    
    NSInteger             _totalLoading;
    
    NSUInteger            _maxContentLength;
    NSString*             _userAgent;
    NSString*             _ifModifiedSince;
    
    CGFloat               _imageCompressionQuality;
    
    NSTimeInterval        _defaultTimeout;
    
    BOOL                  _suspended;
}

/**
 * Gets the flag that determines if new load requests are allowed to reach the network.
 *
 * Because network requests tend to slow down performance, this property can be used to
 * temporarily delay them.  All requests made while suspended are queued, and when
 * suspended becomes false again they are executed.
 */
@property (nonatomic) BOOL suspended;

/**
 * The maximum size of a download that is allowed.
 *
 * If a response reports a content length greater than the max, the download will be
 * cancelled. This is helpful for preventing excessive memory usage. Setting this to
 * zero will allow all downloads regardless of size.
 *
 * @default 150000 bytes
 */
@property (nonatomic) NSUInteger maxContentLength;

/**
 * The user-agent string that is sent with all HTTP requests.
 * If set to 'nil', User-Agent set by NSURLRequest will be used,
 * which looks like: 'APP_NAME/N.N CFNetwork/NNN Darwin/NN.N.NNN'.
 *
 * @default nil
 */
@property (nonatomic, copy) NSString* userAgent;

/**
 * The compression quality used for encoding images sent with HTTP posts.
 *
 * @default 0.75
 */
@property (nonatomic) CGFloat imageCompressionQuality;


/**
 * The default Timeout used for all TTURLRequests.
 * 
 * This timeout is applied to all requests that have a negative timeout set.
 *
 * The default value is defined as kTimeout in TTURLRequestQueue.m
 *
 * @see TTURLRequest::timeoutInterval
 */
@property (nonatomic) NSTimeInterval defaultTimeout;

/**
 * The ifModifiedSince string that is sent with all HTTP requests.
 * If set to 'nil', don't set If-Modified-Since,
 * @default nil
 */
@property (nonatomic, copy) NSString* ifModifiedSince;

/**
 * Get the shared cache singleton used across the application.
 */
+ (YURLRequestQueue*)mainQueue;

/**
 * Set the shared cache singleton used across the application.
 */
+ (void)setMainQueue:(YURLRequestQueue*)queue;

/**
 * Load a request from the cache or the network if it is not in the cache.
 *
 * @return YES if the request was loaded synchronously from the cache.
 */
- (BOOL)sendRequest:(YURLRequest*)request;

/**
 * Synchronously load a request from the cache or the network if it is not in the cache.
 *
 * @return YES if the request was loaded from the cache.
 */
- (BOOL)sendSynchronousRequest:(YURLRequest*)request;

/**
 * Cancel a request that is in progress.
 */
- (void)cancelRequest:(YURLRequest*)request;

/**
 * Cancel all active or pending requests whose delegate or response is an object.
 *
 * This is useful for when an object is about to be destroyed and you want to remove pointers
 * to it from active requests to prevent crashes when those pointers are later referenced.
 */
- (void)cancelRequestsWithDelegate:(id)delegate;

/**
 * Cancel all active or pending requests.
 */
- (void)cancelAllRequests;

/**
 * Create a Cocoa URL request from a Three20 URL request.
 */
- (NSURLRequest*)createNSURLRequest:(YURLRequest*)request URL:(NSURL*)URL;

@end