//
//  LYPhotoViewController.h
//  LYPaizhao
//
//  Created by liuyong on 13-9-29.
//  Copyright (c) 2013年 乐影客. All rights reserved.
//

#import "LYBaseViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface LYPhotoViewController : LYBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *_imagePickerController;
    
    
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    
    UIImage *_finishImage;
    
    
    UIImageView *_photoImageView;
    UIScrollView *_watermarkScroll;
    UIView *_cameraView;
    UIButton *_takePhotoButton;
    UIButton *_flashButton;
    UIButton *_positionButton;
    UIButton *_okButton;
    UIButton *_cancelButton;
    UIButton *_selectPhotoButton;
    
    NSInteger currentPageIndex;
    NSInteger totalPages;
    NSMutableArray * _imageNameArr;

    
}
@property (nonatomic,retain) UIImagePickerController *imagePickerController;

@property (nonatomic,retain) UIScrollView *watermarkScroll;
@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) UIView *cameraView;
@property (nonatomic,retain) UIButton *takePhotoButton;
@property (nonatomic,retain) UIButton *flashButton;
@property (nonatomic,retain) UIButton *positionButton;
@property (nonatomic,retain) UIButton *okButton;
@property (nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) UIButton *selectPhotoButton;
@property(nonatomic,retain)  NSMutableArray * imageNameArr;
@end
