//
//  LYURLJsonResponse.h
//  Leyingke
//
//  Created by 思 高 on 12-9-19.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLResponse.h"

@interface LYURLJsonResponse : NSObject<YURLResponse>{
    id _rootObject;
}

@property (nonatomic, retain, readonly)id rootObject;

@end
