//
//  YUserInfo.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUserInfo : NSObject{
    NSString* _topic;
    id        _strongRef;
    id        _weakRef;
}

@property (nonatomic, copy)   NSString* topic;
@property (nonatomic, retain) id        strongRef;
@property (nonatomic, assign) id        weakRef;

+ (id)topic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef;
+ (id)topic:(NSString*)topic;
+ (id)weakRef:(id)weakRef;

- (id)initWithTopic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef;

@end
