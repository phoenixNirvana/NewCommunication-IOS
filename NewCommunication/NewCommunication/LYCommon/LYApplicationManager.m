//
//  LYApplicationManager.m
//  Leyingke
//
//  Created by yu on 12-10-29.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYApplicationManager.h"

@implementation LYApplicationManager

// 是否安装私信
+ (BOOL)isValid:(NSString*)url{
    return  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

// 安装私信, 打开链接或者App Stor
+ (void)setup{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"下载应用程序"
                                                   delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即下载", nil];
	[alert show];
	[alert release];
}


// 打开应用程序列表
+ (void)openApplicationWithDialogAndCallback:(NSString *)callback{
    if (![LYApplicationManager isValid:@"RRSX://"]) {
        [LYApplicationManager setup];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"RRSX://"]];
//    RCMainUser *mainUser = [RCMainUser getInstance];
//    NSString *openURL = [NSString stringWithFormat:RRSX_DIALOGLIST_URL, 
//                         mainUser.userId,
//                         mainUser.loginAccount,
//                         mainUser.md5Password,
//                         callback == nil ? 
//                         [@"renrenios://" urlEncode2:NSUTF8StringEncoding]:[callback urlEncode2:NSUTF8StringEncoding]];
//    
//    [RCSXManager clearChatAllViews];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openURL]];
}


#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)action clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		//[LYApplicationManager clearChatAllViews];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/si-xin/id514821086?l=en&mt=8"]];
	}
	else
	{
		//NSLog(@"cancel");
	}

}
@end
