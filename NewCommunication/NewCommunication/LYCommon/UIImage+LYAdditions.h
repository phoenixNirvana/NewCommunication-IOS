//
//  UIImage+LYAdditions.h
//  Leyingke
//
//  Created by 思 高 on 12-9-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
@interface UIImage (LYAdditions)

// 缩放图片
+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//截取部分图像  
+ (UIImage*)getSubImage:(UIImage *)img rect:(CGRect)rect;
//中间拉伸自动宽高
+ (UIImage*)middleStretchableImageWithKey:(NSString*)key ;
+ (UIImage*)middleStretchableImageWithName:(NSString*)name;

+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius;

// 缩放图片并且剧中截取
+ (UIImage *)middleScaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//等比缩放到多少倍
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
//等比例缩放  
+(UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size;

- (UIImage *)fixOrientation;

//图片特效
+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;

@end
