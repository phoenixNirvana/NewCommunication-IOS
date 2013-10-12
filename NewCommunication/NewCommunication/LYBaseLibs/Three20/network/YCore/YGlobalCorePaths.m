//
//  YGlobalCorePaths.m
//  yushiyi
//
//  Created by yu shiyi on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YGlobalCorePaths.h"

static NSBundle* globalBundle = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL YIsBundleURL(NSString* URL) {
    return [URL hasPrefix:@"bundle://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL YIsDocumentsURL(NSString* URL) {
    return [URL hasPrefix:@"documents://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void YSetDefaultBundle(NSBundle* bundle) {
    [bundle retain];
    [globalBundle release];
    globalBundle = bundle;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSBundle* YGetDefaultBundle() {
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* YPathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [YGetDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* YPathForDocumentsResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] retain];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}
