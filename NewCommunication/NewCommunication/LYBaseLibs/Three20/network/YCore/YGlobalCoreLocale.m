//
//  YGlobalCoreLocale.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YGlobalCoreLocale.h"
#import "LYUserfulMacros.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
NSLocale* YCurrentLocale() {
    NSArray* languages = [NSLocale preferredLanguages];
    if (languages.count > 0) {
        NSString* currentLanguage = [languages objectAtIndex:0];
        return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
        
    } else {
        return [NSLocale currentLocale];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* YLocalizedString(NSString* key, NSString* comment) {
    static NSBundle* bundle = nil;
    if (nil == bundle) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"Three20.bundle"];
        bundle = [[NSBundle bundleWithPath:path] retain];
    }
    
    return [bundle localizedStringForKey:key value:key table:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* YDescriptionForError(NSError* error) {
    //YDINFO(@"ERROR %@", error);
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        // Note: If new error codes are added here, be sure to document them in the header.
        if (error.code == NSURLErrorTimedOut) {
            return YLocalizedString(@"Connection Timed Out", @"");
            
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            return YLocalizedString(@"No Internet Connection", @"");
            
        } else {
            return YLocalizedString(@"Connection Error", @"");
        }
    }
    return YLocalizedString(@"Error", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* YFormatInteger(NSInteger num) {
    NSNumber* number = [NSNumber numberWithInt:num];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* formatted = [formatter stringFromNumber:number];
    [formatter release];
    return formatted;
}
