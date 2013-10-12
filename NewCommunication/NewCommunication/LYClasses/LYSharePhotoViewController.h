//
//  LYSharePhotoViewController.h
//  LYPaizhao
//
//  Created by liuyong on 13-9-27.
//  Copyright (c) 2013年 乐影客. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYSharePhotoViewController : LYBaseViewController
{
    UIImage* syImage;
}
@property(nonatomic,retain)UIImage* syImage;

-(id)initWithImage:(UIImage*)image;
@end
