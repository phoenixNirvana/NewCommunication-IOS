//
//  LYWeiBoViewController.m
//  Leyingke
//
//  Created by yu on 12-12-24.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LYWeiBoViewController.h"
#import "LYUserfulMacros.h"
#import "LYUtility.h"
#import "LYShareKit.h"
#import "LYAppDelegate.h"
#import "MBProgressHUD.h"

#define weibomaxstatus 140

@interface LYWeiBoViewController ()

@end

@implementation LYWeiBoViewController
@synthesize shareImage      =   _shareImage;
@synthesize shareText       =   _shareText;
@synthesize contentTextView =   _contentTextView;
@synthesize panelView       =   _panelView;
@synthesize contentImageView = _contentImageView;
@synthesize wordCountLabel = _wordCountLabel;
@synthesize needasy;
@synthesize sendButton  = _sendButton;

-(void)dealloc{
    self.sendButton = nil;
    self.shareImage = nil;
    self.shareText = nil;
    self.contentTextView = nil;
    self.panelView = nil;
    self.contentImageView = nil;
    self.wordCountLabel = nil;
    _parentController = nil;
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithShareText:(NSString*)shareText ShareImage:(UIImage*)shareImage parent:(UIViewController*)parent
{
    if(self = [super init]){
        float number = 0.0;
        int index;
        for (index = 0; index < [shareText length]; index++)
        {
            NSString *character = [shareText substringWithRange:NSMakeRange(index, 1)];
            
            if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
            {
                number++;
            }
            else
            {
                number = number + 0.5;
            }
            if (number > (float)(weibomaxstatus)) {
                break;
            }
        }
        self.shareText = [shareText substringToIndex:index];
        //self.shareText = [NSString stringWithFormat:@"%@  @乐影客 http://www.leyingke.com/lykweb/client/download",shareText];
        self.shareImage = shareImage;
        _parentController = parent;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [self creatTopView];
    
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(10, CONTENT_NAVIGATIONBAR_HEIGHT+10, PHONE_SCREEN_SIZE.width-20, 170)];
    _panelView.backgroundColor = [UIColor whiteColor];
//    CALayer *layer = [_panelView layer];
    [_panelView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_panelView.layer setShadowOffset:CGSizeMake(0, 0)];
    [_panelView.layer setShadowOpacity:0.5];
    [_panelView.layer setShadowRadius:3.0];
    
//    float width = PHONE_SCREEN_SIZE.width-20 - 10;
    
    //
    if (self.shareImage)
    {
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width-20 -5 -80, 5, 80, 130)];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentImageView setImage:self.shareImage];
        
        [_panelView addSubview:_contentImageView];
        
//        width = width - 5 - 80;
    }

    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, PHONE_SCREEN_SIZE.width-20 - 15 - 80, 160)];
    [_contentTextView setEditable:YES];
    [_contentTextView setDelegate:self];
    
    [_contentTextView setText:self.shareText];
    //[_contentTextView setBackgroundColor:[UIColor blueColor]];
    [_contentTextView setFont:[UIFont systemFontOfSize:16]];
    [_panelView addSubview:_contentTextView];
    
    _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_SCREEN_SIZE.width-20 -5 -80, 135, 80, 30)];
    [_wordCountLabel setBackgroundColor:[UIColor clearColor]];
    [_wordCountLabel setTextColor:[UIColor darkGrayColor]];
    [_wordCountLabel setFont:[UIFont systemFontOfSize:16]];
    [_wordCountLabel setTextAlignment:UITextAlignmentCenter];
    [_panelView addSubview:_wordCountLabel];

        
    [self.view addSubview:_panelView];
    
    // calculate the text length
    [self calculateTextLength];

    [_contentTextView becomeFirstResponder];
}

- (float)textLength:(NSString *)text
{
    float number = 0.0;
    int index;
    float length = 0.0f;
    for (index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            //number++;
            length = 1.0f;
        }
        else
        {
            //number = number + 0.5;
            length = 0.5f;
        }
        
        if ((number + length) > weibomaxstatus) {
            break;
        }else{
            number = number + length;

        }
    }
    if (index < ([text length]-1)) {
    //NSLog(@"%d",[text length]);
        _contentTextView.text = [_contentTextView.text substringToIndex:index];
    }
   
    return ceil(number);
}


- (void)calculateTextLength
{	
	float wordcount = [self textLength:_contentTextView.text];
	int count  = 140.0f - wordcount;
	if (count <= 0)
    {
		[_wordCountLabel setTextColor:[UIColor redColor]];
	}
	else
    {
		[_wordCountLabel setTextColor:[UIColor darkGrayColor]];
	}
	
	[_wordCountLabel setText:[NSString stringWithFormat:@"剩余%d字",count]];
}


-(void)rightButtonAction:(id)send{
    [LYUtility showLoadingView:_panelView text:@"请稍后..."];
    if ([[LYShareKit defaultShare] isAuthValid]) {
        self.needasy = NO;
    }else{
        self.needasy = YES;
    }
    [[LYShareKit defaultShare] WeibologIndelegate:self];
    self.self.sendButton.enabled = NO;
}


#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self calculateTextLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(textChanged:)
//												 name:UITextViewTextDidChangeNotification
//											   object:_contentTextView];
}

//- (void)textChanged:(NSNotification *)notification{
//	if (_contentTextView.text.length >= weibomaxstatus)
//    {
//        _contentTextView.text = [_contentTextView.text substringToIndex:weibomaxstatus];
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    if (self.needasy) {
        [[LYShareKit defaultShare] showHud:@"新浪微博绑定成功！"];
    }
//    [[LYShareKit defaultShare] postWeiboStatus:_contentTextView.text image:self.shareImage delegate:self];
    
    [[LYShareKit defaultShare] getsinaUserInfo:self];
    
    //[[LYShareKit defaultShare] postWeiboStatus:@"乐影网络" image:self.shareImage delegate:self];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [[LYShareKit defaultShare] showHud:@"取消新浪微博绑定成功！"];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    //[LYUtility showSimpleAlertView:@"新浪微博登陆失败！" containView:self.view];
    [[LYShareKit defaultShare] showHud:@"新浪微博绑定失败！"];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
     [[LYShareKit defaultShare] removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [LYUtility hideLoadingView:_panelView];
    if ([request.url hasSuffix:@"users/show.json"])
    {
        
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        [[LYShareKit defaultShare] showHud:[NSString stringWithFormat:@"新浪微博发布失败！(%@)",[error localizedDescription]]];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [[LYShareKit defaultShare] showHud:[NSString stringWithFormat:@"新浪微博发布失败！(%@)",[error localizedDescription]]];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [LYMainUser getInstance].weiboNickName = [result objectForKey:@"screen_name"];
        [[LYMainUser getInstance] persist];
        
        [[LYShareKit defaultShare] postWeiboStatus:_contentTextView.text image:self.shareImage delegate:self];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        [LYUtility hideLoadingView:_panelView];
        
        [[LYShareKit defaultShare] showHud:@"新浪微博发布成功！"];
        //[self sendweibind:[[result objectForKey:@"user"] objectForKey:@"screen_name" ]];
        
        [self popselfwithtext:[[result objectForKey:@"user"] objectForKey:@"screen_name" ] uid:[LYShareKit defaultShare].sinaweibo.userID];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [LYUtility hideLoadingView:_panelView];
        
        [[LYShareKit defaultShare] showHud:@"新浪微博发布成功！"];
        //[self sendweibind:[[result objectForKey:@"user"] objectForKey:@"screen_name" ]];
        [self popselfwithtext:[[result objectForKey:@"user"] objectForKey:@"screen_name" ]  uid:[LYShareKit defaultShare].sinaweibo.userID];
    }
    
}

-(void)popselfwithtext:(NSString*)text uid:(NSString*)uid{
    if (self.needasy) {
//        [_parentController popselfwithtext:text uid:uid];
        if([_parentController respondsToSelector:@selector(popselfwithtext:uid:)]){
            [_parentController performSelector:@selector(popselfwithtext:uid:) withObject:text withObject:uid];
        }
    }else{
//        [_parentController popselfwithtext:nil uid:uid];
        if([_parentController respondsToSelector:@selector(popselfwithtext:uid:)]){
            [_parentController performSelector:@selector(popselfwithtext:uid:) withObject:nil withObject:uid];
        }
    }
}


//-(void)showHud:(NSString*)tip{
//    
//    LYAppDelegate *appDelegate = (LYAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIWindow* window = appDelegate.window;
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
//    
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = tip;
//    hud.margin = 10.f;
//    hud.yOffset = -10.f;
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [hud hide:YES afterDelay:3];
//}
//ios4 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

//ios6
-(BOOL)shouldAutorotate{
    return NO;
}


-(void)creatTopView
{
    @autoreleasepool {
        
        UIImageView* view = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.width, CONTENT_NAVIGATIONBAR_HEIGHT)]autorelease];
        view.backgroundColor = [UIColor blackColor];
        [view setImage:[UIImage imageNamed:@"share_navi_bg"]];
        view.userInteractionEnabled = YES;
        
        UILabel* titleLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(100, 0, 120, CONTENT_NAVIGATIONBAR_HEIGHT)]autorelease];
        titleLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel setText:@"新浪微博分享"];
        [view addSubview:titleLabel];
        
        UIButton* button = [self creatButton];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"share_navi_back"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"share_navi_back_pressed"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(returnButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(10, (view.height - 30.5)/2, 50.5, 30.5)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        button.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        [button.titleLabel setFont:[UIFont fontWithName:MED_HEITI_FONT size:14]];
        [view addSubview:button];
        
        
        
        UIButton* sendbutton = [self creatButton];
        [sendbutton setTitle:@"发送" forState:UIControlStateNormal];
        [sendbutton setBackgroundImage:[UIImage imageNamed:@"share_send"] forState:UIControlStateNormal];
        [sendbutton setBackgroundImage:[UIImage imageNamed:@"share_send_pressed"] forState:UIControlStateHighlighted];
        [sendbutton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        sendbutton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        sendbutton.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        [sendbutton setFrame:CGRectMake(view.width - 60.5, (view.height - 30.5)/2, 50, 30.5)];
        [sendbutton.titleLabel setFont:[UIFont fontWithName:MED_HEITI_FONT size:14]];
        [view addSubview:sendbutton];
        self.sendButton = sendbutton;
        
        [self.view addSubview: view];
    }
}

-(void)returnButtonOnclick
{
    [self dismissModalViewControllerAnimated:YES];
}
- (UIButton*)creatButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    return [[button retain]autorelease];
}


@end
