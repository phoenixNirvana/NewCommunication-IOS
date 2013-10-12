//
//  LYMainUser.m
//  Leyingke
//
//  Created by 思 高 on 12-9-11.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYMainUser.h"

// mainUser持久化文件名
#define kMainUserFileName @"user"
// 公共目录名
#define kCommonDir @"common"
// 广告存储目录
#define kSplashDir @"splash"
// 广告信息存储名字
#define kSplashName @"splashInfo"
// 广告内容存储名字
#define kSplashData @"splashData"
// 最后一次用户登陆ID
#define kLastLoginUserId            @"kLastLoginUserId"
#define kLastLoginUserName          @"kLastLoginUserName"

@interface LYMainUser ()
// 从持久化数据中读取mainUser
+ (LYMainUser *)readFromDisk:(NSString *)userId;

// 持久化路径
+ (NSString *)persistPath:(NSString *)userId;

@end

static LYMainUser* _instance = nil;

@implementation LYMainUser
@synthesize loginAccount = _loginAccount;
@synthesize md5Password = _md5Password;
@synthesize sessionKey = _sessionKey;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize currentCityId = _currentCityId;
@synthesize currentCityName = _currentCityName;
@synthesize selectedCityId = _selectedCityId;
@synthesize selectedCityName = _selectedCityName;
@synthesize selectedCityLatitude = _selectedCityLatitude;
@synthesize selectedCityLongitude = _selectedCityLongitude;
@synthesize weiboNickName = _weiboNickName;

+ (LYMainUser *) getInstance {
	@synchronized(self) {
		if (_instance == nil) {
            // 看是否有最近的登录用户Id
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [defaults objectForKey:kLastLoginUserId];
            
            if (userId) {
                _instance = [LYMainUser readFromDisk:userId];
                if (!_instance) {
                    _instance = [[LYMainUser alloc] init]; // assignment not done here
#if TARGET_IPHONE_SIMULATOR     //如果是模拟器
                    _instance.selectedCityId = [NSNumber numberWithInt:290];
                    _instance.selectedCityName = @"北京";
#endif
                }
                
            } else {
                // 从未登录过的逻辑
                _instance = [[LYMainUser alloc] init];
#if TARGET_IPHONE_SIMULATOR     //如果是模拟器
                _instance.selectedCityId = [NSNumber numberWithInt:290];
                _instance.selectedCityName = @"北京";
#endif
            }
            _instance.selectedCityId = _instance.currentCityId;
            _instance.selectedCityName = _instance.currentCityName;
		}
	}
    
	return _instance;
}

+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _instance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _instance;
}

- (id) retain {
	return _instance;
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

- (void) dealloc
{
    self.loginAccount = nil;
    self.md5Password = nil;
    self.sessionKey = nil;
    self.currentCityId = nil;
    self.currentCityName = nil;
    self.selectedCityId = nil;
    self.selectedCityName = nil;
    self.weiboNickName = nil;
    self.latitude = nil;
    self.longitude = nil;
	
	[super dealloc];
}

- (id) init
{
	if (self = [super init]){
        self.userId = @"";
	}
    
	return self;
}

- (void) clear
{
    self.loginAccount = nil;
	self.md5Password = nil;
    self.latitude = nil;
    self.longitude = nil;
    self.currentCityId = nil;
    self.currentCityName = nil;
    self.selectedCityId = nil;
    self.selectedCityName = nil;
    // 暂时如此处理 注销登录 bug
	self.sessionKey = @"";
    self.weiboNickName = nil;
}

#pragma mark -
#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
        // 由于兼容 5.0 之前版本，所以key值与属性名不一致
		self.sessionKey = [decoder decodeObjectForKey:@"msessionKey"];
		self.loginAccount = [decoder decodeObjectForKey:@"loginAccount"];
		self.md5Password = [decoder decodeObjectForKey:@"md5Password"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.currentCityId = [decoder decodeObjectForKey:@"currentCityId"];
        self.currentCityName = [decoder decodeObjectForKey:@"currentCityName"];
//        self.selectedCityId = [decoder decodeObjectForKey:@"selectedCityId"];
//        self.selectedCityName = [decoder decodeObjectForKey:@"selectedCityName"];
        self.weiboNickName = [decoder decodeObjectForKey:@"weiboNickName"];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
    
	[encoder encodeObject:self.sessionKey forKey:@"msessionKey"];
    [encoder encodeObject:self.loginAccount forKey:@"loginAccount"];
	[encoder encodeObject:self.md5Password forKey:@"md5Password"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.currentCityId forKey:@"currentCityId"];
    [encoder encodeObject:self.currentCityName forKey:@"currentCityName"];
//    [encoder encodeObject:self.selectedCityId forKey:@"selectedCityId"];
//    [encoder encodeObject:self.selectedCityName forKey:@"selectedCityName"];
    [encoder encodeObject:self.weiboNickName forKey:@"weiboNickName"];
}

#pragma mark -
#pragma mark Public
- (void)persist {
    NSString *userId = self.userId;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:userId forKey:kLastLoginUserId];
    [defaults synchronize];
	
	if (userId) {
        NSString *persistPath = [LYMainUser persistPath:userId];
        [NSKeyedArchiver archiveRootObject:self toFile:persistPath];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logout {
	LYMainUser *mainUser = _instance;
    //    mainUser.isLogin = NO;
	[mainUser clear];
	NSString *userId = [self.userId copy];
    self.userId = nil;
	if (userId) {
        NSString *persistPath = [LYMainUser persistPath:userId];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        [fileMgr removeItemAtPath:persistPath error:nil];
	}
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:kLastLoginUserId];
    
    [userId release];
}

- (BOOL)isMainUserId:(NSString*)anUserId {
	// 在没有id的情况的, 将默认是mainuser
	if (!anUserId) {
		return TRUE;
	}
	
	if (!self.userId) {
		return FALSE;
	}
	
	return NSOrderedSame == [self.userId compare:anUserId] ? TRUE : FALSE;
}

// 从持久化数据中读取mainUser
+ (LYMainUser *)readFromDisk:(NSString *)userId{
    NSString *userFile = [LYMainUser persistPath:userId];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userFile];
}

- (NSString*)sessionKey
{
    //  不知道为啥sessionkey可能为空 cao ~~~~~~
    if(_sessionKey == nil)
        return @"";
    else
        return _sessionKey;
}

- (BOOL) checkLoginInfo
{
	if (self.sessionKey &&  self.sessionKey.length > 0) {
		return YES;
	}
	
	return NO;
}

// App Document 路径
+ (NSString *)documentPath{
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    return path;
}

// 公共文件夹路径
+ (NSString *)commonPath{
    NSString *path = [[LYMainUser documentPath] stringByAppendingPathComponent:kCommonDir];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            LY_NSLog(@"创建 commonPath 失败 %@", error);
        }
    }
    
    return path;
}

// 用户路径
- (NSString *)userDocumentPath{
    NSString *path = [[LYMainUser documentPath] stringByAppendingPathComponent:self.userId];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:path
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            LY_NSLog(@"创建 userDocumentPath 失败 %@", error);
        }
    }
    
    return path;
}

+ (NSString *)persistPath:(NSString *)userId{
    NSString *dirPath = [[LYMainUser documentPath] stringByAppendingPathComponent:userId];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:dirPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            LY_NSLog(@"创建 userDocumentPath 失败 %@", error);
        }
    }
    
    NSString *path = [dirPath stringByAppendingPathComponent:kMainUserFileName];
    return path;
}

- (NSString*)splashPath{
    NSString *dirPath = [[LYMainUser commonPath] stringByAppendingPathComponent:kSplashDir];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:dirPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            LY_NSLog(@"创建 commonPath 失败 %@", error);
        }
    }
    
    NSString* path = [dirPath stringByAppendingPathComponent:kSplashName];
    return path;
}

- (NSString*)splashDataPath{
    NSString *dirPath = [[LYMainUser commonPath] stringByAppendingPathComponent:kSplashDir];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:dirPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error) {
            LY_NSLog(@"创建 commonPath 失败 %@", error);
        }
    }
    
    NSString* path = [dirPath stringByAppendingPathComponent:kSplashData];
    return path;
}

@end
