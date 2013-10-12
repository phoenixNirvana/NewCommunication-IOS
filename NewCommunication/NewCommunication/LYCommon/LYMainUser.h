//
//  LYMainUser.h
//  Leyingke
//
//  Created by 思 高 on 12-9-11.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYUser.h"

@interface LYMainUser : LYUser<NSCoding>{
    // 登录名
    NSString* _loginAccount;
    
    // 加密的登陆密码
    NSString* _md5Password;
    
    // 登陆成功后的session key
    NSString* _sessionKey;
    
    // 当前经纬度
    NSNumber* _latitude;
    
    NSNumber* _longitude;
    
    // 当前城市ID
    NSNumber* _currentCityId;
    // 当前城市名
    NSString* _currentCityName;
    
    // 选择的城市id
    NSNumber* _selectedCityId;
    // 选择的城市名
    NSString* _selectedCityName;
    
    double _selectedCityLatitude;
    double _selectedCityLongitude;
    
    //新浪微博昵称
    NSString* _weiboNickName;
}
@property (nonatomic, copy)NSString* loginAccount;
@property (nonatomic, copy)NSString* md5Password;
@property (nonatomic, copy)NSString* sessionKey;
@property (nonatomic, retain)NSNumber* latitude;
@property (nonatomic, retain)NSNumber* longitude;
@property (nonatomic, retain)NSNumber* currentCityId;
@property (nonatomic, copy)NSString* currentCityName;
@property (nonatomic, copy)NSString* selectedCityName;
@property (nonatomic, retain)NSNumber* selectedCityId;
@property (nonatomic, assign)double selectedCityLatitude;
@property (nonatomic, assign)double selectedCityLongitude;
@property (nonatomic, copy)NSString* weiboNickName;

+ (LYMainUser*)getInstance;

/**
 * 持久化存档。
 */
- (void)persist;

/**
 * 登出动作，仅修改了MainUser的状态和数值。
 */
- (void)logout;

/**
 * 清空MainUser对象数据。一般在切换登录用户时，或者登出时使用。
 */
- (void) clear;

/**
 * 判断是否为登录用户的id.
 * 
 * @param userId 被判断的用户id
 * @return 如果是登录用户,返回TRUE,否则返回FALSE.
 */
- (BOOL)isMainUserId:(NSString*)userId;

/*
 * 是否包含了登录信息，若包含可进行自动登录
 */
- (BOOL) checkLoginInfo;

// App Document 路径
+ (NSString *)documentPath;

// 公共文件夹路径
+ (NSString *)commonPath;

// 用户路径
- (NSString *)userDocumentPath;

// 广告路径
- (NSString*)splashPath;

// 广告数据路径
- (NSString*)splashDataPath;
@end
