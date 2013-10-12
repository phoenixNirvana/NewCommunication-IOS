//
//  LYWebImageManager.h
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYWebImageDownloader.h"

@protocol LYWebImageManagerDelegate;

@interface LYWebImageManager : NSObject<LYWebImageDownloaderDelegate>{
    NSMutableArray* _downloadDelegates;
    NSMutableArray* _downloaders;
    NSMutableDictionary* _downloaderForURL;
}
+ (id)sharedManager;
- (void)downloadWithURL:(NSString *)url delegate:(id<LYWebImageManagerDelegate>)delegate;
- (void)cancelForDelegate:(id<LYWebImageManagerDelegate>)delegate;


@end

@protocol LYWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(LYWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;
- (void)webImageManager:(LYWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url;
- (void)webImageManager:(LYWebImageManager *)imageManager didFailWithError:(NSError *)error;
- (void)webImageManager:(LYWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url;

@end
