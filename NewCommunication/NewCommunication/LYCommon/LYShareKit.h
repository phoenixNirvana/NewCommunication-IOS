//
//  LYShareKit.h
//  Leyingke
//
//  Created by yu on 12-12-24.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "WXApi.h"


#define kAppKey             @"3408541489"
#define kAppSecret          @"4425d4db59821901ce005d679674d881"
#define kAppRedirectURI     @"http://www.leyingke.com/lykweb/home/info"
#define kWeixinAppId @"wx59db7fd86d3344f7"


#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif


@interface LYShareKit : NSObject<WXApiDelegate>{
    SinaWeibo *sinaweibo;
    enum WXScene _scene;
}

@property (readonly, nonatomic) SinaWeibo *sinaweibo;

+ (LYShareKit *)defaultShare;
//- (void)setDelegate:(id)delegate;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)applicationDidBecomeActive;

//微薄
-(BOOL)isAuthValid;
-(void)WeibologIndelegate:(id)delegate;
-(void)Weibologoutdelegate:(id)delegate;
- (void)getsinaUserInfo:(id)delegate;
-(void)postWeiboStatus:(NSString*)statusText image:(UIImage*)image delegate:(id)delegate;
-(void)sinaweiboDidLogOut;
-(void)removeAuthData;
//微信
-(void) changeScene:(NSInteger)scene;
-(void) sendImageContent:(UIImage*)image;
-(void) sendTextContent:(NSString*)nsText;
- (void)sendImageAndText:(UIImage*)image data:(NSData*)bigImageData title:(NSString*)title description:(NSString*)description url:(NSString*)url;
-(BOOL) isWXAppEffective;
//提示
-(void)showHud:(NSString*)tip;

//支付宝支付
+(void)alixPay:(id)data;

@end
