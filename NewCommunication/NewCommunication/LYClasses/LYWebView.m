//
//  LYWebView.m
//  Leyingke
//
//  Created by 李 会强 on 13-4-25.
//  Copyright (c) 2013年 RenRen.com. All rights reserved.
//

#import "LYWebView.h"

@implementation LYWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
