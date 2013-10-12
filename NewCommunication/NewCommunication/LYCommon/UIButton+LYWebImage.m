//
//  UIButton+LYWebImage.m
//  Leyingke
//
//  Created by 思 高 on 12-11-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "UIButton+LYWebImage.h"

@implementation UIButton (LYWebImage)

- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    LYWebImageManager *manager = [LYWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    [self setImage:placeholder forState:UIControlStateNormal];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[LYWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(LYWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

@end
