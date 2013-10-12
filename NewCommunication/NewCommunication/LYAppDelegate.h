//
//  LYAppDelegate.h
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCrashLogModel.h"
#import "LYPhotoViewController.h"


@interface LYAppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) LYPhotoViewController *viewController;
@property (nonatomic, retain) LYCrashLogModel *crashLogModel;


// 内存监控
@property (nonatomic, retain) UIWindow *memoryMonitorWnd;
@property (nonatomic, retain) NSTimer *memoryMonitorTimer;
@property (nonatomic, retain) UILabel *memoryMonitorLabel;
@property (nonatomic, assign) unsigned int memoryPeak;

-(void)uploadCrashLog;

@end
