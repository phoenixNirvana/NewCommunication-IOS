//
//  LYStartup.m
//  Leyingke
//
//  Created by yu on 12-12-28.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYStartup.h"
#import <UIKit/UIKit.h>
#import "LYURLJsonResponse.h"
#import "LYAppDelegate.h"
#import "MBProgressHUD.h"



static LYStartup *_startup;

@interface LYStartup(){
}

@end

@implementation LYStartup
@synthesize request  = _request;
@synthesize downurl  = _downurl;
@synthesize failtip;

-(void)dealloc{
    self.request = nil;
    self.downurl = nil;
    self.failtip = nil;
    [super dealloc];
}

+ (LYStartup *)defaultShare
{
    if (nil == _startup) {
        _startup = [[LYStartup alloc] init];
    }
    return _startup;
}

+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_startup == nil) {
			_startup = [super allocWithZone:zone];  // assignment and return on first allocation
			return _startup;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _startup;
}

- (id) retain {
	return _startup;
}

- (unsigned) retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void) release {
	// do nothing
}

- (id) autorelease {
	return self;
}

- (BOOL)canShowSplashView
{
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestAction {
    self.failtip = NO;
    // LYMainUser* mainUser = [LYMainUser getInstance];
    NSString* url = [NSString stringWithFormat:@"%@/clientversion/update",kBaseRequestUrl2];
    
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
    };
    
    [self.request send];
}

- (void) requestActionFailtip {
    self.failtip = YES;
    // LYMainUser* mainUser = [LYMainUser getInstance];
    NSString* url = [NSString stringWithFormat:@"%@/clientversion/update",kBaseRequestUrl2];
    
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
    };
    
    [self.request send];
    
    
}
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(YURLRequest*)request {
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(YURLRequest*)request {
   LYURLJsonResponse* response = request.response;
    NSDictionary* data = response.rootObject;
    NSDictionary* res = [data objectForKey:@"respond"];
    if(res){
        if([[res objectForKey:@"status"] intValue] != 200){
            // 错误
            return;
        }
    }
    else{
        // 错误
        return;
    }
    
    NSDictionary* clientversion = [data objectForKey:@"clientversion"];
    
    if (clientversion) {
       // NSString* location_version = [LYConfig globalConfig].version;
       // NSString* remote_version = [clientversion objectForKey:@"client_version"];
       // if([remote_version floatValue] > [location_version floatValue]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[clientversion objectForKey:@"title"]
                                                            message:[clientversion objectForKey:@"content"]
                                                           delegate:self
                                                  cancelButtonTitle:@"忽略本次"
                                                  otherButtonTitles:@"立即升级",nil];
            [alert show];
            [alert release];
            self.downurl = [clientversion objectForKey:@"dl_url"];
        //}
    }else if(self.failtip){
//        [self showHUD:@"无版本更新"];
        UIAlertView* alertView = [[[UIAlertView alloc]initWithTitle:@"已经是最新版本了！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil]autorelease];
        [alertView show];
    }
}
/*
 * 弹出错误title的HUD
 */
- (void)showHUD:(NSString*)test{
    LYAppDelegate* deg = [[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:deg.window maskFrame:CGRectMake(0, 0, deg.window.width, deg.window.height-CONTENT_NAVIGATIONBAR_HEIGHT*2) animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = test;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // cancel, do nothing
    }else if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downurl]];
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(YURLRequest*)request didFailLoadWithError:(NSError*)error {
    if (self.failtip) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LYUpdateError" object:error];
    }
}

@end
