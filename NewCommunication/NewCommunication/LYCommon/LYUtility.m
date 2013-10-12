//
//  LYUtility.m
//  Leyingke
//
//  Created by 思 高 on 12-9-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYUtility.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

@implementation LYUtility

//是否高于IOS5.0版本
+ (BOOL)isHigherIOS5 {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0){
        return YES;
    }
    
    return NO;
}

+ (BOOL)isHigherIOS6 {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        return YES;
    }
    
    return NO;
}

+ (BOOL)isIphone5
{
    if(PHONE_SCREEN_SIZE.height+20 == 568){
        return YES;
    }
    return NO;
}

+ (NSString*)getCurrentTime
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];  
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];  
    [nsdf2 setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    [nsdf2 release];
    return date;
}

+ (NSString*)getCurrentTimeForDayAndMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%02d月%02d日",[dd month],[dd day]];
}

+ (NSString*)getTomorrowTimeForDayAndMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSTimeInterval dayInterval = 24*60*60;
    NSDate* tomorrowDate = [[[NSDate alloc] initWithTimeIntervalSinceNow:+dayInterval] autorelease];
    NSDateComponents *dd = [cal components:unitFlags fromDate:tomorrowDate];
    return [NSString stringWithFormat:@"%02d月%02d日",[dd month],[dd day]];
}

+ (void)showSimpleAlertView:(NSString *)tip containView:(UIView*)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tip;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

+ (void)showLoadingView:(UIView*)view text:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideLoadingView:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (void)showLoadingViewWithCancel:(UIView *)view text:(NSString *)text mask:(CGRect)mask target:(id)target action:(SEL)action
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view maskFrame:mask animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    UIView* customView = [[[UIView alloc] init] autorelease];
	[customView setFrame:CGRectMake(0, 0, 200, 60)];
	
	UILabel* label = [[[UILabel alloc] init] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	label.text = text;
	CGSize textSize = [label.text sizeWithFont:[UIFont systemFontOfSize:14]];
	[label setFrame:CGRectMake(20, (60-textSize.height)/2, textSize.width, textSize.height)];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont systemFontOfSize:14]];
	[customView addSubview:label];
	
	UIActivityIndicatorView* cusIndicator = [[[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	CGSize indSize = cusIndicator.frame.size;
	[cusIndicator setFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+10, (60-indSize.height)/2, indSize.width, indSize.height)];
	[cusIndicator startAnimating];
	[customView addSubview:cusIndicator];
	
	UIView* line = [[[UIView alloc] init] autorelease];
	[line setFrame:CGRectMake(140, 0, 0.5, 60)];
	line.alpha = 0.7;
	line.backgroundColor = [UIColor whiteColor];
	[customView addSubview:line];
	
	UIButton* cancelButton = [[[UIButton alloc] init] autorelease];
	[cancelButton setFrame:CGRectMake(140, 0, 60, 60)];
    //	[cancelButton setBackgroundColor:[UIColor grayColor]];
	[cancelButton setImage:[UIImage imageNamed:@"cancel_request"] forState:UIControlStateNormal];
	[cancelButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[customView addSubview:cancelButton];
    
    hud.customView = customView;
}

+ (double)getDistance:(double)tagLat tagLng:(double)tagLng
{
    CLLocation* srcLocation = [[[CLLocation alloc] initWithLatitude:[[LYMainUser getInstance].latitude doubleValue] longitude:[[LYMainUser getInstance].longitude doubleValue]] autorelease];
    CLLocation* tagLocation = [[[CLLocation alloc] initWithLatitude:tagLat longitude:tagLng] autorelease];
    
    return [srcLocation distanceFromLocation:tagLocation];
}

@end
