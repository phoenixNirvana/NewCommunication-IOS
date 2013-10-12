//
//  LYUtility.h
//  Leyingke
//
//  Created by 思 高 on 12-9-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYUtility : NSObject

+ (BOOL)isHigherIOS5;
+ (BOOL)isIphone5;
+ (BOOL)isHigherIOS6;
+ (NSString*)getCurrentTime;
+ (NSString*)getCurrentTimeForDayAndMonth;
+ (NSString*)getTomorrowTimeForDayAndMonth;
+ (void)showSimpleAlertView:(NSString *)tip containView:(UIView*)view;
+ (void)showLoadingView:(UIView*)view text:(NSString *)text;
+ (void)hideLoadingView:(UIView*)view;
+ (void)showLoadingViewWithCancel:(UIView *)view text:(NSString *)text mask:(CGRect)mask target:(id)target action:(SEL)action;
+ (double)getDistance:(double)tagLat tagLng:(double)tagLng;

@end
