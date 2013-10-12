//
//  UIDevice+LYAdditions.h
//  Leyingke
//
//  Created by 思 高 on 12-9-11.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (LYAdditions)

// 获取MAC地址
+ (NSString *)macAddress;
// 设备是否是iPad
+ (BOOL)isDeviceiPad;
// 获取机器型号
+ (NSString *)machineModel;
// 获取机器型号名称
+ (NSString *)machineModelName;
// 对低端机型的判断
+ (BOOL)isLowLevelMachine;
// 设备可用空间
// freespace/1024/1024/1024 = B/KB/MB/14.02GB
+(NSNumber *)freeSpace;
// 设备总空间
+(NSNumber *)totalSpace;
// 获取运营商信息
+ (NSString *)carrierName;
// 获取运营商代码
+ (NSString *)carrierCode;
//获取电池电量
+ (CGFloat) getBatteryValue;
//获取电池状态
+ (NSInteger) getBatteryState;
// 是否能发短信 不准确
+ (BOOL) canDeviceSendMessage;


// 内存信息
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;


@end
