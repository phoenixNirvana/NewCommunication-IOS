//
//  LYNavModeViewController.h
//  Leyingke
//
//  Created by yu on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYModelViewController.h"
#import "LYNavigationBar.h"

@interface LYNavModeViewController : LYModelViewController{
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
