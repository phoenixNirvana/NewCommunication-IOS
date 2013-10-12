//
//  LYUserInfo.h
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYUserInfo : NSObject{
    // 指定用户的性别
    NSString *_gender;
    
    // 用户绑定的手机号
    NSString *_bindedMobile;
    
    // 用户年龄
    NSString* _age;
    
    // 用户昵称
    NSString* _nickName;
}
@property (nonatomic, copy)NSString* gender;
@property (nonatomic, copy)NSString* bindedMobile;
@property (nonatomic, copy)NSString* age;
@property (nonatomic, copy)NSString* nickName;

@end
