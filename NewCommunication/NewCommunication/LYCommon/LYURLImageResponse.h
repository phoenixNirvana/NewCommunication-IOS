//
//  LYURLImageResponse.h
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLResponse.h"

@interface LYURLImageResponse : NSObject<YURLResponse>{
    UIImage* _image;
}
@property (nonatomic, readonly) UIImage* image;

@end
