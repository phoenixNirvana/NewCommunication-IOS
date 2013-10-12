//
//  LYWebImageDownloader.m
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYWebImageDownloader.h"
#import "LYURLImageResponse.h"
#import "YURLRequestQueue.h"

@interface LYWebImageDownloader()
@property (nonatomic, retain)LYBaseURLRequest* request;
@end

@implementation LYWebImageDownloader
@synthesize url = _url;
@synthesize delegate = _delegate;
@synthesize imageData = _imageData;
@synthesize userInfo = _userInfo;
@synthesize request = _request;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LY_RELEASE_SAFELY(_url);
    [[YURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
    LY_RELEASE_SAFELY(_request);
    LY_RELEASE_SAFELY(_imageData);
    LY_RELEASE_SAFELY(_userInfo);
    LY_RELEASE_SAFELY(_imageData);
    [super dealloc];
}


+ (id)downloaderWithURL:(NSString*)url userInfo:(id)userInfo delegate:(id<LYWebImageDownloaderDelegate>)delegate
{
    LYWebImageDownloader* downloader = [[[LYWebImageDownloader alloc] init] autorelease];
    downloader.url = url;
    downloader.userInfo = userInfo;
    downloader.delegate = delegate;
//    [downloader performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    return downloader;
}

- (void)start
{
    self.request = [[[LYBaseURLRequest alloc] initWithURL:self.url delegate:self] autorelease];
    
    self.request.cachePolicy = YURLRequestCachePolicyDefault;
    LYURLImageResponse* response = [[LYURLImageResponse alloc] init];
    self.request.response = response;
//    self.request.respondedFromCache = YES;
    LY_RELEASE_SAFELY(response);
    
    [self.request sendQuery:nil];
    if(self.request){
        LY_NSLog(@"LYWebImageDownLoader success");
//        self.imageData = [NSMutableData data];
//        LY_NSLog(@"self.imageData = %@",self.imageData);
        
    }
    else {
        if([self.delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)]){
            [self.delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:nil];
            LY_NSLog(@"LYWebImageDownLoader fail");
        }
    }
}

- (void)cancel
{
    if(self.request){
        [self.request cancel];
        self.request = nil;
    }
}

# pragma YURLRequestDelegate

- (void)requestDidStartLoad:(YURLRequest*)request
{
    
}

- (void)requestDidUploadData:(YURLRequest*)request
{
    
}

- (void)requestDidFinishLoad:(YURLRequest*)request
{
    LYURLImageResponse* imageResponse = (LYURLImageResponse*)request.response;
    
    if ([self.delegate respondsToSelector:@selector(imageDownloader:didFinishWithImage:)]){
        [self.delegate imageDownloader:self didFinishWithImage:imageResponse.image];
    }
}

- (void)request:(YURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
    
}

- (void)request:(YURLRequest*)request didFailLoadWithError:(NSError*)error
{
    // 处理错误
    if([self.delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)]){
        [self.delegate performSelector:@selector(imageDownloader:didFailWithError:) withObject:self withObject:nil];
    }
}

- (void)requestDidCancelLoad:(YURLRequest*)request
{
    
}


@end
