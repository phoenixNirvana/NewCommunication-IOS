//
//  UIImageView+LYWebImage.m
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "UIImageView+LYWebImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (LYWebImage)

- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    LYWebImageManager *manager = [LYWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)addTargetForTouch:(id)target action:(SEL)action
{
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc]   
                                          initWithTarget:target action:action]autorelease];
    [self addGestureRecognizer:singleTap]; 
}

- (void)cancelCurrentImageLoad
{
    [[LYWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(LYWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
}

- (void)webImageManager:(LYWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    // 处理错误
}

@end
