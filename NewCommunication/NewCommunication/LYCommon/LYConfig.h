//
//  LYConfig.h
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYConfig : NSObject{
    //应用App Store的ID（AppleID）
    NSString *_appStoreId;
    // 应用App Store的Bundle ID
    NSString *_appBundleID;
    // 客户端名称
    NSString *_clientName;
    // 客户端版本
    NSString *_version;
    // 设备型号
    NSString *_deviceModel;
    // 客户端信息（client_info）
    NSDictionary *_clientInfo;
    //v: 服务版本号 
    NSString *_v;
    // 客户端当前的语言环境
    NSString *_currentLanguage;
    // 客户端发布日期
    NSString *_pubdate;
    // UA信息
    NSString* _userAgent;
}
+ (LYConfig* )globalConfig;
+ (void)setGlobalConfig:(LYConfig *)config;

// udid 取设备 MAC(兼容)
- (NSString *)udid;

//应用App Store的ID（AppleID）
@property (nonatomic, copy) NSString *appStoreId;
// 应用App Store的Bundle ID
@property (nonatomic, copy) NSString *appBundleID;
// 客户端名称
@property (nonatomic, copy) NSString *clientName;
// 客户端版本
@property (nonatomic, copy) NSString *version;
// 设备型号
@property (nonatomic, copy) NSString *deviceModel;
// 客户端信息（client_info）
@property (nonatomic, retain) NSDictionary *clientInfo;

@property (nonatomic, copy) NSString *v;
@property (nonatomic, copy) NSString *currentLanguage;
@property (nonatomic, copy) NSString *pubdate;
@property (nonatomic, copy) NSString* userAgent;

- (void)updateUserAgent;

@end
