//
//  LYNavigationBar.m
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavigationBar.h"
#import "LYCommon.h"

#define MAX_EXTENDBUTTON_COUNT 3
#define BACKBUTTON_X 5
#define DEFAULT_BUTTON_SIZE CGSizeMake(50.5, 32.5)
#define RIGHTBUTTON_X_OFFSET 5
#define TITLE_HASBACK_X_OFFSET 10 // 有返回按钮时title相对返回按钮的位移
#define TITLE_X_OFFSET 60 // 没有返回按钮时title相对边界的位移
#define EXPANDFLAG_X_OFFSET 6
#define BUTTONS_X_OFFSET 11
#define BUTTONS_SPACE_WIDTH 9

#define EXPAND_ANIMATION_INTERVAL 0.3

@implementation LYNavigationBar
@synthesize backgroundView = _backgroundView;
@synthesize backButton = _backButton;
@synthesize rightButton = _rightButton;
@synthesize title = _title;
@synthesize titleLabel = _titleLabel;
@synthesize backButtonEnable = _backButtonEnable;
@synthesize rightButtonEnable = _rightButtonEnable;

- (void)dealloc {
    self.backgroundView = nil;
    LY_RELEASE_SAFELY(_backButton);
    self.rightButton = nil;
    self.title = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIImage *background = [UIImage middleStretchableImageWithName:@"navigationbar_background"];
        UIImage* background = [UIImage imageNamed:@"navigation_bg"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
        backgroundView.frame =CGRectMake(0, 0, frame.size.width, CONTENT_NAVIGATIONBAR_HEIGHT);
        self.backgroundView = backgroundView;
        LY_RELEASE_SAFELY(backgroundView);
        [self addSubview:self.backgroundView];
        self.backgroundColor = [UIColor grayColor];
        
        _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self addSubview:self.backButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton = rightButton;
        [self addSubview:self.rightButton];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font  = [UIFont fontWithName:MED_HEITI_FONT size:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel = titleLabel;
        self.titleLabel.userInteractionEnabled = YES;
        LY_RELEASE_SAFELY(titleLabel);
        [self addSubview:self.titleLabel];
        
        self.backButtonEnable = NO;
        self.rightButtonEnable = NO;
    }
    return self;
}

- (void)layoutSubviews{
    if (self.backButtonEnable) {
        CGSize backbuttonSize = [[self.backButton currentImage] size];
        if (CGSizeEqualToSize(backbuttonSize, CGSizeZero)) {
            backbuttonSize = DEFAULT_BUTTON_SIZE;
        }
        CGRect backbuttonFrame = CGRectMake(BACKBUTTON_X,
                                            (CONTENT_NAVIGATIONBAR_HEIGHT - backbuttonSize.height)/2,
                                            backbuttonSize.width,
                                            backbuttonSize.height);
        self.backButton.frame = CGRectIntegral(backbuttonFrame);
        // 先显示文字
//        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
//        [self.backButton setBackgroundColor:[UIColor blackColor]];
//        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_back_normal"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_back_pressed"] forState:UIControlStateNormal];
    }
    //self.backgroundView.frame = self.frame;
    self.backgroundView.frame = CGRectMake(0, 0, self.width, self.height);
    CGSize titleSize = [self.title sizeWithFont:self.titleLabel.font];
    self.titleLabel.text = self.title;
    
    CGFloat originalX = self.backButtonEnable ? CGRectGetMaxX(self.backButton.frame) + TITLE_HASBACK_X_OFFSET : TITLE_X_OFFSET;
    
    CGRect titleFrame = CGRectMake(originalX,
                                   (CONTENT_NAVIGATIONBAR_HEIGHT - titleSize.height)/2,
                                   self.frame.size.width-2*originalX,
                                   titleSize.height);
    if (self.rightButtonEnable) {
        CGSize rightButtonSize = self.rightButton.size;
        if (CGSizeEqualToSize(rightButtonSize, CGSizeZero)) {
            rightButtonSize = self.rightButton.currentImage.size;
        }
        
        if (CGSizeEqualToSize(rightButtonSize, CGSizeZero)) {
            rightButtonSize = self.rightButton.currentBackgroundImage.size;
        }
        
        CGRect rightButtonFrame = CGRectMake(self.bounds.size.width - RIGHTBUTTON_X_OFFSET - rightButtonSize.width,
                                             (CONTENT_NAVIGATIONBAR_HEIGHT - rightButtonSize.height)/2,
                                             rightButtonSize.width,
                                             rightButtonSize.height);
        self.rightButton.frame = CGRectIntegral(rightButtonFrame);
        
        
        CGFloat labelWidth = self.rightButton ? CGRectGetMinX(self.rightButton.frame) - originalX : self.bounds.size.width - originalX;
        titleFrame = CGRectMake(originalX,
                                (CONTENT_NAVIGATIONBAR_HEIGHT - titleSize.height)/2,
                                labelWidth,
                                titleSize.height);
    }else{ 
        
    }
    
    self.titleLabel.frame = CGRectIntegral(titleFrame);
}

- (CGFloat)barHeight{
    return CONTENT_NAVIGATIONBAR_HEIGHT;
}

- (void)setBackButtonEnable:(BOOL)backButtonEnable{
    _backButtonEnable = backButtonEnable;
    self.backButton.hidden = !_backButtonEnable;
}

- (void)setRightButtonEnable:(BOOL)rightButtonEnable{
    _rightButtonEnable = rightButtonEnable;
    self.rightButton.hidden = !_rightButtonEnable;
}

@end
