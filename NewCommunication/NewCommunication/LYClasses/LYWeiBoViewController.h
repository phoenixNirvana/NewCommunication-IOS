//
//  LYWeiBoViewController.h
//  Leyingke
//
//  Created by yu on 12-12-24.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavModeViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface LYWeiBoViewController : LYBaseViewController<UITextViewDelegate,SinaWeiboDelegate, SinaWeiboRequestDelegate>{
    NSString        *_shareText;
    UIImage         *_shareImage;
    UITextView      *_contentTextView;
    UIView          *_panelView;
    UIImageView     *_contentImageView;
    UILabel         *_wordCountLabel;
    UIViewController *_parentController;
    UIButton* _sendButton;
}

@property (nonatomic,retain) NSString       *shareText;
@property (nonatomic,retain) UIImage        *shareImage;
@property (nonatomic,retain) UITextView     *contentTextView;
@property (nonatomic,retain) UIView         *panelView;
@property (nonatomic,retain) UIImageView    *contentImageView;
@property (nonatomic,retain) UILabel        *wordCountLabel;
@property (nonatomic,assign) BOOL           needasy;
@property (nonatomic,retain) UIButton*      sendButton;

- (id)initWithShareText:(NSString*)shareText ShareImage:(UIImage*)shareImage parent:(UIViewController*)parent;
@end
