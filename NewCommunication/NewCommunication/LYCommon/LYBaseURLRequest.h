//
//  LYBaseURLRequest.h
//  Leyingke
//
//  Created by 思 高 on 12-9-20.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "YURLRequest.h"

@interface LYBaseURLRequest : YURLRequest{
    
}

/*
 * 如果请求为get,query传空，如果为post，需要传相应的内容
 */
- (BOOL)sendQuery:(NSDictionary*)query;

@end
