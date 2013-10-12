//
//  LYNavigationViewController.h
//  Leyingke
//
//  Created by 思 高 on 12-9-4.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYNavigationBar.h"

@interface LYNavigationViewController : LYBaseViewController{
    LYNavigationBar* _navBar;
}
/*
 * 导航条
 */
@property (nonatomic, retain) LYNavigationBar *navBar;

/*
 * 设置navBar的显示或隐藏
 * 
 * @hidden 是否隐藏
 * @animated 是否有动画
 */
- (void)setNavBarHidden:(BOOL)hidden animated:(BOOL)animated;


@end
