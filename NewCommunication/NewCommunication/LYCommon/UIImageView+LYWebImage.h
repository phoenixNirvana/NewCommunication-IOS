//
//  UIImageView+LYWebImage.h
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYWebImageManager.h"

@interface UIImageView (LYWebImage)<LYWebImageManagerDelegate>

/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)setImageWithURL:(NSString *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see setImageWithURL:placeholderImage:options:
 */
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

// 增加触摸事件
- (void)addTargetForTouch:(id)target action:(SEL)action;

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;

@end
