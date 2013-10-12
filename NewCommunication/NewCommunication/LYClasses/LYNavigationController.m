//
//  LYNavigationControllerViewController.m
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavigationController.h"
#import "LYNavigationBar.h"
#import "LYNavigationViewController.h"
#import "LYAppDelegate.h"

@interface LYNavigationController ()

@end

@implementation LYNavigationController

- (void)dealloc {

    [super dealloc];
}


- (void)loadView
{
    [super loadView];
    [self setNavigationBarHidden:YES];
//    self.view.backgroundColor  = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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


//- (BOOL)shouldAutorotate
//{
//    return self.topViewController.shouldAutorotate;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return self.topViewController.supportedInterfaceOrientations;
//}


- (UIViewController *)popViewControllerWithAnimate1 {

    return  [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController respondsToSelector:@selector(navBar)]) {
        // 设置navigationBar返回按钮
        id vc = viewController;
        LYNavigationBar *navBar = [vc navBar];
        if (self.viewControllers.count == 0 ) {
        }
        else{
            UIButton *backButton = navBar.backButton;
            [backButton setImage:[UIImage imageNamed:@"navigationbar_btn_back"] forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"navigationbar_btn_back_hl"] forState:UIControlStateHighlighted];
            [backButton addTarget:self
                           action:@selector(popViewControllerWithAnimate1)
                 forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *popViewController = [[self.viewControllers lastObject] retain];
    NSMutableArray *finalviewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [finalviewControllers removeLastObject];
    
    [self setViewControllers:finalviewControllers animated:animated];
    return [popViewController autorelease];
    
    return  [super popViewControllerAnimated:animated];
}

- (void)popModalViewControllerWithAnimate1 {
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void)dismissModalViewControllerAnimated:(BOOL)animated{
    
    [super dismissModalViewControllerAnimated:animated];
}

- (void) presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([modalViewController respondsToSelector:@selector(navBar)]) {
        id vc = modalViewController;
        LYNavigationBar *navBar = [vc navBar];
        if (self.modalViewController != nil ) {
        }
        else{
            UIButton *backButton = navBar.backButton;
            [backButton setImage:[UIImage imageNamed:@"navigationbar_btn_back"] forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"navigationbar_btn_back_hl"] forState:UIControlStateHighlighted];
            [backButton addTarget:self
                           action:@selector(popModalViewControllerWithAnimate1)
                 forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [super presentModalViewController:modalViewController animated:animated];
}

@end
