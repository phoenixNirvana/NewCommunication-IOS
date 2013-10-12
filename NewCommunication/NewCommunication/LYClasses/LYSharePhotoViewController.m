//
//  LYSharePhotoViewController.m
//  LYPaizhao
//
//  Created by liuyong on 13-9-27.
//  Copyright (c) 2013年 乐影客. All rights reserved.
//

#import "LYSharePhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LYWeiBoViewController.h"
#import "LYShareKit.h"

#define bottom_height 60

@interface LYSharePhotoViewController ()

@end

@implementation LYSharePhotoViewController
@synthesize syImage;

-(void)dealloc
{
    self.syImage = nil;
    [super dealloc];
}

-(id)initWithImage:(UIImage*)image
{
    if (self = [super init]) {
        self.syImage = image;   
    }
    return self;
}



-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    [self creatTopView];
    
    @autoreleasepool {
        
        CGFloat saveLeft = 80;
        CGFloat saveWidth = 30;
        CGFloat startY = CONTENT_NAVIGATIONBAR_HEIGHT+6;
        UIImageView* saveImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(saveLeft, startY, saveWidth, saveWidth)]autorelease];
        [saveImageView setImage:[UIImage imageNamed:@"share_save"]];
        saveImageView.backgroundColor =[UIColor clearColor];
        [self.view addSubview:saveImageView];
        
        UILabel* savedLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(saveImageView.left+saveImageView.width+2, startY, 120, saveWidth)]autorelease];
        savedLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:16];
        savedLabel.backgroundColor = [UIColor clearColor];
        savedLabel.textColor = [UIColor whiteColor];
        savedLabel.textAlignment = UITextAlignmentLeft;
        [savedLabel setText:@"已保存到相册"];
        [self.view addSubview:savedLabel];
        
        startY += saveWidth+10;

        UIImageView* bottomView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height-bottom_height, PHONE_SCREEN_SIZE.width, bottom_height)]autorelease];
        bottomView.userInteractionEnabled = YES;
        bottomView.backgroundColor =[UIColor clearColor];
        [bottomView setImage:[UIImage imageNamed:@"share_bottom_bg"]];
        [self.view addSubview:bottomView];
        
        CGFloat takeWidth = 110;
        CGFloat takeHeight = 46;
        UIButton* takePicButton = [self creatButton];
        [takePicButton setBackgroundImage:[UIImage imageNamed:@"share_take_pic"] forState:UIControlStateNormal];
        [takePicButton setBackgroundImage:[UIImage imageNamed:@"share_take_pic_pressed"] forState:UIControlStateHighlighted];
        [takePicButton setTitle:@"继续拍照" forState:UIControlStateNormal];
        [takePicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [takePicButton addTarget:self action:@selector(continueTakePicture) forControlEvents:UIControlEventTouchUpInside];
        [takePicButton setFrame:CGRectMake((bottomView.width-takeWidth)/2, (bottomView.height-takeHeight)/2, takeWidth, takeHeight)];
        [takePicButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [bottomView addSubview:takePicButton];
        
        CGFloat shareBgLeft = 12;
        CGFloat shareBgheight = 80;
        CGFloat shareBgY = bottomView.top-8-shareBgheight;
        UIImageView* shareBgView = [[[UIImageView alloc]initWithFrame:CGRectMake(shareBgLeft, shareBgY, PHONE_SCREEN_SIZE.width-2*shareBgLeft, shareBgheight)]autorelease];
        shareBgView.userInteractionEnabled = YES;
        UIImage* sharebgimage = [UIImage middleStretchableImageWithName:@"share_bg"];
        [shareBgView setImage:sharebgimage];
        shareBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:shareBgView];
        
        CGFloat shareLeft = 25;
        CGFloat sharetop = 8;
        CGFloat sharebuttonWidth = 50;
        CGFloat space = (shareBgView.width -2*shareLeft -3*sharebuttonWidth)/2;
        CGFloat sharelableTop = sharetop+sharebuttonWidth;
        CGFloat sharelableHeight  = 20;
        CGFloat sharelabeloffsetX = 15;
        CGFloat sharelabelwidth = sharebuttonWidth + 2*sharelabeloffsetX;
        
        
        UIButton* weiboButton = [self creatButton];
        [weiboButton setBackgroundImage:[UIImage imageNamed:@"share_sina"] forState:UIControlStateNormal];
        [weiboButton addTarget:self action:@selector(shareToweibo) forControlEvents:UIControlEventTouchUpInside];
        [weiboButton setFrame:CGRectMake(shareLeft, sharetop, sharebuttonWidth, sharebuttonWidth)];
        [shareBgView addSubview:weiboButton];
        
        UILabel* weiboLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(shareLeft-sharelabeloffsetX, sharelableTop, sharelabelwidth, sharelableHeight)]autorelease];
        weiboLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:14];
        weiboLabel.backgroundColor = [UIColor clearColor];
        weiboLabel.textColor = [UIColor whiteColor];
        weiboLabel.textAlignment = UITextAlignmentCenter;
        [weiboLabel setText:@"新浪微博"];
        [shareBgView addSubview:weiboLabel];
        
        shareLeft += space+sharebuttonWidth;
        UIButton* weixinButton = [self creatButton];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(shareToweixin) forControlEvents:UIControlEventTouchUpInside];
        [weixinButton setFrame:CGRectMake(shareLeft, sharetop, sharebuttonWidth, sharebuttonWidth)];
        [shareBgView addSubview:weixinButton];
        
        UILabel* weixinLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(shareLeft-sharelabeloffsetX, sharelableTop, sharelabelwidth, sharelableHeight)]autorelease];
        weixinLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:14];
        weixinLabel.backgroundColor = [UIColor clearColor];
        weixinLabel.textColor = [UIColor whiteColor];
        weixinLabel.textAlignment = UITextAlignmentCenter;
        [weixinLabel setText:@"微信好友"];
        [shareBgView addSubview:weixinLabel];
        
        shareLeft += space+sharebuttonWidth;
        UIButton* friendsButton = [self creatButton];
        [friendsButton setBackgroundImage:[UIImage imageNamed:@"share_friends"] forState:UIControlStateNormal];
        [friendsButton addTarget:self action:@selector(shareTofriends) forControlEvents:UIControlEventTouchUpInside];
        [friendsButton setFrame:CGRectMake(shareLeft, sharetop, sharebuttonWidth, sharebuttonWidth)];
        [shareBgView addSubview:friendsButton];
        
        UILabel* friendsLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(shareLeft-sharelabeloffsetX, sharelableTop, sharelabelwidth, sharelableHeight)]autorelease];
        friendsLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:14];
        friendsLabel.backgroundColor = [UIColor clearColor];
        friendsLabel.textColor = [UIColor whiteColor];
        friendsLabel.textAlignment = UITextAlignmentCenter;
        [friendsLabel setText:@"朋友圈"];
        [shareBgView addSubview:friendsLabel];
        
        UILabel* shareToLabel = [[[ UILabel alloc]initWithFrame:CGRectMake(shareBgLeft, shareBgY - 26, 100, 26)]autorelease];
        shareToLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:16];
        shareToLabel.backgroundColor = [UIColor clearColor];
        shareToLabel.textColor = [UIColor whiteColor];
        shareToLabel.textAlignment = UITextAlignmentLeft;
        [shareToLabel setText:@"分享到"];
        [self.view addSubview:shareToLabel];
        
        CGFloat phoneBgY = saveImageView.top+ saveWidth;
        UIView* phoneBgView = [[[UIView alloc]initWithFrame:CGRectMake(0, phoneBgY, PHONE_SCREEN_SIZE.width, (self.view.height -phoneBgY - (self.view.height - shareToLabel.top) ))]autorelease];
        phoneBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:phoneBgView];
        

        CGFloat photoTop = 30;
        CGFloat photoHeight = phoneBgView.height-2*photoTop;
        CGFloat photoWidth = (PHONE_SCREEN_SIZE.width/(PHONE_SCREEN_SIZE.height-80))*photoHeight;
        if (photoWidth >200) {
            photoWidth = 200;
        }
        CGFloat photoLeft = (phoneBgView.width - photoWidth)/2;
//        UIImageView* photoWhiteBgView = [[[UIImageView alloc]initWithFrame:CGRectMake(photoLeft, photoTop, photoWidth, photoHeight)]autorelease];
//        photoWhiteBgView.backgroundColor = [UIColor whiteColor];
//        [photoWhiteBgView setImage:[UIImage imageNamed:@"share_white_bg.png"]];
//        [phoneBgView addSubview:photoWhiteBgView];
//
//        CGFloat border = 6.0;
//        UIImageView* photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(border, border, photoWidth-2*border, photoHeight-2*border)]autorelease];
//        photoImage.backgroundColor = [UIColor clearColor];
//        [photoImage setImage:self.syImage];
//        [photoWhiteBgView addSubview:photoImage];
        
        UIImageView* photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(photoLeft, photoTop, photoWidth, photoHeight)]autorelease];
        photoImage.layer.shadowOffset = CGSizeMake(0, 2);
        photoImage.layer.shadowColor = [UIColor whiteColor].CGColor;
        photoImage.layer.shadowOpacity = 0.1;
        photoImage.backgroundColor = [UIColor clearColor];
        photoImage.layer.borderColor = [UIColor whiteColor].CGColor;
        photoImage.layer.borderWidth = 8.0;
        [photoImage setImage:self.syImage];
        [photoImage.layer setShouldRasterize:YES];
        [phoneBgView addSubview:photoImage];
        
        CGFloat jiaobuWidth = 80;
        CGFloat jiaobuHeigth = 60;
        UIImageView* upimage = [[[UIImageView alloc]initWithFrame:CGRectMake(photoLeft-jiaobuWidth/3, photoTop-jiaobuHeigth/3, jiaobuWidth, jiaobuHeigth)]autorelease];
        upimage.backgroundColor = [UIColor clearColor];
        [upimage setImage:[UIImage imageNamed:@"share_jiaobu_up"]];
        [phoneBgView addSubview:upimage];
        
        UIImageView* downImage = [[[UIImageView alloc]initWithFrame:CGRectMake(photoLeft+photoWidth - jiaobuWidth/3*2, photoTop+photoHeight-jiaobuHeigth/3*2, jiaobuWidth, jiaobuHeigth)]autorelease];
        downImage.backgroundColor = [UIColor clearColor];
        [downImage setImage:[UIImage imageNamed:@"share_jiaobu_down"]];
        [phoneBgView addSubview:downImage];
        

        phoneBgView.transform = CGAffineTransformMakeRotation(M_PI/18);
    }
}

-(void)shareToweibo
{

    NSString* shareText = @"分享图片";
    
    LYWeiBoViewController* weiboController = [[LYWeiBoViewController alloc] initWithShareText:shareText ShareImage:self.syImage parent:self];
    
    [self.navigationController presentModalViewController:weiboController animated:YES];
    [weiboController release];
}

-(void)shareToweixin
{
    NSString* shareText = @"分享图片";
    [[LYShareKit defaultShare] changeScene:WXSceneSession];
    UIImage* smallImage = [self thumbnailWithImageWithoutScale:self.syImage size:CGSizeMake(96, 144)];
    NSData *data;
    if (UIImagePNGRepresentation(self.syImage) == nil) {
        data = UIImageJPEGRepresentation(self.syImage, 1);
    } else {
        data = UIImagePNGRepresentation(self.syImage);
    }
    [[LYShareKit defaultShare] sendImageAndText:smallImage data:data title:shareText description:nil url:nil];
}

-(void)shareTofriends
{
    NSString* shareText = @"分享图片";
    [[LYShareKit defaultShare] changeScene:WXSceneTimeline];
    UIImage* smallImage = [self thumbnailWithImageWithoutScale:self.syImage size:CGSizeMake(96, 144)];
    NSData *data;
    if (UIImagePNGRepresentation(self.syImage) == nil) {
        data = UIImageJPEGRepresentation(self.syImage, 1);
    } else {
        data = UIImagePNGRepresentation(self.syImage);
    }
    [[LYShareKit defaultShare] sendImageAndText:smallImage data:data title:shareText description:nil url:nil];
}

-(void)continueTakePicture
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)creatTopView
{
    @autoreleasepool {
        UIImageView* view = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.width, CONTENT_NAVIGATIONBAR_HEIGHT)]autorelease];
        view.backgroundColor = [UIColor clearColor];
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
        [titleLabel setText:@"保存/分享"];
        [view addSubview:titleLabel];
        
        UIButton* button = [self creatButton];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"share_navi_back"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"share_navi_back_pressed"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(10, (view.height - 30.5)/2, 50.5, 30.5)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        button.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        [button.titleLabel setFont:[UIFont fontWithName:MED_HEITI_FONT size:14]];
        [view addSubview:button];
        
        [self.view addSubview: view];
    }
}

-(void)close
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}
@end
