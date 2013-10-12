//
//  YURLRequestModel.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YModel.h"
#import "YURLRequestDelegate.h"

/**
 * An implementation of TTModel which is built to work with TTURLRequests.
 *
 * If you use a TTURLRequestModel as the delegate of your TTURLRequests, it will automatically
 * manage many of the TTModel properties based on the state of your requests.
 */
@interface YURLRequestModel : YModel <YURLRequestDelegate> {
    YURLRequest* _loadingRequest;
    
    NSDate*       _loadedTime;
    NSString*     _cacheKey;
    
    BOOL          _isLoadingMore;
    BOOL          _hasNoMore;
}

/**
 * Valid upon completion of the URL request. Represents the timestamp of the completed request.
 */
@property (nonatomic, retain) NSDate*   loadedTime;

/**
 * Valid upon completion of the URL request. Represents the request's cache key.
 */
@property (nonatomic, copy)   NSString* cacheKey;

/**
 * Not used internally, but intended for book-keeping purposes when making requests.
 */
@property (nonatomic) BOOL hasNoMore;

/**
 * Resets the model to its original state before any data was loaded.
 */
- (void)reset;

/**
 * Valid while loading. Returns download progress as between 0 and 1.
 */

- (float)downloadProgress;

/**
 * refresh data
 */
- (void)refreshData:(YURLRequestCachePolicy)cachePolicy;

@end