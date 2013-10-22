//
//  LYPhotoViewController.m
//  LYPaizhao
//
//  Created by liuyong on 13-9-29.
//  Copyright (c) 2013年 乐影客. All rights reserved.
//

#import "LYPhotoViewController.h"
#import "LYSharePhotoViewController.h"
#define bottom_height 60
#define top_height 40
#import "LYColorMatrix.h"
@interface LYPhotoViewController ()

@end

@implementation LYPhotoViewController

@synthesize  imagePickerController = _imagePickerController;
@synthesize cameraView = _cameraView;
@synthesize takePhotoButton = _takePhotoButton;
@synthesize flashButton = _flashButton;
@synthesize positionButton = _positionButton;
@synthesize okButton = _okButton;
@synthesize cancelButton = _cancelButton;
@synthesize selectPhotoButton = _selectPhotoButton;
@synthesize photoImageView = _photoImageView;
@synthesize watermarkScroll = _watermarkScroll;
@synthesize imageEffectScroll = _imageEffectScroll;
@synthesize imageNameArr =_imageNameArr;
@synthesize effectButton = _effectButton;
@synthesize effectImage = _effectImage;
- (void)dealloc
{
    self.imagePickerController = nil;
    self.cameraView = nil;
    self.takePhotoButton = nil;
    self.flashButton = nil;
    self.positionButton = nil;
    self.okButton = nil;
    self.cancelButton = nil;
    self.selectPhotoButton = nil;
    self.photoImageView = nil;
    self.watermarkScroll = nil;
    self.imageNameArr = nil;
    self.effectButton = nil;
    self.imageEffectScroll = nil;
    self.effectImage = nil;
    [super dealloc];
}
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self creatCameraView];
    
    [self creatBottomView];
    
    [self initialize];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.cameraView.frame.size.width, self.cameraView.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.cameraView.layer addSublayer:_preview];
    effectTag = 1;
    
    UIImageView *imgaView = [[UIImageView alloc] init];
    [imgaView setBackgroundColor:[UIColor clearColor]];
    imgaView.frame = self.cameraView.bounds;
    self.photoImageView = imgaView;
    [_preview addSublayer:imgaView.layer];
    [imgaView release];
    
    [self initWaterScroll];
    [self initEffectScroll];
    
    
    [self creatFlashAndPositionBtn];
}

-(void)initImageArrays
{

    self.imageNameArr = [NSMutableArray arrayWithObjects:@"guilai",@"+",@"diaobao",@"gay",@"geili",@"jiayou",@"niuqi",@"nixi",@"qiubaoyang",@"xiongqi",@"youKnow",@"youMan",@"yourSister",@"yuanfang",@"zan", nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginTakePhoto];
    
}
- (void)beginTakePhoto
{
    self.okButton.hidden = YES;
    self.effectButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.takePhotoButton.hidden = NO;
    self.selectPhotoButton.hidden = NO;
    self.photoImageView.hidden = YES;
    //    if (!_preview.superlayer) {
    //        [self.cameraView.layer addSublayer:_preview];
    //    }
    [_session startRunning];
    
}
- (void)finshTakePhoto
{
    self.okButton.hidden = NO;
    self.effectButton.hidden = NO;
    self.cancelButton.hidden = NO;
    self.takePhotoButton.hidden = YES;
    self.selectPhotoButton.hidden = YES;
    self.photoImageView.hidden = NO;
    

    self.effectImage = [_finishImage copy];
    self.photoImageView.image = _finishImage;
    //    if (_preview.superlayer) {
    //        [_preview removeFromSuperlayer];
    //    }
    [_session stopRunning];
}
- (void)creatCameraView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PHONE_SCREEN_SIZE.height-bottom_height)];
    view.backgroundColor = [UIColor clearColor];
    self.cameraView = view;
    [self.view addSubview:view];

    
    [view release];
}
// 添加闪光和切换摄像头
- (void)creatFlashAndPositionBtn
{
    UIImageView *topView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, top_height)]autorelease];
    topView.backgroundColor = [UIColor clearColor];
    topView.userInteractionEnabled = YES;
    [self.cameraView addSubview:topView];
    
    CGFloat topleft = 15;
    CGFloat buttonHeight = 28;
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.backgroundColor = [UIColor clearColor];
    flashBtn.frame = CGRectMake(topleft, (topView.height -buttonHeight)/2, 65, buttonHeight);
    self.flashButton = flashBtn;
    [self.flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
    [self.flashButton addTarget:self action:@selector(changeFlash:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:flashBtn];
    
    
    UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    positionBtn.backgroundColor = [UIColor clearColor];
    positionBtn.frame = CGRectMake(PHONE_SCREEN_SIZE.width-55-topleft, (topView.height -buttonHeight)/2, 55, buttonHeight);
    self.positionButton = positionBtn;
    [self.positionButton setImage:[UIImage imageNamed:@"camera_button_switch_camera"] forState:UIControlStateNormal];
    [self.positionButton addTarget:self action:@selector(positionChange:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:positionBtn];
    
}
//// 添加拍照，取消，确定，获取图片列表
- (void)creatBottomView
{
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_SIZE.height-bottom_height, self.view.frame.size.width, bottom_height)];
    bottomView.backgroundColor = [UIColor clearColor];
    [bottomView setImage:[UIImage imageNamed:@"bottom_bg"]];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    CGFloat shootWidth = 56;
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoBtn.backgroundColor = [UIColor clearColor];
    [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"camera_shoot"] forState:UIControlStateNormal];
    [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"camera_shoot_pressed"] forState:UIControlStateHighlighted];
    [takePhotoBtn setFrame:CGRectMake((bottomView.width-shootWidth)/2, (bottomView.height-shootWidth)/2, shootWidth, shootWidth)];
    [takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.takePhotoButton = takePhotoBtn;
    [bottomView addSubview:takePhotoBtn];
    
    CGFloat start = 30;
    CGFloat buttonWidth = 28;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.backgroundColor = [UIColor clearColor];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"camera_btn_ok"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"camera_btn_ok_pressed"] forState:UIControlStateHighlighted];
    [okBtn setFrame:CGRectMake((bottomView.width-buttonWidth)/2, (bottomView.height-buttonWidth)/2, buttonWidth, buttonWidth)];
    [okBtn addTarget:self action:@selector(gotoController) forControlEvents:UIControlEventTouchUpInside];
    self.okButton = okBtn;
    okBtn.hidden = YES;
    [bottomView addSubview:okBtn];
    
    
    UIButton *effectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    effectBtn.backgroundColor = [UIColor clearColor];
    [effectBtn setBackgroundImage:[UIImage imageNamed:@"camera_btn_ok"] forState:UIControlStateNormal];
    [effectBtn setBackgroundImage:[UIImage imageNamed:@"camera_btn_ok_pressed"] forState:UIControlStateHighlighted];
    [effectBtn setFrame:CGRectMake(bottomView.width-buttonWidth-start, (bottomView.height-buttonWidth)/2, buttonWidth, buttonWidth)];
    [effectBtn addTarget:self action:@selector(addImageEffect) forControlEvents:UIControlEventTouchUpInside];
    self.effectButton = effectBtn;
    effectBtn.hidden = YES;
    [bottomView addSubview:effectBtn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"camera_cancel"] forState:UIControlStateNormal];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"camera_cancel_pressed"] forState:UIControlStateHighlighted];
    [cancleBtn setFrame:CGRectMake(start, (bottomView.height-buttonWidth)/2, buttonWidth, buttonWidth)];
    [cancleBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancleBtn;
    cancleBtn.hidden = YES;
    [bottomView addSubview:cancleBtn];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"camera_album"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"camera_album_pressed"] forState:UIControlStateHighlighted];
    [selectBtn setFrame:CGRectMake(start, (bottomView.height-buttonWidth)/2, buttonWidth, buttonWidth)];
    [selectBtn addTarget:self action:@selector(selectLibPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.selectPhotoButton = selectBtn;
    selectBtn.hidden = NO;
    [bottomView addSubview:selectBtn];
    
    
    [bottomView release];
}
- (void) initialize
{
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetMedium];
    
    //2.创建、配置输入设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [_device lockForConfiguration:nil];
      if([_device flashMode] == AVCaptureFlashModeOff){
        [self.flashButton setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
    }
    else if([_device flashMode] == AVCaptureFlashModeAuto){
        [self.flashButton setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
    }
    else{
        [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }
    [_device unlockForConfiguration];
    
	NSError *error;
	_captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
	if (!_captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    if ([_session canAddInput:_captureInput]) {
        [_session addInput:_captureInput];
    }
    
    
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    if ([_session canAddOutput:_captureOutput]) {
        [_session addOutput:_captureOutput];
    }
    [outputSettings release];
}
#pragma mark -
- (void)addHollowOpenToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"cameraIrisHollowOpen";
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)addHollowCloseToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];//初始化动画
    animation.duration = 0.5f;//间隔的时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIrisHollowClose";
    
    [view.layer addAnimation:animation forKey:@"HollowClose"];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

#pragma mark -
- (void)takePhoto:(id)sender
{
    [self addHollowCloseToView:self.cameraView];
    
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         [self addHollowCloseToView:self.cameraView];
         [_session stopRunning];
         [self addHollowOpenToView:self.cameraView];
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         _finishImage = [[UIImage alloc] initWithData:imageData];
         [self finshTakePhoto];
     }];
}

- (void)changeFlash:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && [_device hasFlash])
    {
        [self.flashButton setEnabled:NO];
        [_device lockForConfiguration:nil];
        if([_device flashMode] == AVCaptureFlashModeOff)
        {
            [_device setFlashMode:AVCaptureFlashModeAuto];
            [self.flashButton setImage:[UIImage imageNamed:@"flash_auto"] forState:UIControlStateNormal];
        }
        else if([_device flashMode] == AVCaptureFlashModeAuto)
        {
            [_device setFlashMode:AVCaptureFlashModeOn];
            [self.flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
        }
        else{
            [_device setFlashMode:AVCaptureFlashModeOff];
            [self.flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
        }
        [_device unlockForConfiguration];
        [self.flashButton setEnabled:YES];
    }
}
- (void)initEffectScroll
{
    NSArray *effectArr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐化",@"淡雅",@"酒红",@"清宁",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
    UIScrollView *effectScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.cameraView.height-bottom_height, PHONE_SCREEN_SIZE.width, bottom_height)];
    effectScroll.backgroundColor = [UIColor clearColor];
    effectScroll.showsHorizontalScrollIndicator = NO;
    self.imageEffectScroll = effectScroll;
    effectScroll.contentSize = CGSizeMake(10*(effectArr.count+1)+60*effectArr.count, bottom_height);
    
    for (int i = 0; i < effectArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+70*i, 0, bottom_height, bottom_height-10)];
        imageView.backgroundColor = RGBACOLOR(0, 0, 120, 1.0);
        [effectScroll addSubview:imageView];
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, bottom_height, 20)];
//        lable.center = imageView.center;
        lable.backgroundColor = [UIColor clearColor];
        lable.textAlignment = UITextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14.0];
        lable.textColor = [UIColor whiteColor];
        lable.text = [effectArr objectAtIndex:i];
        [imageView addSubview:lable];
        [lable release];
        
        UITapGestureRecognizer *panGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addEffect:)];
        [imageView addGestureRecognizer:panGes];
        [panGes release];
        [imageView release];
        
    }
    effectScroll.hidden = YES;
    [self.cameraView.layer addSublayer:effectScroll.layer];
    
    
}
- (void)initWaterScroll
{
    [self initImageArrays];
    if (self.imageNameArr) {
        totalPages = self.imageNameArr.count;
    }
    UIScrollView *waterScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, self.cameraView.height)];
    waterScroll.showsHorizontalScrollIndicator = NO;
    self.watermarkScroll = waterScroll;
    waterScroll.contentSize = CGSizeMake(waterScroll.width * totalPages, _watermarkScroll.frame.size.height);
    waterScroll.pagingEnabled = YES;
    waterScroll.backgroundColor = [UIColor clearColor];
    waterScroll.delegate = self;
    CGFloat width = waterScroll.width;
    for (int i = 0; i < totalPages; i++) {
        NSString* imageName = [self.imageNameArr objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imgView.frame = CGRectMake(i * width+10, 100, 160, 80);
        imgView.userInteractionEnabled = YES;
        imgView.tag = i+10;
        [waterScroll addSubview:imgView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWaterImage:)];
        [imgView addGestureRecognizer:panGes];
        [panGes release];
        [imgView release];
    }
    [self.cameraView.layer addSublayer:waterScroll.layer];
}
-(void)panWaterImage:(UIPanGestureRecognizer *)panGes
{
    CGPoint location = [panGes locationInView:self.watermarkScroll];
    CGRect rect = CGRectMake(currentPageIndex*self.watermarkScroll.width, self.watermarkScroll.top+top_height, self.watermarkScroll.width, self.watermarkScroll.height-top_height);
    CGFloat offsetx = panGes.view.width/2;
    CGFloat offsety = panGes.view.height/2;
    if (location.x -offsetx<rect.origin.x) {
        location.x = rect.origin.x+offsetx;
    }
    else if(location.x + offsetx > rect.origin.x+ rect.size.width)
    {
        location.x = rect.origin.x+ rect.size.width - offsetx;
    }
    
    if (location.y -offsety<rect.origin.y) {
        location.y = rect.origin.y+offsety;
    }
    else if(location.y > rect.origin.y+ rect.size.height - offsety)
    {
        location.y = rect.origin.y+ rect.size.height - offsety ;
    }
    
    panGes.view.center = CGPointMake(location.x,  location.y);
}
- (void)positionChange:(id)sender
{
    //添加动画
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .8f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    if (_device.position == AVCaptureDevicePositionFront) {
        animation.subtype = kCATransitionFromRight;
    }
    else if(_device.position == AVCaptureDevicePositionBack){
        animation.subtype = kCATransitionFromLeft;
    }
    
    [_preview addAnimation:animation forKey:@"animation"];
    
    NSArray *inputs = _session.inputs;
    for ( AVCaptureDeviceInput *input in inputs )
    {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            _device = newCamera;
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            
            [_session removeInput:input];
            [_session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
}
- (void)cancelAction:(id)sender
{
    [self beginTakePhoto];
}
#pragma mark -   /////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.allowsEditing = NO;
    self.imagePickerController = imagePickerController;
    //    LY_RELEASE_SAFELY(imagePickerController);
    [imagePickerController release];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self takephoto];
    
}
-(void)selectLibPhoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self pickPhotoWithSoureType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"模拟器不支持"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

#pragma mark ActionSheet Delegate Methods
/**
 * 获取照片，数据通过回调传回
 */
- (void)pickPhotoWithSoureType:(UIImagePickerControllerSourceType) sourceType{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        //do something
    }
    self.imagePickerController.sourceType = sourceType;
	self.imagePickerController.delegate = self;
    
    //[self.parentController presentModalViewController:self.imagePickerController animated:YES];
    [self.navigationController presentModalViewController:self.imagePickerController animated:YES];
    
}


#pragma -mark UIImagePickerControllerDelegate
#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1){
        
    }
    
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (![mediaType isEqualToString:@"public.image"]) {
        //        LY_NSLog(@"imagePickerController Error, mediaType video");
        return;
    }
    //check image
    _finishImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!_finishImage) {
        //        LY_NSLog(@"imagePickerController Error, cant get EditedImage");
        return;
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    
    [self finshTakePhoto];

}

- (void)gotoController
{
    [self goShareController];
}
- (void)addEffect:(UITapGestureRecognizer *)tagGes
{
    NSInteger tag = tagGes.view.tag;
    NSLog(@"%d",tag);
    if (effectTag == tag) {
        
    }else{
        self.effectImage = [self.effectImage fixOrientation];
        switch (tag) {
            case 1:
                
                break;
            case 2:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_lomo];
                break;
            case 3:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_heibai];
                break;
            case 4:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_huajiu];
                break;
            case 5:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_gete];
                break;
            case 6:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_ruise];
                break;
            case 7:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_danya];
                break;
            case 8:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_jiuhong];
                break;
            case 9:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_qingning];
                break;
            case 10:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_langman];
                break;
            case 11:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_guangyun];
                break;
            case 12:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_landiao];
                break;
            case 13:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_menghuan];
                break;
            case 14:
                _finishImage = [UIImage imageWithImage:self.effectImage withColorMatrix:colormatrix_yese];
                break;
                
            default:
                break;
        }
        self.photoImageView.image = _finishImage;
    }
    effectTag = tag;
    self.imageEffectScroll.hidden = YES;
}
- (void)addImageEffect
{
//    _finishImage = [_finishImage fixOrientation];
//    _finishImage = [UIImage imageWithImage:_finishImage withColorMatrix:colormatrix_heibai];
//    self.photoImageView.image = _finishImage;
    self.imageEffectScroll.hidden = NO;
}
-(void)goShareController
{
    UIView* view = [self creatBigSycView];
    if (view == nil) {
        return;
    }
    UIImage* image = [self convertViewToImage:view];
    if (nil != image) {
        UIImageWriteToSavedPhotosAlbum(image,self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
        LYSharePhotoViewController* view = [[LYSharePhotoViewController alloc]initWithImage:image];
        [self.navigationController pushViewController:view animated:YES];
        [view release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)creatSycView
{

    UIView* view = [[[UIView alloc]initWithFrame:self.cameraView.bounds]autorelease];
    UIImageView* imagePhoto = [[UIImageView alloc]initWithFrame:view.bounds];
    [imagePhoto setImage:_finishImage];
    [view addSubview:imagePhoto];
    
    UIImageView* maskView = (UIImageView*)[self.watermarkScroll viewWithTag:currentPageIndex+10];
    
    CGRect rect = CGRectMake(maskView.left-currentPageIndex*self.watermarkScroll.width, maskView.top, maskView.width, maskView.height);
    UIImageView* maskPhoto = [[UIImageView alloc]initWithFrame:rect];
    [maskPhoto setImage:maskView.image];
    [view addSubview:maskPhoto];

    [imagePhoto release];
    [maskPhoto release];
    return  view;
}

-(UIView*)creatBigSycView
{
    if (_finishImage == nil) {
        return nil;
    }
    CGRect viewrect =  CGRectMake(0, 0, _finishImage.size.width, _finishImage.size.height);
    UIView* view = [[[UIView alloc]initWithFrame:viewrect]autorelease];
    UIImageView* imagePhoto = [[UIImageView alloc]initWithFrame:view.bounds];
    [imagePhoto setImage:_finishImage];
    [view addSubview:imagePhoto];
    
    CGFloat priWidth = viewrect.size.width/self.cameraView.frame.size.width;
    CGFloat priHeight = viewrect.size.height/self.cameraView.frame.size.height;
    
    UIImageView* maskView = (UIImageView*)[self.watermarkScroll viewWithTag:currentPageIndex+10];
    
    CGRect rect = CGRectMake((maskView.left-currentPageIndex*self.watermarkScroll.width)*priWidth, maskView.top*priHeight, maskView.width*priWidth, maskView.height*priHeight);
    
    UIImageView* maskPhoto = [[UIImageView alloc]initWithFrame:rect];
    [maskPhoto setImage:maskView.image];
    [view addSubview:maskPhoto];
    
    [imagePhoto release];
    [maskPhoto release];
    return  view;
}
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo{
    if (error){
        
    }else{
        
        NSLog(@"保存成功");
    }
}


#pragma mark - UIScrollView Delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor(scrollView.contentOffset.x / pageWidth);
    currentPageIndex = page;
}
@end