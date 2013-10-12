//
//  UIImage+LYAdditions.m
//  Leyingke
//
//  Created by 思 高 on 12-9-7.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "UIImage+LYAdditions.h"

static void AddRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
								 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (LYAdditions)

+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size {    
// 创建一个bitmap的context    
// 并把它设置成为当前正在使用的context    
UIGraphicsBeginImageContext(size);    

// 绘制改变大小的图片    
[image drawInRect:CGRectMake(0, 0, size.width, size.height)];    

// 从当前context中创建一个改变大小后的图片    
UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    

// 使当前的context出堆栈    
UIGraphicsEndImageContext();    

// 返回新的改变大小后的图片    
return scaledImage;
}

//截取部分图像  
+ (UIImage*)getSubImage:(UIImage *)img rect:(CGRect)rect  
{  
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];  
    UIGraphicsEndImageContext();  
    
    CGImageRelease(subImageRef);
    return smallImage;  
} 


+ (UIImage*)middleStretchableImageWithKey:(NSString*)key {
//    UIImage *image = [[RCResManager getInstance] imageForKey:key];
//    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return nil;
}

+ (UIImage*)middleStretchableImageWithName:(NSString*)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

/*create round rect UIImage with the specific size*/
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    AddRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *imageMask = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return imageMask;
	
}
//等比缩放
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {  
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));  
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];  
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return scaledImage;  
}  
// 缩放图片并且剧中截取
+ (UIImage *)middleScaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    float scaleSize = 0.0;
    CGSize imagesize = [image size];
    if (imagesize.width >= imagesize.height) {
        scaleSize = size.height/imagesize.height;
    }else{
        scaleSize = size.width/imagesize.width;
    }
    UIImage *currentimage = [UIImage scaleImage:image toScale:scaleSize];
    CGRect currentfram = CGRectMake((currentimage.size.width - size.width)/2, (currentimage.size.height - size.height)/2, size.width, size.height);
    
    // 返回新的改变大小后的图片    
    return [UIImage getSubImage:currentimage rect:currentfram];
}
//等比例缩放  
+(UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size   
{  
    CGFloat width = CGImageGetWidth(image.CGImage);  
    CGFloat height = CGImageGetHeight(image.CGImage);  
    
    float verticalRadio = size.height*1.0/height;   
    float horizontalRadio = size.width*1.0/width;  
    
    float radio = 1;  
    if(verticalRadio>1 && horizontalRadio>1)  
    {  
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;     
    }  
    else  
    {  
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;     
    }  
    
    width = width*radio;  
    height = height*radio;  
    
    int xPos = (size.width - width)/2;  
    int yPos = (size.height-height)/2;  
    
    // 创建一个bitmap的context    
    // 并把它设置成为当前正在使用的context    
    UIGraphicsBeginImageContext(size);    
    
    // 绘制改变大小的图片    
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];    
    
    // 从当前context中创建一个改变大小后的图片    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    
    
    // 使当前的context出堆栈    
    UIGraphicsEndImageContext();    
    
    // 返回新的改变大小后的图片    
    return scaledImage;  
} 

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
