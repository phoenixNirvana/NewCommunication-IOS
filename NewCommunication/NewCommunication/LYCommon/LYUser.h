//
//  LYUser.h
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUserInfo.h"

@interface LYUser : NSObject<NSCoding>{
	// 表示用户的唯一ID。
	NSString* _userId;
    
    // 从 user.getInfo 获取的用户信息
    LYUserInfo *_userInfo;
	
	// 表示小的用户头像.50*50px
	NSString* _tinyurl;
	
	// 表示中等大小的用户头像.100*100px
	NSString* _headurl;
	
	// 表示中等大小的用户头像.200*200px
	NSString* _mainurl;
	
	// 表示用户的名字.
	NSString* _userName;
	
    // 是否在线
	NSInteger _online;
    
    // 是否注册
    NSInteger _isRegister;
    
    NSString* _phoneNum;
}

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, retain) LYUserInfo *userInfo;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* tinyurl;
@property (nonatomic, copy) NSString* headurl;
@property (nonatomic, copy) NSString* mainurl;
@property (nonatomic, assign)NSInteger online;
@property (nonatomic, assign)NSInteger isRegister;
@property (nonatomic, copy)NSString* phoneNum;

/**
 * 通过用户id初始化.
 */
- (id) initWithUserId:(NSString*)userId;

@end
