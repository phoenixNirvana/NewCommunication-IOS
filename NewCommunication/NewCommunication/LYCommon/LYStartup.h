//
//  LYStartup.h
//  Leyingke
//
//  Created by yu on 12-12-28.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLRequest.h"
#import "LYBaseDataRequest.h"

@interface LYStartup : NSObject<LYBaseDataRequestDelegate,UIAlertViewDelegate>{
    LYBaseDataRequest* _request;
    NSString*       _downurl;
}

@property (nonatomic, retain)NSString* downurl;
@property (nonatomic, retain)LYBaseDataRequest* request;
@property (nonatomic, assign)BOOL failtip;

+ (LYStartup *)defaultShare;

// 检测用户升级信息
- (void) requestAction;
- (void) requestActionFailtip;


@end
