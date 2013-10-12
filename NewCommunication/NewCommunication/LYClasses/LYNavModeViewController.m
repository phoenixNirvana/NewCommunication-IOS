//
//  LYNavModeViewController.m
//  Leyingke
//
//  Created by yu on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavModeViewController.h"
#import "MBProgressHUD.h"


@interface LYNavModeViewController ()

@end

@implementation LYNavModeViewController

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

- (void)setNavBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.navBar.hidden = hidden;
}

- (void)showLoading:(BOOL)show {
    if(show){
        [self showLoadingView:@"请稍候..."];
    }
    else{
        [self hideLoadingView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showModel:(BOOL)show {
    [super showModel:show];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show {
    [super showEmpty:show];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show {
    if(show){
        //[LYUtility showSimpleAlertView:@"加载数据失败，请检查网络！" containView:self.view];
        
    }
    [super showError:show];
}

- (void)showLoadingView:(NSString *)tip
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view maskFrame:CGRectMake(0, CONTENT_NAVIGATIONBAR_HEIGHT, self.view.width, self.view.height-CONTENT_NAVIGATIONBAR_HEIGHT) animated:YES];
//    
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = tip;
//    hud.margin = 10.f;
//    //    hud.yOffset = 150.f;
//    hud.removeFromSuperViewOnHide = YES;
//    
//    //    [hud hide:YES afterDelay:1.3];
    
    [LYUtility showLoadingViewWithCancel:self.view text:tip mask:CGRectMake(0, CONTENT_NAVIGATIONBAR_HEIGHT, self.view.width, self.view.height-CONTENT_NAVIGATIONBAR_HEIGHT) target:self action:@selector(cancelAction:)];
}

- (void)cancelAction:(id)sender
{
    if(sender){
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.model cancel];
    }
}

- (void)hideLoadingView
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

@end
