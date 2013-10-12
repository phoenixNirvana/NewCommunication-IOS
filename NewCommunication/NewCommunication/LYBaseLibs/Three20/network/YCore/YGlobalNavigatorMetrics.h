//
//  YGlobalNavigatorMetrics.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * @return the current orientation of the visible view controller.
 */
//UIInterfaceOrientation YInterfaceOrientation();

/**
 * @return the bounds of the screen with device orientation factored in.
 */
//CGRect YScreenBounds();

/**
 * @return the application frame below the navigation bar.
 */
//CGRect YNavigationFrame();

/**
 * @return the application frame below the navigation bar and above a toolbar.
 */
//CGRect YToolbarNavigationFrame();

/**
 * @return the application frame below the navigation bar and above the keyboard.
 */
//CGRect YKeyboardNavigationFrame();

/**
 * @return the height of the area containing the status bar and possibly the in-call status bar.
 */
//CGFloat YStatusHeight();

/**
 * @return the height of the area containing the status bar and navigation bar.
 */
//CGFloat YBarsHeight();

/**
 * @return the height of a toolbar considering the current orientation.
 */
//CGFloat YToolbarHeight();

/**
 * @return the height of the keyboard considering the current orientation.
 */
//CGFloat YKeyboardHeight();