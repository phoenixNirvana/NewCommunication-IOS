//
//  LYBindWeiboModel.h
//  Leyingke
//
//  Created by yu on 12-12-29.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLRequest.h"
#import "LYBaseDataRequest.h"

@interface LYBindWeiboModel : NSObject<LYBaseDataRequestDelegate>{
    LYBaseDataRequest* _request;
    NSString*          _username;
    NSString*          _userid;
}

@property (nonatomic, retain)LYBaseDataRequest* request;
@property (nonatomic, retain)NSString* username;
@property (nonatomic, retain)NSString* userid;

- (void)requestAction;
@end
