//
//  LYBaseViewController.h
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBaseViewController : UIViewController{
@protected
    NSDictionary*     _frozenState;
    UIBarStyle        _navigationBarStyle;
    UIColor*          _navigationBarTintColor;
    UIStatusBarStyle  _statusBarStyle;
    
    BOOL _isViewAppearing;
    BOOL _hasViewAppeared;
    BOOL _autoresizesForKeyboard;
}

/**
 * The style of the navigation bar when this view controller is pushed onto
 * a navigation controller.
 *
 * @default UIBarStyleDefault
 */
@property (nonatomic) UIBarStyle navigationBarStyle;

/**
 * The color of the navigation bar when this view controller is pushed onto
 * a navigation controller.
 *
 * @default TTSTYLEVAR(navigationBarTintColor)
 */
@property (nonatomic, retain) UIColor* navigationBarTintColor;

/**
 * The style of the status bar when this view controller is appearing.
 *
 * @default [[UIApplication sharedApplication] statusBarStyle] via app's info.plist
 *
 */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/**
 * The view has appeared at least once and hasn't been removed due to a memory warning.
 */
@property (nonatomic, readonly) BOOL hasViewAppeared;

/**
 * The view is about to appear and has not appeared yet.
 */
@property (nonatomic, readonly) BOOL isViewAppearing;

/**
 * Determines if the view will be resized automatically to fit the keyboard.
 */
@property (nonatomic) BOOL autoresizesForKeyboard;


/**
 * Sent to the controller before the keyboard slides in.
 */
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller before the keyboard slides out.
 */
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid in.
 */
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/**
 * Sent to the controller after the keyboard has slid out.
 */
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
