//
//  LYBaseDataRequest.m
//  Leyingke
//
//  Created by 思 高 on 12-9-26.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseDataRequest.h"
#import "LYURLJsonResponse.h"
#import "YURLRequestQueue.h"

@implementation LYBaseDataRequest
@synthesize request = _request;
@synthesize url = _url;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [[YURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
    [_request cancel];
    LY_RELEASE_SAFELY(_request);
    LY_RELEASE_SAFELY(_url);
    [super dealloc];
}

- (id)initWithUrl:(NSString *)url
{
    if(self = [super init]){
        self.url = url;
        self.request = [[[LYBaseURLRequest alloc] initWithURL:url delegate:self] autorelease];
        
        self.request.cachePolicy = YURLRequestCachePolicyNoCache;
        LYURLJsonResponse* response = [[LYURLJsonResponse alloc] init];
        self.request.response = response;
        LY_RELEASE_SAFELY(response);
    }
    return self;
}

- (BOOL)send
{
    if(self.request){
        return[self.request sendQuery:nil];
    }
    return FALSE;
}

# pragma YURLRequestDelegate

- (void)requestDidStartLoad:(YURLRequest*)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
        [self.delegate requestDidStartLoad:request];
    }
}

- (void)requestDidUploadData:(YURLRequest*)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidUploadData:)]){
        [self.delegate requestDidUploadData:request];
    }
}

- (void)requestDidFinishLoad:(YURLRequest*)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
        [self.delegate requestDidFinishLoad:request];
    }
}

- (void)requestDidFinishLoad304:(YURLRequest*)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidFinishLoad304:)]){
        [self.delegate requestDidFinishLoad304:request];
    }
}


- (void)request:(YURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didReceiveAuthenticationChallenge:)]){
        [self.delegate request:request didReceiveAuthenticationChallenge:challenge];
    }
}

- (void)request:(YURLRequest*)request didFailLoadWithError:(NSError*)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
        [self.delegate request:request didFailLoadWithError:error];
    }
}

- (void)requestDidCancelLoad:(YURLRequest*)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
        [self.delegate requestDidCancelLoad:request];
    }
}


@end
