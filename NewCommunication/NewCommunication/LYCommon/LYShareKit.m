//
//  LYShareKit.m
//  Leyingke
//
//  Created by yu on 12-12-24.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYShareKit.h"
#import "LYAppDelegate.h"
#import "MBProgressHUD.h"
#import "LYRequestUrlMacros.h"
#import "UIImage+LYAdditions.h"
@implementation LYShareKit

@synthesize sinaweibo;
static LYShareKit *_shareKit;

+ (LYShareKit *)defaultShare
{
    if (nil == _shareKit) {
        _shareKit = [[LYShareKit alloc] init];
    }
    return _shareKit;
}

- (void)dealloc
{
    [sinaweibo release];
    [super dealloc];
}

- (id) init
{
	if (self = [super init]){
//        sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI ssoCallbackScheme:@"weibo://" andDelegate:nil];
        sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        
        //向微信注册
//        [WXApi registerApp:@"wxd67b01a7d45d6faa"];
        [WXApi registerApp:kWeixinAppId]; // 新的微信AppID
        _scene = WXSceneSession;
	}
    
	return self;
}

-(BOOL)isAuthValid{
    return [sinaweibo isAuthValid];
}

-(void)WeibologIndelegate:(id)delegate{
    sinaweibo.delegate = delegate;
    [sinaweibo logIn];
}

-(void)Weibologoutdelegate:(id)delegate{
    sinaweibo.delegate = delegate;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [sinaweibo logOut];
}

-(void)postWeiboStatus:(NSString*)statusText image:(UIImage*)image delegate:(id)delegate{
    //分享
    if (image) {
        [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   statusText, @"status",
                                   image, @"pic", nil]
                       httpMethod:@"POST"
                         delegate:delegate];
    }else{
        [sinaweibo requestWithURL:@"statuses/update.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:statusText, @"status", nil]
                       httpMethod:@"POST"
                         delegate:delegate];
    }
    
}

- (void)getsinaUserInfo:(id)delegate
{
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:delegate];
}

- (void)sinaweiboDidLogOut
{
    [self removeAuthData];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [sinaweibo removeAuthData];
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //add code
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
       //add code
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            [self showHud:@"发送微信成功"];
        }else{
            [self showHud:@"发送微信失败"];
        }
    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        if (resp.errCode == 0) {
//            [self showHud:@"认证微信成功"];
//        }else{
//            [self showHud:@"认证微信失败"];
//        }
//    }
}

-(void)showHud:(NSString*)tip{
    
    LYAppDelegate *appDelegate = (LYAppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow* window = appDelegate.window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tip;
    hud.margin = 10.f;
    hud.yOffset = -10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}


-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

- (void)sendImageAndText:(UIImage*)image data:(NSData*)bigImageData title:(NSString*)title description:(NSString*)description url:(NSString*)url
{
    if (![self isWXAppEffective]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未安装微信或者版本过低" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    if (image!=nil) {
        [message setThumbImage:image];
    }
    else{
        [message setThumbImage:[UIImage middleStretchableImageWithName:@"Icon"]];
    }
    
    WXImageObject* imageObj = [WXImageObject object];
    if (nil != bigImageData) {
        [imageObj setImageData:bigImageData];
        [message setMediaObject:imageObj];
    }
//    WXWebpageObject *ext = [WXWebpageObject object];
//    
//    if(url){
//        ext.webpageUrl = url;//@"http://m.leyingke.com/dl.html";
//    }
//    else{
//        ext.webpageUrl = kDownloadUrl;
//    }
    
//    message.mediaObject = ext;
    
    if ([title length]>170) {
        message.title = [title substringToIndex:169];
    }else{
        message.title = title;
    }
    
    //message.title = title;
    message.description = description;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendImageContent:(UIImage*)image
{
    if (![self isWXAppEffective]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未安装微信或者版本过低" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.imageData = UIImagePNGRepresentation(image);//[NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendTextContent:(NSString*)nsText
{
    
    if (![self isWXAppEffective]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未安装微信或者版本过低" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(BOOL) isWXAppEffective{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

#pragma mark app delegate
- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL ret = YES;
    NSString* scheme = url.scheme;
    if ([scheme compare:[NSString stringWithFormat:@"sinaweibosso.%@", kAppKey]] == NSOrderedSame) {
        ret = [self.sinaweibo handleOpenURL:url];
    }else if([scheme compare:kWeixinAppId] == NSOrderedSame){
        ret = [WXApi handleOpenURL:url delegate:self];
    }
    return ret;
}

- (void)applicationDidBecomeActive
{
    [self.sinaweibo applicationDidBecomeActive];
}


+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_shareKit == nil) {
			_shareKit = [super allocWithZone:zone];  // assignment and return on first allocation
			return _shareKit;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _shareKit;
}

- (id) retain {
	return _shareKit;
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
@end
