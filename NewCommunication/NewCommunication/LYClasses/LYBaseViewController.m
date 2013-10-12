//
//  LYBaseViewController.m
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYUserfulMacros.h"

@implementation LYBaseViewController

@synthesize navigationBarStyle      = _navigationBarStyle;
@synthesize navigationBarTintColor  = _navigationBarTintColor;
@synthesize statusBarStyle          = _statusBarStyle;
@synthesize isViewAppearing         = _isViewAppearing;
@synthesize hasViewAppeared         = _hasViewAppeared;
@synthesize autoresizesForKeyboard  = _autoresizesForKeyboard;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _navigationBarStyle = UIBarStyleDefault;
//        _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
    [self.view setFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height)];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
//    [self unsetCommonProperties];
    
//    Y_RELEASE_SAFELY(_navigationBarTintColor);
//    Y_RELEASE_SAFELY(_frozenState);
    
    // Removes keyboard notification observers for
    self.autoresizesForKeyboard = NO;
    
    // You would think UIViewController would call this in dealloc, but it doesn't!
    // I would prefer not to have to redundantly put all view releases in dealloc and
    // viewDidUnload, so my solution is just to call viewDidUnload here.
    [self viewDidUnload];
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resizeForKeyboard:(NSNotification*)notification appearing:(BOOL)appearing {
	CGRect keyboardBounds;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
	CGPoint keyboardStart;
	[[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardStart];
    
	CGPoint keyboardEnd;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEnd];
    
	BOOL animated = keyboardStart.y != keyboardEnd.y;
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
    }
    
    if (appearing) {
        [self keyboardWillAppear:animated withBounds:keyboardBounds];
        
    } else {
        [self keyboardDidDisappear:animated withBounds:keyboardBounds];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)frozenState {
    return _frozenState;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFrozenState:(NSDictionary*)frozenState {
    [_frozenState release];
    _frozenState = [frozenState retain];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isViewAppearing = YES;
    _hasViewAppeared = YES;
    
//    if (!self.popupViewController) {
//        UINavigationBar* bar = self.navigationController.navigationBar;
//        bar.tintColor = _navigationBarTintColor;
//        bar.barStyle = _navigationBarStyle;
//        
//        if (!YIsPad()) {
//            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
//        }
//    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isViewAppearing = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    if (_hasViewAppeared && !_isViewAppearing) {
        // This will come around to calling viewDidUnload
        [super didReceiveMemoryWarning];
        
        _hasViewAppeared = NO;
        
    } else {
        [super didReceiveMemoryWarning];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

//    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
 
    return [super willAnimateRotationToInterfaceOrientation: fromInterfaceOrientation
                                                       duration: duration];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    UIViewController* popup = [self popupViewController];
    
    return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)rotatingHeaderView {
    return [super rotatingHeaderView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)rotatingFooterView {
    return [super rotatingFooterView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIKeyboardNotifications


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillShow:(NSNotification*)notification {
    if (self.isViewAppearing) {
        [self resizeForKeyboard:notification appearing:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidShow:(NSNotification*)notification {
#ifdef __IPHONE_3_21
    CGRect frameStart;
    [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];
    
    CGRect keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
#else
    CGRect keyboardBounds;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
#endif
    
    [self keyboardDidAppear:YES withBounds:keyboardBounds];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidHide:(NSNotification*)notification {
    if (self.isViewAppearing) {
        [self resizeForKeyboard:notification appearing:NO];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillHide:(NSNotification*)notification {
#ifdef __IPHONE_3_21
    CGRect frameEnd;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
    
    CGRect keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
#else
    CGRect keyboardBounds;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
#endif
    
    [self keyboardWillDisappear:YES withBounds:keyboardBounds];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAutoresizesForKeyboard:(BOOL)autoresizesForKeyboard {
    if (autoresizesForKeyboard != _autoresizesForKeyboard) {
        _autoresizesForKeyboard = autoresizesForKeyboard;
        
        if (_autoresizesForKeyboard) {
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillShow:)
                                                         name: UIKeyboardWillShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardWillHide:)
                                                         name: UIKeyboardWillHideNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidShow:)
                                                         name: UIKeyboardDidShowNotification
                                                       object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(keyboardDidHide:)
                                                         name: UIKeyboardDidHideNotification
                                                       object: nil];
            
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardWillHideNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidShowNotification
                                                          object: nil];
            [[NSNotificationCenter defaultCenter] removeObserver: self
                                                            name: UIKeyboardDidHideNotification
                                                          object: nil];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    // Empty default implementation.
}

@end
