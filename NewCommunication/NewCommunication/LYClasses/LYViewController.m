//
//  LYViewController.m
//  Leyingke
//
//  Created by yu on 12-9-19.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYViewController.h"
#import "YURLRequestQueue.h"

@interface LYViewController ()

@end

@implementation LYViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationBarTintColor = YSTYLEVAR(navigationBarTintColor);
        //self.navigationBarTintColor = [UIColor redColor];
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[YURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
//    if (nil != self.nibName) {
//        [super loadView];
//        
//    } else {
//       // CGRect frame = self.wantsFullScreenLayout ? YScreenBounds() : YNavigationFrame();
//        //self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
//        self.view = [[[UIView alloc] init] autorelease];
//        self.view.autoresizesSubviews = YES;
//        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        //self.view.backgroundColor = YSTYLEVAR(backgroundColor);
//        self.view.backgroundColor = [UIColor redColor];
//    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    // Y_RELEASE_SAFELY(_searchController);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [YURLRequestQueue mainQueue].suspended = YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [YURLRequestQueue mainQueue].suspended = NO;
}
@end
