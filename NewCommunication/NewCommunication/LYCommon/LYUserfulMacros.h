//
//  LYUserfulMacros.h
//  Leyingke
//
//  Created by 思 高 on 12-9-5.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#ifndef Leyingke_LYUserfulMacros_h
#define Leyingke_LYUserfulMacros_h

#import <Foundation/Foundation.h>


/**
 * Borrowed from Apple's AvailabiltyInternal.h header. There's no reason why we shouldn't be
 * able to use this macro, as it's a gcc-supported flag.
 * Here's what we based it off of.
 * __AVAILABILITY_INTERNAL_DEPRECATED         __attribute__((deprecated))
 */
#define __YDEPRECATED_METHOD __attribute__((deprecated))

///////////////////////////////////////////////////////////////////////////////////////////////////
// Flags

/**
 * For when the flag might be a set of bits, this will ensure that the exact set of bits in
 * the flag have been set in the value.
 */
#define IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))

#define LY_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define LY_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

/*
 * 通过RGB创建UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/*
 * iPhone 屏幕尺寸
 */
//#define PHONE_SCREEN_SIZE (CGSizeMake(320, 460))
//#define PHONE_SCREEN_SIZE (CGSizeMake(320, 548))
/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

#define PHONE_SCREEN_SIZE (CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20))

// 获取系统版本号
#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

// 日志
#define GLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#define LY_NSLog GLog
// 内存监测
#define DEBUG_MEMORY_MONITOR 0
#else
#define LY_NSLog(fmt,...)
#endif


#endif
