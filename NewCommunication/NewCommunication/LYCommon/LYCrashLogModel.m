//
//  LYCrashLogModel.m
//  Leyingke
//
//  Created by yu on 12-11-28.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYCrashLogModel.h"
#import "YGlobalCore.h"
#import "YGlobalNetwork.h"
#import "LYURLJsonResponse.h"
#import "YURLRequest.h"
#import "LYRequestUrlMacros.h"


//static NSString* kCrashLog = @"http://115.182.92.238/zh-CN/backends/logupload/";
static NSString* kCrashLog = @"http://115.182.92.238/backends/logupload/";

@implementation LYCrashLogModel

@synthesize errLog;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    self.errLog = nil;
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(YURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading/* && YIsStringWithAnyText(_url)*/) {

        YURLRequest* request = [YURLRequest
                                requestWithURL:kCrashLog
                                delegate:self];
        request.httpMethod = @"POST";
        
        request.cachePolicy = YURLRequestCachePolicyNoCache;
        request.cacheExpirationAge = Y_CACHE_EXPIRATION_AGE_NEVER;
        
        LYURLJsonResponse* response = [[LYURLJsonResponse alloc] init];
        request.response = response;
        //request.multiPartForm = false;
        LY_RELEASE_SAFELY(response);
        
        //头信息
//        LYConfig* config = [LYConfig globalConfig];
//        [config updateUserAgent];
        [request addFile:self.errLog mimeType:@"text/plain" fileName:kCrashLogPath key:@"logfile"];
        
        [request send];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(YURLRequest*)request {
    //如果是首页，先清除缓存数据
    NSString *path = [NSString stringWithFormat:@"%@/%@",[LYMainUser documentPath],kCrashLogPath];
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
        LY_NSLog(@"delete crashlog error:%@",error);
    }
    [super requestDidFinishLoad:request];
}
@end
