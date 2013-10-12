//
//  LYNavigationViewController.m
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavigationViewController.h"


@interface LYNavigationViewController ()

@end

@implementation LYNavigationViewController
@synthesize navBar = _navBar;

- (void)dealloc {
    self.navBar = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LYNavigationBar *navBar = [[LYNavigationBar alloc] initWithFrame:CGRectMake(0, 
                                                                                    0,
                                                                                    PHONE_SCREEN_SIZE.width,
                                                                                    CONTENT_NAVIGATIONBAR_HEIGHT)];
        self.navBar = navBar;
        LY_RELEASE_SAFELY(navBar);
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.navBar];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.navBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setNavBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.navBar.hidden = hidden;
}

@end
