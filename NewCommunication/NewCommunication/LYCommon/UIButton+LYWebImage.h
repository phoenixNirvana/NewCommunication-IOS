//
//  UIButton+LYWebImage.h
//  Leyingke
//
//  Created by 思 高 on 12-11-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYWebImageManager.h"

@interface UIButton (LYWebImage)<LYWebImageManagerDelegate>

/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url that the image is found.
 * @see setImageWithURL:placeholderImage:
 */
- (void)setImageWithURL:(NSString *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url that the `image` is found.
 * @param placeholder A `image` that will be visible while loading the final image.
 */
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;


@end
