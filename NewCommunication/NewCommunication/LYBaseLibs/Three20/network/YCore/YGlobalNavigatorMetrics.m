//
//  YGlobalNavigatorMetrics.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YGlobalNavigatorMetrics.h"
#import "YGlobalCoreRects.h"
//#import "YGlobalUICommon.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////
//UIInterfaceOrientation YInterfaceOrientation() {
//    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIDeviceOrientationUnknown == orient) {
//        return [YBaseNavigator globalNavigator].visibleViewController.interfaceOrientation;
//        
//    } else {
//        return orient;
//    }
//}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGRect YScreenBounds() {
//    CGRect bounds = [UIScreen mainScreen].bounds;
//    if (UIInterfaceOrientationIsLandscape(YInterfaceOrientation())) {
//        CGFloat width = bounds.size.width;
//        bounds.size.width = bounds.size.height;
//        bounds.size.height = width;
//    }
//    return bounds;
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGRect YNavigationFrame() {
//    CGRect frame = [UIScreen mainScreen].applicationFrame;
//    return CGRectMake(0, 0, frame.size.width, frame.size.height - YToolbarHeight());
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGRect YToolbarNavigationFrame() {
//    CGRect frame = [UIScreen mainScreen].applicationFrame;
//    return CGRectMake(0, 0, frame.size.width, frame.size.height - YToolbarHeight()*2);
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGRect YKeyboardNavigationFrame() {
//    return YRectContract(YNavigationFrame(), 0, YKeyboardHeight());
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGFloat YStatusHeight() {
//    UIInterfaceOrientation orientation = YInterfaceOrientation();
//    if (orientation == UIInterfaceOrientationLandscapeLeft) {
//        return [UIScreen mainScreen].applicationFrame.origin.x;
//        
//    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
//        return -[UIScreen mainScreen].applicationFrame.origin.x;
//        
//    } else {
//        return [UIScreen mainScreen].applicationFrame.origin.y;
//    }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGFloat YBarsHeight() {
//    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
//    if (UIInterfaceOrientationIsPortrait(YInterfaceOrientation())) {
//        return frame.size.height + Y_ROW_HEIGHT;
//        
//    } else {
//        return frame.size.width + (YIsPad() ? Y_ROW_HEIGHT : Y_LANDSCAPE_TOOLBAR_HEIGHT);
//    }
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGFloat YToolbarHeight() {
//    return YToolbarHeightForOrientation(YInterfaceOrientation());
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//CGFloat YKeyboardHeight() {
//    return YKeyboardHeightForOrientation(YInterfaceOrientation());
//}
