//
//  LYConfig.m
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYConfig.h"
#import "LYMainUser.h"
//#import "SBJsonWriter.h"

static LYConfig *_globalConfig = nil;

@implementation LYConfig
@synthesize appStoreId = _appStoreId;
@synthesize appBundleID = _appBundleID;
@synthesize clientName = _clientName;
@synthesize version = _version;
@synthesize deviceModel = _deviceModel;
@synthesize clientInfo = _clientInfo;
@synthesize v = _v;
@synthesize currentLanguage = _currentLanguage;
@synthesize pubdate = _pubdate;
@synthesize userAgent = _userAgent;

- (void)dealloc
{
    self.appStoreId = nil;
    self.appBundleID = nil;
    self.clientName = nil;
    self.version = nil;
    self.deviceModel = nil;
    self.clientInfo = nil;
    self.v = nil;
    self.currentLanguage = nil;
    self.userAgent = nil;
    
    [super dealloc]; 
}

- (NSString *)udid{
    return [UIDevice macAddress];
}

+ (LYConfig* )globalConfig {
    if(!_globalConfig) {
        _globalConfig = [[LYConfig alloc] init];
    }
    
    return _globalConfig;
}

+ (void)setGlobalConfig:(LYConfig *)config {
    if (_globalConfig != config) {
        [_globalConfig release];
        _globalConfig = [config retain];
    }
}

- (id)init {
    self = [super init]; 
    if (self) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        UIDevice *device = [UIDevice currentDevice];
        UIScreen *screen = [UIScreen mainScreen];
        //应用App Store的ID（AppleID）
        self.appStoreId = @"316709252";
        
        // 应用App Store的Bundle ID
        self.appBundleID = [infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
        
        // 客户端名称
        self.clientName = @"xiaonei_iphone";
        
        // 客户端版本
        self.version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
        
        // 设备型号
        self.deviceModel = [UIDevice machineModelName];
        
        // 客户端信息（client_info）
        CGSize screenSize = screen.bounds.size;
        NSString *otherStr = @"";
        NSString *carrierCode = [UIDevice carrierCode];
        if (carrierCode) {
            otherStr = [otherStr stringByAppendingString:carrierCode];
        }
        otherStr = [otherStr stringByAppendingString:@","];
        
        self.clientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.deviceModel, @"model",
                                    [UIDevice macAddress],@"uniqid",
                                    [UIDevice macAddress], @"mac",
                                    [NSString stringWithFormat:@"%@%@", device.systemName, device.systemVersion], @"os" , 
                                    [NSString stringWithFormat:@"%.0fX%.0f", screenSize.width, screenSize.height], @"screen",
                                    self.version, @"version",
                                    otherStr, @"other",
                                    nil];
        NSString* sidStr = @"";
        NSString* sid = [LYMainUser getInstance].userId;
        if(!sid){
            sidStr = @"";
        }
        else{
            sidStr = sid;
        }
        NSString* cityId = @"";
        if([LYMainUser getInstance].currentCityId){
            cityId = [NSString stringWithFormat:@"%d",[[LYMainUser getInstance].currentCityId intValue]];
        }
        
        self.userAgent = [NSString stringWithFormat:@"{\"mac\":\"%@\",\"deviceName\":\"%@\",\"deviceVersion\":\"%@\",\"screen\":\"%@\",\"clientVersion\":\"%@\",\"sid\":\"%@\",\"cityid\":\"%@\"}",[UIDevice macAddress],self.deviceModel,device.systemVersion,[NSString stringWithFormat:@"%.0f*%.0f", screenSize.width, screenSize.height],self.version,sidStr,cityId];
        
//        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
//        self.clientInfo = [jsonWriter stringWithObject:clientInfo];
//        [jsonWriter release];
        
        self.v = @"1.0";
        self.currentLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        self.pubdate = @"20121101";
    }
    return self;
}

- (void)updateUserAgent
{
    NSString* sid = [LYMainUser getInstance].userId;
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    NSString* cityId = @"";
    if([LYMainUser getInstance].currentCityId){
        cityId = [NSString stringWithFormat:@"%d",[[LYMainUser getInstance].currentCityId intValue]];
    }
    
    self.userAgent = [NSString stringWithFormat:@"{\"mac\":\"%@\",\"deviceName\":\"%@\",\"deviceVersion\":\"%@\",\"screen\":\"%@\",\"clientVersion\":\"%@\",\"sid\":\"%@\",\"cityid\":\"%@\"}",[UIDevice macAddress],self.deviceModel,device.systemVersion,[NSString stringWithFormat:@"%.0f*%.0f", screenSize.width, screenSize.height],self.version,sid,cityId];//@"qvjkl-4942"
}


@end
