//
//  YAvailability.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YAvailability.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL YDeviceOSVersionIsAtLeast(double versionNumber) {
    return kCFCoreFoundationVersionNumber >= versionNumber;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
Class YUIPopoverControllerClass() {
    static Class sClass = nil;
    if (nil == sClass) {
        sClass = NSClassFromString(@"UIPopoverController");
    }
    return sClass;
}

