//
//  LYAppDelegate.m
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYAppDelegate.h"
#import "LYUserfulMacros.h"
#import "LYMainUser.h"
#import "LYGlobalMacros.h"
#import "LYShareKit.h"
#import "LYStartup.h"
#import <AudioToolbox/AudioServices.h>
#import "LYUtility.h"
#import "UIView+LYAdditions.h"

@implementation LYAppDelegate

@synthesize window = _window;
@synthesize viewController;
@synthesize memoryMonitorWnd;
@synthesize memoryMonitorTimer;
@synthesize memoryMonitorLabel;
@synthesize memoryPeak;
@synthesize crashLogModel;

-(void)uploadCrashLog{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[LYMainUser documentPath],kCrashLogPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *crashLog = [NSData dataWithContentsOfFile:path];
        if (crashLog == nil) {
            return;
        }
        
        LYCrashLogModel* tmpCrashLogModel = [[LYCrashLogModel alloc] init];
        tmpCrashLogModel.errLog = crashLog;
        [tmpCrashLogModel load:YURLRequestCachePolicyNone more:NO];
        self.crashLogModel = tmpCrashLogModel;
        [tmpCrashLogModel release];
    }

}

- (void)dealloc
{
    self.viewController = nil;
    self.crashLogModel = nil;
    
    if (self.memoryMonitorTimer) {
        [self.memoryMonitorTimer invalidate];
    }
    self.memoryMonitorTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application setStatusBarHidden:NO];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
     
    // 增加内存监视器
#if DEBUG_MEMORY_MONITOR
    self.memoryMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(refreshMemoryMonitor)
                                                             userInfo:nil
                                                              repeats:YES];
    [self.memoryMonitorTimer fire];
#endif
    
    [application setStatusBarHidden:NO];
    LYPhotoViewController *firstCtl =  [[LYPhotoViewController alloc] init];
    self.viewController = firstCtl;
    
    UINavigationController *navViewCtl = [[UINavigationController alloc] initWithRootViewController:self.viewController ];
    [navViewCtl setNavigationBarHidden:YES];

    self.window.rootViewController = navViewCtl;
    LY_RELEASE_SAFELY(navViewCtl);
    LY_RELEASE_SAFELY(firstCtl);
    [self.window makeKeyAndVisible];
    
//    [self uploadCrashLog];
    
//    [[LYStartup defaultShare] requestAction];
    
    return YES;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [[LYShareKit defaultShare] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [[LYShareKit defaultShare] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LYShareKit defaultShare] applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
#if DEBUG_MEMORY_MONITOR
    self.memoryMonitorLabel.textColor = [UIColor redColor];
#endif
}


// 内存监测
- (void)refreshMemoryMonitor{
    if (self.memoryMonitorWnd == nil) {
        self.memoryMonitorWnd = [[[UIWindow alloc] initWithFrame:CGRectMake(0,
                                                                            480 - 20,
                                                                            320,
                                                                            20)] autorelease];
        self.memoryMonitorWnd.windowLevel = UIWindowLevelStatusBar;
        self.memoryMonitorWnd.userInteractionEnabled = NO;
        
        self.memoryMonitorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             100,
                                                                             20)] autorelease];
        self.memoryMonitorLabel.font = [UIFont systemFontOfSize:12];
        self.memoryMonitorLabel.textColor = [UIColor greenColor];
        self.memoryMonitorLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        
        [self.memoryMonitorWnd addSubview:self.memoryMonitorLabel];
        [self.memoryMonitorWnd makeKeyAndVisible];
    }
    
    //// 设备总空间
    unsigned int usedMemory = [UIDevice usedMemory];
    unsigned int freeMemory = [UIDevice freeMemory];
    if (usedMemory > self.memoryPeak) {
        self.memoryPeak = usedMemory;
    }
    
    NSString *monitor = [NSString stringWithFormat:@"used:%7.1fkb free:%7.1fkb peak:%7.1fkb", usedMemory/1024.0f, freeMemory/1024.0f, self.memoryPeak/1024.0f];
    CGSize size = [monitor sizeWithFont:self.memoryMonitorLabel.font];
    self.memoryMonitorLabel.frame = CGRectMake(0, 0, size.width, 20);
    self.memoryMonitorLabel.text = monitor;
}

// Retrieve the device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}

@end