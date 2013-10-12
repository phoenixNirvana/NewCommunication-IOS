//
//  LYURLJsonResponse.m
//  Leyingke
//
//  Created by 思 高 on 12-9-19.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYURLJsonResponse.h"
#import "JSON.h"

@implementation LYURLJsonResponse
@synthesize rootObject  = _rootObject;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    LY_RELEASE_SAFELY(_rootObject);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLResponse


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSError*)request:(YURLRequest*)request processResponse:(NSHTTPURLResponse*)response
               data:(id)data {
    NSError* err = nil;
    if ([data isKindOfClass:[NSData class]]) {
        NSString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        json =  [json stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]; 
        LY_RELEASE_SAFELY(_rootObject);
        _rootObject = [[json JSONValue] retain];
        if (!_rootObject) {
            err = [NSError errorWithDomain:@"返回数据错误" code:100 userInfo:nil];
        }else{
            LY_NSLog(@"response-body=%@",_rootObject);
        }
        
        NSDictionary* respond = [_rootObject objectForKey:@"respond"];
        if (respond) {
            NSString* msg = [respond objectForKey:@"msg"];
//            BOOL msgfail = ([msg compare:@"success"] != NSOrderedSame);
//            if (msgfail) {
            if(TRUE){
                NSNumber* status = [respond objectForKey:@"status"];
                if([status intValue] != 200){
                    //NSNumber* code = [respond objectForKey:@"code"];
                    err = [NSError errorWithDomain:msg code:100 userInfo:nil];
                }

            }
        }
        
    }
    
    return err;
}

@end
