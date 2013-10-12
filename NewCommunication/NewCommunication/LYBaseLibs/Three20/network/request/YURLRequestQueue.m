//
//  YURLRequestQueue.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YURLRequestQueue.h"
// Network
#import "YGlobalNetwork.h"
#import "YURLRequest.h"
#import "YURLRequestDelegate.h"
#import "YUserInfo.h"
#import "YURLResponse.h"
#import "YURLCache.h"
#import "YGlobalCorePaths.h"
#import "YGlobalCore.h"

// Network (Private)
#import "YRequestLoader.h"
#import "YURLRequestCachePolicy.h"
#import "YURLResponse.h"


static const NSTimeInterval kFlushDelay = 0.3;
static const NSTimeInterval kTimeout = 300.0;
static const NSInteger kMaxConcurrentLoads = 5;
//static NSUInteger kDefaultMaxContentLength = 150000;//150K
static NSUInteger kDefaultMaxContentLength = 1500000;

static YURLRequestQueue* gMainQueue = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation YURLRequestQueue

@synthesize maxContentLength        = _maxContentLength;
@synthesize userAgent               = _userAgent;
@synthesize suspended               = _suspended;
@synthesize imageCompressionQuality = _imageCompressionQuality;
@synthesize defaultTimeout          = _defaultTimeout;
@synthesize ifModifiedSince         = _ifModifiedSince;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (YURLRequestQueue*)mainQueue {
    if (!gMainQueue) {
        gMainQueue = [[YURLRequestQueue alloc] init];
    }
    return gMainQueue;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setMainQueue:(YURLRequestQueue*)queue {
    if (gMainQueue != queue) {
        [gMainQueue release];
        gMainQueue = [queue retain];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [super init];
    if (self) {
        _loaders = [[NSMutableDictionary alloc] init];
        _loaderQueue = [[NSMutableArray alloc] init];
        _maxContentLength = kDefaultMaxContentLength;
        _imageCompressionQuality = 0.75;
        _defaultTimeout = kTimeout;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [_loaderQueueTimer invalidate];
    LY_RELEASE_SAFELY(_loaders);
    LY_RELEASE_SAFELY(_loaderQueue);
    LY_RELEASE_SAFELY(_userAgent);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * TODO (jverkoey May 3, 2010): Clean up this redundant code.
 */
- (BOOL)dataExistsInBundle:(NSString*)URL {
    NSString* path = YPathForBundleResource([URL substringFromIndex:9]);
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)dataExistsInDocuments:(NSString*)URL {
    NSString* path = YPathForDocumentsResource([URL substringFromIndex:12]);
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadFromBundle:(NSString*)URL error:(NSError**)error {
    NSString* path = YPathForBundleResource([URL substringFromIndex:9]);
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [NSData dataWithContentsOfFile:path];
        
    } else if (error) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:NSFileReadNoSuchFileError userInfo:nil];
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)loadFromDocuments:(NSString*)URL error:(NSError**)error {
    NSString* path = YPathForDocumentsResource([URL substringFromIndex:12]);
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [NSData dataWithContentsOfFile:path];
        
    } else if (error) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:NSFileReadNoSuchFileError userInfo:nil];
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)loadFromCache: (NSString*)URL
             cacheKey: (NSString*)cacheKey
              expires: (NSTimeInterval)expirationAge
             fromDisk: (BOOL)fromDisk
                 data: (id*)data
                error: (NSError**)error
            timestamp: (NSDate**)timestamp {
   // YDASSERT(nil != data);
    
    if (nil == data) {
        return NO;
    }
    
    UIImage* image = [[YURLCache sharedCache] imageForURL:URL fromDisk:fromDisk];
    
    if (nil != image) {
        *data = image;
        return YES;
        
    } else if (fromDisk) {
        if (YIsBundleURL(URL)) {
            *data = [self loadFromBundle:URL error:error];
            return YES;
            
        } else if (YIsDocumentsURL(URL)) {
            *data = [self loadFromDocuments:URL error:error];
            return YES;
            
        } else {
            *data = [[YURLCache sharedCache] dataForKey:cacheKey expires:expirationAge
                                               timestamp:timestamp];
            if (*data) {
                return YES;
            }
        }
    }
    
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)cacheDataExists: (NSString*)URL
               cacheKey: (NSString*)cacheKey
                expires: (NSTimeInterval)expirationAge
               fromDisk: (BOOL)fromDisk {
    BOOL hasData = [[YURLCache sharedCache] hasImageForURL:URL fromDisk:fromDisk];
    
    if (!hasData && fromDisk) {
        if (YIsBundleURL(URL)) {
            hasData = [self dataExistsInBundle:URL];
            
        } else if (YIsDocumentsURL(URL)) {
            hasData = [self dataExistsInDocuments:URL];
            
        } else {
            hasData = [[YURLCache sharedCache] hasDataForKey:cacheKey expires:expirationAge];
        }
    }
    
    return hasData;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)loadRequestFromCache:(YURLRequest*)request {
    if (!request.cacheKey) {
        request.cacheKey = [[YURLCache sharedCache] keyForURL:request.urlPath];
    }
    
    if (IS_MASK_SET(request.cachePolicy, YURLRequestCachePolicyEtag)) {
        // Etags always make the request. The request headers will then include the etag.
        // - If there is new data, server returns 200 with data.
        // - Otherwise, returns a 304, with empty request body.
        return NO;
        
    } else if (request.cachePolicy & (YURLRequestCachePolicyDisk|YURLRequestCachePolicyMemory)) {
        id data = nil;
        NSDate* timestamp = nil;
        NSError* error = nil;
        
        if ([self loadFromCache:request.urlPath cacheKey:request.cacheKey
                        expires:request.cacheExpirationAge
                       fromDisk:!_suspended && (request.cachePolicy & YURLRequestCachePolicyDisk)
                           data:&data error:&error timestamp:&timestamp]) {
            request.isLoading = NO;
            
            if (!error) {
                error = [request.response request:request processResponse:nil data:data];
            }
            
            if (error) {
                for (id<YURLRequestDelegate> delegate in request.delegates) {
                    if ([delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
                        [delegate request:request didFailLoadWithError:error];
                    }
                }
                
            } else {
                request.timestamp = timestamp ? timestamp : [NSDate date];
                request.respondedFromCache = YES;
                
                for (id<YURLRequestDelegate> delegate in request.delegates) {
                    if ([delegate respondsToSelector:@selector(requestDidFinishLoad:)]) {
                        [delegate requestDidFinishLoad:request];
                    }
                }
            }
            
            return YES;
        }
    }
    
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)executeLoader:(YRequestLoader*)loader {
    id data = nil;
    NSDate* timestamp = nil;
    NSError* error = nil;
    
    if ((loader.cachePolicy & (YURLRequestCachePolicyDisk|YURLRequestCachePolicyMemory))
        && [self loadFromCache:loader.urlPath cacheKey:loader.cacheKey
                       expires:loader.cacheExpirationAge
                      fromDisk:loader.cachePolicy & YURLRequestCachePolicyDisk
                          data:&data error:&error timestamp:&timestamp]) {
            [_loaders removeObjectForKey:loader.cacheKey];
            
            if (!error) {
                error = [loader processResponse:nil data:data];
            }
            if (error) {
                [loader dispatchError:error];
                
            } else {
                [loader dispatchLoaded:timestamp];
            }
            
        } else {
            ++_totalLoading;
            [loader load:[NSURL URLWithString:loader.urlPath]];
        }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadNextInQueueDelayed {
    if (!_loaderQueueTimer) {
        _loaderQueueTimer = [NSTimer scheduledTimerWithTimeInterval:kFlushDelay target:self
                                                           selector:@selector(loadNextInQueue) userInfo:nil repeats:NO];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadNextInQueue {
    _loaderQueueTimer = nil;
    
    for (int i = 0;
         i < kMaxConcurrentLoads && _totalLoading < kMaxConcurrentLoads
         && _loaderQueue.count;
         ++i) {
        YRequestLoader* loader = [[_loaderQueue objectAtIndex:0] retain];
        [_loaderQueue removeObjectAtIndex:0];
        [self executeLoader:loader];
        [loader release];
    }
    
    if (_loaderQueue.count && !_suspended) {
        [self loadNextInQueueDelayed];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeLoader:(YRequestLoader*)loader {
    --_totalLoading;
    [_loaders removeObjectForKey:loader.cacheKey];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSuspended:(BOOL)isSuspended {
    //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"SUSPEND LOADING %d", isSuspended);
    _suspended = isSuspended;
    
    if (!_suspended) {
        [self loadNextInQueue];
        
    } else if (_loaderQueueTimer) {
        [_loaderQueueTimer invalidate];
        _loaderQueueTimer = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)sendRequest:(YURLRequest*)request {
    if ([self loadRequestFromCache:request]) {
        return YES;
    }
    
    for (id<YURLRequestDelegate> delegate in request.delegates) {
        if ([delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
            [delegate requestDidStartLoad:request];
        }
    }
    
    // If the url is empty, fail.
    if (!request.urlPath.length) {
        NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
                [delegate request:request didFailLoadWithError:error];
            }
        }
        return NO;
    }
    
    request.isLoading = YES;
    
    YRequestLoader* loader = nil;
    
    // If we're not POSTing or PUTting data, let's see if we can jump on an existing request.
    if (![request.httpMethod isEqualToString:@"POST"]
        && ![request.httpMethod isEqualToString:@"PUT"]) {
        // Next, see if there is an active loader for the URL and if so join that bandwagon.
        loader = [_loaders objectForKey:request.cacheKey];
        if (loader) {
            [loader addRequest:request];
            return NO;
        }
    }
    
    // Finally, create a new loader and hit the network (unless we are suspended)
    loader = [[YRequestLoader alloc] initForRequest:request queue:self];
    [_loaders setObject:loader forKey:request.cacheKey];
    if (_suspended || _totalLoading == kMaxConcurrentLoads) {
        [_loaderQueue addObject:loader];
        
    } else {
        ++_totalLoading;
//        NSLog(@"%@",request.urlPath);
//        NSURL* urlns = [NSURL URLWithString:request.urlPath];
//        NSLog(@"%@",urlns.absoluteString);
        [loader load:[NSURL URLWithString:request.urlPath]];
    }
    [loader release];
    
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)sendSynchronousRequest:(YURLRequest*)request {
    if ([self loadRequestFromCache:request]) {
        return YES;
    }
    
    for (id<YURLRequestDelegate> delegate in request.delegates) {
        if ([delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
            [delegate requestDidStartLoad:request];
        }
    }
    
    if (!request.urlPath.length) {
        NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
                [delegate request:request didFailLoadWithError:error];
            }
        }
        return NO;
    }
    
    request.isLoading = YES;
    
    // Finally, create a new loader and hit the network (unless we are suspended)
    YRequestLoader* loader = [[YRequestLoader alloc] initForRequest:request queue:self];
    
    // Should be decremented eventually by loadSynchronously
    ++_totalLoading;
    
    [loader loadSynchronously:[NSURL URLWithString:request.urlPath]];
    LY_RELEASE_SAFELY(loader);
    
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancelRequest:(YURLRequest*)request {
    if (request) {
        YRequestLoader* loader = [_loaders objectForKey:request.cacheKey];
        if (loader) {
            [loader retain];
            if (![loader cancel:request]) {
                [_loaderQueue removeObject:loader];
            }
            [loader release];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancelRequestsWithDelegate:(id)delegate {
    NSMutableArray* requestsToCancel = nil;
    
    for (YRequestLoader* loader in [_loaders objectEnumerator]) {
        for (YURLRequest* request in loader.requests) {
            for (id<YURLRequestDelegate> requestDelegate in request.delegates) {
                if (delegate == requestDelegate) {
                    if (!requestsToCancel) {
                        requestsToCancel = [NSMutableArray array];
                    }
                    [requestsToCancel addObject:request];
                    break;
                }
            }
            
            if ([request.userInfo isKindOfClass:[YUserInfo class]]) {
                YUserInfo* userInfo = request.userInfo;
                if (userInfo.weakRef && userInfo.weakRef == delegate) {
                    if (!requestsToCancel) {
                        requestsToCancel = [NSMutableArray array];
                    }
                    [requestsToCancel addObject:request];
                }
            }
        }
    }
    
    for (YURLRequest* request in requestsToCancel) {
        [self cancelRequest:request];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancelAllRequests {
    for (YRequestLoader* loader in [[[_loaders copy] autorelease] objectEnumerator]) {
        [loader cancel];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest*)createNSURLRequest:(YURLRequest*)request URL:(NSURL*)URL {
    if (!URL) {
        URL = [NSURL URLWithString:request.urlPath];
    }
    
    NSTimeInterval usedTimeout = request.timeoutInterval;
    
    if (usedTimeout < 0.0 || request == nil) {
        usedTimeout = self.defaultTimeout;
    }
    
    NSMutableURLRequest* URLRequest = [NSMutableURLRequest requestWithURL:URL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:usedTimeout];
    
    if (self.userAgent) {
        [URLRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    if (request) {
        [URLRequest setHTTPShouldHandleCookies:request.shouldHandleCookies];
        
        NSString* method = request.httpMethod;
        if (method) {
            [URLRequest setHTTPMethod:method];
        }
        
        NSString* contentType = request.contentType;
        if (contentType) {
            [URLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        //add for modified
        if (request.cachePolicy != YURLRequestCachePolicyNoCache) {
            NSData* modifiedData = [[YURLCache sharedCache] modifiedForKey:request.cacheKey];
            if (modifiedData) {
//                NSString* modifiedstr = [[[NSString alloc] initWithData:modifiedData encoding:NSUTF8StringEncoding] autorelease];
//                [URLRequest setValue:modifiedstr forHTTPHeaderField:@"If-Modified-Since"];
            }
        }
        
        NSData* body = request.httpBody;
        if (body) {
            [URLRequest setHTTPBody:body];
        }
        
        NSDictionary* headers = request.headers;
        for (NSString *key in [headers keyEnumerator]) {
            [URLRequest setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        
        if (![[YURLCache sharedCache] disableDiskCache]
            && IS_MASK_SET(request.cachePolicy, YURLRequestCachePolicyEtag)) {
            NSString* etag = [[YURLCache sharedCache] etagForKey:request.cacheKey];
           // YDCONDITIONLOG(YDFLAG_ETAGS, @"Etag: %@", etag);
            
            if (YIsStringWithAnyText(etag)
                && [self cacheDataExists: request.urlPath
                                cacheKey: request.cacheKey
                                 expires: request.cacheExpirationAge
                                fromDisk: !_suspended
                    && (request.cachePolicy & YURLRequestCachePolicyDisk)]) {
                    // By setting the etag here, we let the server know what the last "version" of the file
                    // was that we saw. If the file has changed since this etag, we'll get data back in our
                    // response. Otherwise we'll get a 304.
                    [URLRequest setValue:etag forHTTPHeaderField:@"If-None-Match"];
                }
        }
    }
    
    LY_NSLog(@"Request url=%@,method=%@,head=%@,body=%@",[URLRequest URL].absoluteString,[URLRequest HTTPMethod],[URLRequest allHTTPHeaderFields],[URLRequest HTTPBody]);
    
    return URLRequest;
}


@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation YURLRequestQueue (YRequestLoader)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)     loader: (YRequestLoader*)loader
    didLoadResponse: (NSHTTPURLResponse*)response
               data: (id)data {
    [loader retain];
    [self removeLoader:loader];
    
    NSError* error = [loader processResponse:response data:data];

    if (error) {
        [loader dispatchError:error];
        
    } else {
        if (!(loader.cachePolicy & YURLRequestCachePolicyNoCache)) {
            
            // Store the etag key if the etag cache policy has been requested.
//            if (![[YURLCache sharedCache] disableDiskCache]
//                && IS_MASK_SET(loader.cachePolicy, YURLRequestCachePolicyEtag)) {
//                NSDictionary* headers = [response allHeaderFields];
//                
//                // First, try to use the casing as defined by the standard for ETag headers.
//                // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
//                NSString* etag = [headers objectForKey:@"ETag"];
//                if (nil == etag) {
//                    // Some servers don't use the standard casing (e.g. twitter).
//                    etag = [headers objectForKey:@"Etag"];
//                }
//                
//                // Still no etag?
//                if (nil == etag) {
//                    //YDWARNING(@"Etag expected, but none found.");
//                    //YDWARNING(@"Here are the headers: %@", headers);
//                    
//                } else {
//                    // At last, we have our etag. Let's cache it.
//                    
//                    // First, let's pull out the etag key. This is necessary due to some servers who append
//                    // information to the etag, such as -gzip for a gzipped request. However, the etag
//                    // standard states that etags are defined as a quoted string, and that is all.
//                    NSRange firstQuote = [etag rangeOfString:@"\""];
//                    NSRange secondQuote = [etag rangeOfString: @"\""
//                                                      options: 0
//                                                        range: NSMakeRange(firstQuote.location + 1,
//                                                                           etag.length
//                                                                           - (firstQuote.location + 1))];
//                    if (0 == firstQuote.length || 0 == secondQuote.length ||
//                        firstQuote.location == secondQuote.location) {
//                        //YDWARNING(@"Invalid etag format. Unable to find a quoted key.");
//                        
//                    } else {
//                        NSRange keyRange;
//                        keyRange.location = firstQuote.location;
//                        keyRange.length = (secondQuote.location - firstQuote.location) + 1;
//                        NSString* etagKey = [etag substringWithRange:keyRange];
//                       // YDCONDITIONLOG(YDFLAG_ETAGS, @"Response etag: %@", etagKey);
//                        [[YURLCache sharedCache] storeEtag:etagKey forKey:loader.cacheKey];
//                    }
//                }
//            }
            
            //add modified
            NSDictionary* headers = [response allHeaderFields];
            NSString* modified = [headers objectForKey:@"Last-Modified"];
            if (modified) {
                [[YURLCache sharedCache] storeModified:modified forKey:loader.cacheKey];
            }
            
            [[YURLCache sharedCache] storeData:data forKey:loader.cacheKey];
        }
        [loader dispatchLoaded:[NSDate date]];
    }
    [loader release];
    
    [self loadNextInQueue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)               loader:(YRequestLoader*)loader
    didLoadUnmodifiedResponse:(NSHTTPURLResponse*)response {
    [loader retain];
    [self removeLoader:loader];
    
    NSData* data = nil;
    NSError* error = nil;
    NSDate* timestamp = nil;
    if ([self loadFromCache:loader.urlPath cacheKey:loader.cacheKey
                    expires:Y_CACHE_EXPIRATION_AGE_NEVER
                   fromDisk:!_suspended && (loader.cachePolicy & YURLRequestCachePolicyDisk)
                       data:&data error:&error timestamp:&timestamp]) {
        
        if (nil == error) {
            error = [loader processResponse:response data:data];
        }
        
        if (nil == error) {
            for (YURLRequest* request in loader.requests) {
                request.respondedFromCache = YES;
            }
            [loader dispatchLoaded:[NSDate date]];
        }
    }
    
    if (nil != error) {
        [loader dispatchError:error];
    }
    
    [loader dispatchLoaded304];
    
    [loader release];
    
    [self loadNextInQueue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)                       loader: (YRequestLoader*)loader
    didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge*) challenge {
    //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"CHALLENGE: %@", challenge);
    [loader dispatchAuthenticationChallenge:challenge];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loader:(YRequestLoader*)loader didFailLoadWithError:(NSError*)error {
    //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"ERROR: %@", error);
    [self removeLoader:loader];
    [loader dispatchError:error];
    [self loadNextInQueue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loaderDidCancel:(YRequestLoader*)loader wasLoading:(BOOL)wasLoading {
    if (wasLoading) {
        [self removeLoader:loader];
        [self loadNextInQueue];
        
    } else {
        [_loaders removeObjectForKey:loader.cacheKey];
    }
}


@end
