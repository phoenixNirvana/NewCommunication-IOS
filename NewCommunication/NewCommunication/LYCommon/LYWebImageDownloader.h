//
//  LYWebImageDownloader.h
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYBaseURLRequest.h"
#import "YURLRequestDelegate.h"

@protocol LYWebImageDownloaderDelegate;

@interface LYWebImageDownloader : NSObject<YURLRequestDelegate>{
    NSString* _url;
    id<LYWebImageDownloaderDelegate> _delegate;
    NSMutableData* _imageData;
    id _userInfo;
    LYBaseURLRequest* _request;
}
@property (nonatomic, copy)NSString* url;
@property (nonatomic, assign)id<LYWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain)NSMutableData* imageData;
@property (nonatomic, retain)id userInfo;

+ (id)downloaderWithURL:(NSString*)url userInfo:(id)userInfo delegate:(id<LYWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;

@end


@protocol LYWebImageDownloaderDelegate <NSObject>

@optional

- (void)imageDownloaderDidFinish:(LYWebImageDownloader *)downloader;
- (void)imageDownloader:(LYWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;
- (void)imageDownloader:(LYWebImageDownloader *)downloader didFailWithError:(NSError *)error;

@end
