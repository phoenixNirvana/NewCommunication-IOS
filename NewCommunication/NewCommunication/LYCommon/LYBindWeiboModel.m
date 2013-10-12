//
//  LYBindWeiboModel.m
//  Leyingke
//
//  Created by yu on 12-12-29.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBindWeiboModel.h"
#import "LYRequestUrlMacros.h"

@implementation LYBindWeiboModel

@synthesize username = _username;
@synthesize request  = _request;
@synthesize userid   = _userid;

-(void)dealloc{
    self.username = nil;
    self.request = nil;
    self.userid  = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestAction {
       // LYMainUser* mainUser = [LYMainUser getInstance];
       NSString* url = [NSString stringWithFormat:@"%@/user/weibo/add",KBaseRequestUrl];
        
        if(!self.request){
            LYBaseDataRequest* OnlineRequest = [[LYBaseDataRequest alloc] initWithUrl:url];
            
            
            OnlineRequest.request.cachePolicy = YURLRequestCachePolicyNone;
            OnlineRequest.delegate = self;
            
            self.request = OnlineRequest;
            [OnlineRequest release];
        }
        else{
            [self.request.request cancel];
            [self.request.request setUrlPath:url];
        }
    [self.request.request setHttpMethod:@"POST"];
    [self.request.request.parameters setValue:@"sina" forKey:@"weibotype"];
    [self.request.request.parameters setValue:self.username forKey:@"weiboaccount"];
    [self.request.request.parameters setValue:self.userid forKey:@"weibotype"];
        
    [self.request send];
        
}

#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(YURLRequest*)request {
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(YURLRequest*)request {
        
}

@end
