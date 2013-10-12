//
//  LYApplicationManager.h
//  Leyingke
//
//  Created by yu on 12-10-29.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYApplicationManager : NSObject<UIAlertViewDelegate>

// 是否安装
+ (BOOL)isValid:(NSString*)url;

// 安装
+ (void)setup;


// 打开应用程序
+ (void)openApplicationWithDialogAndCallback:(NSString *)callback;

@end
