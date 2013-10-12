//
//  LYBaseDataRequest.h
//  Leyingke
//
//  Created by 思 高 on 12-9-26.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYBaseURLRequest.h"
#import "YURLRequestDelegate.h"

@protocol LYBaseDataRequestDelegate;
@interface LYBaseDataRequest : NSObject<YURLRequestDelegate>{
    LYBaseURLRequest* _request;
    NSString* _url;
    id<LYBaseDataRequestDelegate> _delegate;
}
@property (nonatomic, retain)LYBaseURLRequest* request;
@property (nonatomic, copy)NSString* url;
@property (nonatomic, assign)id<LYBaseDataRequestDelegate> delegate;

- (id)initWithUrl:(NSString *)url;
- (BOOL)send;

@end

@protocol LYBaseDataRequestDelegate <NSObject>

@optional

- (void)requestDidStartLoad:(YURLRequest*)request;
- (void)requestDidFinishLoad:(YURLRequest*)request;
- (void)requestDidFinishLoad304:(YURLRequest*)request;
- (void)request:(YURLRequest*)request didFailLoadWithError:(NSError*)error;
- (void)requestDidCancelLoad:(YURLRequest*)request;
- (void)requestDidUploadData:(YURLRequest*)request;
- (void)request:(YURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge;

@end

