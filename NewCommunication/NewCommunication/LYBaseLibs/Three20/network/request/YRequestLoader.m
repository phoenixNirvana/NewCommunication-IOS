//
//  YRequestLoader.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YRequestLoader.h"

//Global
#import "YErrorCodes.h"

// Network
#import "YGlobalNetwork.h"
#import "YURLRequest.h"
#import "YURLRequestDelegate.h"
#import "YURLRequestQueue.h"
#import "YURLResponse.h"

// Network (private)
#import "YURLRequestQueue+YRequestLoader.h"

// Core
#import "NSData+YAdditions.h"
#import "NSObject+YAdditions.h"
#import "LYUserfulMacros.h"

#import "LYUserfulMacros.h"


@interface YRequestLoader (Private)
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response ;
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data ;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection ;
@end
static const NSInteger kLoadMaxRetries = 2;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation YRequestLoader

@synthesize urlPath             = _urlPath;
@synthesize requests            = _requests;
@synthesize cacheKey            = _cacheKey;
@synthesize cachePolicy         = _cachePolicy;
@synthesize cacheExpirationAge  = _cacheExpirationAge;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initForRequest:(YURLRequest*)request queue:(YURLRequestQueue*)queue {
	self = [super init];
    if (self) {
        _urlPath            = [request.urlPath copy];
        _queue              = queue;
        _cacheKey           = [request.cacheKey retain];
        _cachePolicy        = request.cachePolicy;
        _cacheExpirationAge = request.cacheExpirationAge;
        _requests           = [[NSMutableArray alloc] init];
        _retriesLeft        = kLoadMaxRetries;
        
        [self addRequest:request];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [_connection cancel];
    LY_RELEASE_SAFELY(_connection);
    LY_RELEASE_SAFELY(_response);
    LY_RELEASE_SAFELY(_responseData);
    LY_RELEASE_SAFELY(_urlPath);
    LY_RELEASE_SAFELY(_cacheKey);
    LY_RELEASE_SAFELY(_requests);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

//////////////////////////////////////////////////////////////////////////////////////////////////
// This method not called from outside,
// used as a separate entry point for performSelector outside connectToURL below
- (void)deliverDataResponse:(NSURL*)URL {
    // http://tools.ietf.org/html/rfc2397
    NSArray * dataSplit = [[URL resourceSpecifier] componentsSeparatedByString:@","];
    if([dataSplit count]!=2) {
       // YDCONDITIONLOG(YDFLAG_URLREQUEST, @"UNRECOGNIZED data: URL %@", self.urlPath);
        return;
    }
    if([[dataSplit objectAtIndex:0] rangeOfString:@"base64"].location == NSNotFound) {
        // Strictly speaking, to be really conformant need to interpret %xx hex encoded entities.
        // The [NSString dataUsingEncoding] doesn't do that correctly, but most documents don't use that.
        // Skip for now.
        _responseData = [[NSMutableData dataWithData:[[dataSplit objectAtIndex:1] dataUsingEncoding:NSASCIIStringEncoding]] retain];
    } else {
        _responseData = [[NSData dataWithBase64EncodedString:[dataSplit objectAtIndex:1]] retain];
    }
    
    [_queue performSelector:@selector(loader:didLoadResponse:data:) 
                 withObject:self
                 withObject:_response 
                 withObject:_responseData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectToURL:(NSURL*)URL {
    //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"Connecting to %@", _urlPath);
    // If this is a data: url, we can decode right here ... after a delay to get out of calling thread
    if([[URL scheme] isEqualToString:@"data"]) {
        [self performSelector:@selector(deliverDataResponse:) withObject:URL afterDelay:0.1];
        return;
    }
    YNetworkRequestStarted();
    
    YURLRequest* request = _requests.count >= 1 ? [_requests objectAtIndex:0] : nil;
    
    // there are situations where urlPath is somehow nil (therefore crashing in
    // createNSURLRequest:URL:, even if we checked for non-blank values before 
    // adding the request to the queue.
    if (!request.urlPath.length)
        [self cancel:request];
    
    NSURLRequest* URLRequest = [_queue createNSURLRequest:request URL:URL];
    
    _connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dispatchLoadedBytes:(NSInteger)bytesLoaded expected:(NSInteger)bytesExpected {
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        request.totalBytesLoaded = bytesLoaded;
        request.totalBytesExpected = bytesExpected;
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(requestDidUploadData:)]) {
                [delegate requestDidUploadData:request];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addRequest:(YURLRequest*)request {
    // TODO (jverkoey April 27, 2010): Look into the repercussions of adding a request with
    // different properties.
    //TTDASSERT([_urlPath isEqualToString:request.urlPath]);
    //TTDASSERT(_cacheKey == request.cacheKey);
    //TTDASSERT(_cachePolicy == request.cachePolicy);
    //TTDASSERT(_cacheExpirationAge == request.cacheExpirationAge);
    
    [_requests addObject:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeRequest:(YURLRequest*)request {
    [_requests removeObject:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(NSURL*)URL {
    if (nil == _connection) {
        [self connectToURL:URL];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadSynchronously:(NSURL*)URL {
    // This method simulates an asynchronous network connection. If your delegate isn't being called
    // correctly, this would be the place to start tracing for errors.
    YNetworkRequestStarted();
    
    YURLRequest* request = _requests.count >= 1 ? [_requests objectAtIndex:0] : nil;
    NSURLRequest* URLRequest = [_queue createNSURLRequest:request URL:URL];
    
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection
                    sendSynchronousRequest: URLRequest
                    returningResponse: &response
                    error: &error];
    
    if (nil != error) {
        YNetworkRequestStopped();
        
        LY_RELEASE_SAFELY(_responseData);
        LY_RELEASE_SAFELY(_connection);
        
        [_queue loader:self didFailLoadWithError:error];
        
    } else {
        [self connection:nil didReceiveResponse:(NSHTTPURLResponse*)response];
        [self connection:nil didReceiveData:data];
        
        [self connectionDidFinishLoading:nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)cancel:(YURLRequest*)request {
    NSUInteger requestIndex = [_requests indexOfObject:request];
    if (requestIndex != NSNotFound) {
        request.isLoading = NO;
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(requestDidCancelLoad:)]) {
                [delegate requestDidCancelLoad:request];
            }
        }
        
        [_requests removeObjectAtIndex:requestIndex];
    }
    
    if (![_requests count]) {
        [_queue loaderDidCancel:self wasLoading:!!_connection];
        if (nil != _connection) {
            YNetworkRequestStopped();
            [_connection cancel];
            LY_RELEASE_SAFELY(_connection);
        }
        return NO;
        
    } else {
        return YES;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSError*)processResponse:(NSHTTPURLResponse*)response data:(id)data {
    for (YURLRequest* request in _requests) {
        NSError* error = nil;
        // We need to accept valid HTTP status codes, not only 200.
        NSLog(@"%d",response.statusCode);
        if (!response || ![response respondsToSelector:@selector(statusCode)]
            || (response.statusCode >= 200 && response.statusCode < 300)
            || response.statusCode == 304) {
            NSLog(@"test response statusCode=%d",response.statusCode);
            error = [request.response request:request processResponse:response data:data];
        } else {
            if ([request.response respondsToSelector:@selector(request:processErrorResponse:data:)]) {
                error = [request.response request:request processErrorResponse:response data:data];
            }
            // Supply an NSError object if request.response's
            // request:processErrorResponse:data: does not return one.
            if (!error) {
                //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"  FAILED LOADING (%d) %@", _response.statusCode, _urlPath);
                NSDictionary* userInfo = [NSDictionary dictionaryWithObject:data forKey:kYErrorResponseDataKey];
                error = [NSError errorWithDomain:NSURLErrorDomain code:_response.statusCode userInfo:userInfo];
            }
        }
        if (error) {
            return error;
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dispatchError:(NSError*)error {
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        request.isLoading = NO;
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
                [delegate request:request didFailLoadWithError:error];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dispatchLoaded:(NSDate*)timestamp {
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        request.timestamp = timestamp;
        request.isLoading = NO;
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(requestDidFinishLoad:)]) {
                [delegate requestDidFinishLoad:request];
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dispatchLoaded304{
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        request.isLoading = NO;
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(requestDidFinishLoad304:)]) {
                [delegate requestDidFinishLoad304:request];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dispatchAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        
        for (id<YURLRequestDelegate> delegate in request.delegates) {
            if ([delegate respondsToSelector:@selector(request:didReceiveAuthenticationChallenge:)]) {
                [delegate request:request didReceiveAuthenticationChallenge:challenge];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
    NSArray* requestsToCancel = [_requests copy];
    for (id request in requestsToCancel) {
        [self cancel:request];
    }
    [requestsToCancel release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    _response = [response retain];
    
    LY_NSLog(@"response-headers=%@",[response allHeaderFields]);
    if ([response respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary* headers = [response allHeaderFields];
        int contentLength = [[headers objectForKey:@"Content-Length"] intValue];
        
        // If you hit this assertion it's because a massive file is about to be downloaded.
        // If you're sure you want to do this, add the following line to your app delegate startup
        // method. Setting the max content length to zero allows anything to go through. If you just
        // want to raise the limit, set it to any positive byte size.
        // [[TTURLRequestQueue mainQueue] setMaxContentLength:0]
       // YDASSERT(0 == _queue.maxContentLength || contentLength <=_queue.maxContentLength);
        
        if (contentLength > _queue.maxContentLength && _queue.maxContentLength) {
            //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"MAX CONTENT LENGTH EXCEEDED (%d) %@",
                           // contentLength, _urlPath);
            [self cancel];
        }
        
        _responseData = [[NSMutableData alloc] initWithCapacity:contentLength];
        
        for (YURLRequest* request in [[_requests copy] autorelease]) {
            request.totalContentLength = contentLength;
        }
        
    }else {
        _responseData = [[NSMutableData alloc] init];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    
    [_responseData appendData:data];
    for (YURLRequest* request in [[_requests copy] autorelease]) {
        request.totalBytesDownloaded += [data length];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSCachedURLResponse *)connection: (NSURLConnection *)connection
                  willCacheResponse: (NSCachedURLResponse *)cachedResponse {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)           connection: (NSURLConnection *)connection
              didSendBodyData: (NSInteger)bytesWritten
            totalBytesWritten: (NSInteger)totalBytesWritten
    totalBytesExpectedToWrite: (NSInteger)totalBytesExpectedToWrite {
    [self dispatchLoadedBytes:totalBytesWritten expected:totalBytesExpectedToWrite];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    YNetworkRequestStopped();
    
   // YDCONDITIONLOG(YDFLAG_ETAGS, @"Response status code: %d", _response.statusCode);
    if (![_response respondsToSelector:@selector(statusCode)]){
        [_queue loader:self didLoadResponse:_response data:_responseData];
    } else if (_response.statusCode == 304) {
        [_queue loader:self didLoadUnmodifiedResponse:_response];
    } else {
        [_queue loader:self didLoadResponse:_response data:_responseData];
    }
    
    LY_RELEASE_SAFELY(_responseData);
    LY_RELEASE_SAFELY(_connection);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //YDCONDITIONLOG(YDFLAG_URLREQUEST, @"  RECEIVED AUTH CHALLENGE LOADING %@ ", _urlPath);
    [_queue loader:self didReceiveAuthenticationChallenge:challenge];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   // YDCONDITIONLOG(YDFLAG_URLREQUEST, @"  FAILED LOADING %@ FOR %@", _urlPath, error);
    
    YNetworkRequestStopped();
    
    LY_RELEASE_SAFELY(_responseData);
    LY_RELEASE_SAFELY(_connection);
    
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCannotFindHost
        && _retriesLeft) {
        // If there is a network error then we will wait and retry a few times in case
        // it was just a temporary blip in connectivity.
        --_retriesLeft;
        [self load:[NSURL URLWithString:_urlPath]];
        
    } else {
        [_queue loader:self didFailLoadWithError:error];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Accessors


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_connection;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Deprecated
 */
- (NSString*)URL {
    return _urlPath;
}


@end