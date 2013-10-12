//
//  LYNavigationBar.h
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseView.h"

@interface LYNavigationBar : LYBaseView{
    // 背景
    UIImageView *_backgroundView;
    // 返回按钮
    UIButton *_backButton;
    // 右侧按钮
    UIButton *_rightButton;
    // 标题
    NSString *_title;
    // 标题Label
    UILabel *_titleLabel;
    // 返回按钮是否可用
    BOOL _backButtonEnable;
    // 右侧按钮是否可用
    BOOL _rightButtonEnable;
}
/*
 * 背景
 */
@property (nonatomic, retain) UIImageView *backgroundView;

/*
 * 返回按钮
 */
@property (nonatomic, readonly) UIButton *backButton;

/*
 * 右侧按钮，右侧按钮和右侧扩展按钮二选一
 */
@property (nonatomic, retain) UIButton *rightButton;

/*
 * 标题
 */
@property (nonatomic, copy) NSString *title;

/*
 * 标题Label
 */
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, assign) BOOL backButtonEnable;
@property (nonatomic, assign) BOOL rightButtonEnable;

@end
