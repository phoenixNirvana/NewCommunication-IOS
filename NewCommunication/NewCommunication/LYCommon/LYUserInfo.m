//
//  LYUserInfo.m
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYUserInfo.h"

@implementation LYUserInfo
@synthesize gender = _gender;
@synthesize bindedMobile = _bindedMobile;
@synthesize age = _age;
@synthesize nickName = _nickName;

- (void)dealloc
{
    self.gender = nil;
    self.bindedMobile = nil;
    self.age = nil;
    self.nickName = nil;
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)info{
    self = [super init];
    
    if (self) {
        NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
        self.gender = [info objectForKey:@"gender"];
        self.bindedMobile = [info objectForKey:@"bindedmobile"];
        self.age = [info objectForKey:@"age"];
        self.nickName = [info objectForKey:@"nickname"];
        
        [autoPool release];
    }
    
    return self;
}


@end
