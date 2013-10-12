//
//  YURLRequestDelegate.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YURLRequest;

@protocol YURLRequestDelegate <NSObject>
@optional

/**
 * The request has begun loading.
 *
 * This method will not be called if the data is loaded immediately from the cache.
 * @see requestDidFinishLoad:
 */
- (void)requestDidStartLoad:(YURLRequest*)request;

/**
 * The request has loaded some more data.
 *
 * Check the totalBytesLoaded and totalBytesExpected properties for details.
 */
- (void)requestDidUploadData:(YURLRequest*)request;

/**
 * The request has loaded data and been processed into a response.
 *
 * If the request is served from the cache, this is the only delegate method that will be called.
 */
- (void)requestDidFinishLoad:(YURLRequest*)request;

/**
 * 304
 */
- (void)requestDidFinishLoad304:(YURLRequest*)request;


/**
 * Allows delegate to handle any authentication challenges.
 */
- (void)request:(YURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge;

/**
 * The request failed to load.
 */
- (void)request:(YURLRequest*)request didFailLoadWithError:(NSError*)error;

/**
 * The request was canceled.
 */
- (void)requestDidCancelLoad:(YURLRequest*)request;

@end
