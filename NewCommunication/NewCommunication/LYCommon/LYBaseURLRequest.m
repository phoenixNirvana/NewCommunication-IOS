//
//  LYBaseURLRequest.m
//  Leyingke
//
//  Created by 思 高 on 12-9-20.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseURLRequest.h"
#import "LYConfig.h"
@implementation LYBaseURLRequest

- (BOOL)sendQuery:(NSDictionary*)query
{
    if(query){
        // 添加post请求内容
    }
    
    LYConfig* config = [LYConfig globalConfig];
    [config updateUserAgent];
    [self setValue:config.userAgent forHTTPHeaderField:@"User-Agent"];

    return [self send];
}

@end
