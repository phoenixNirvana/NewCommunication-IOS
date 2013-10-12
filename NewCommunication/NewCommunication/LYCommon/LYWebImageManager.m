//
//  LYWebImageManager.m
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYWebImageManager.h"
#import <objc/message.h>

static LYWebImageManager *instance;

@implementation LYWebImageManager

+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[LYWebImageManager alloc] init];
    }
    
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _downloadDelegates = [[NSMutableArray alloc] init];
        _downloaders = [[NSMutableArray alloc] init];
        _downloaderForURL = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    LY_RELEASE_SAFELY(_downloadDelegates);
    LY_RELEASE_SAFELY(_downloaders);
    LY_RELEASE_SAFELY(_downloaderForURL);
    [super dealloc];
}

- (void)downloadWithURL:(NSString *)url delegate:(id<LYWebImageManagerDelegate>)delegate
{
    if ([url isKindOfClass:NSString.class])
    {
//        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (!url || !delegate)
    {
        return;
    }
    
    // Check the on-disk cache async so we don't block the main thread
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:delegate, @"delegate", url, @"url", nil];
    
//    [[RRWebImageCache sharedImageCache] queryDiskCacheForKey:[url absoluteString] delegate:self userInfo:info];
    LYWebImageDownloader *downloader = [_downloaderForURL objectForKey:url];
    
    if (!downloader)
    {
        downloader = [LYWebImageDownloader downloaderWithURL:url userInfo:info delegate:self];
        [_downloaders addObject:downloader];
        [_downloadDelegates addObject:delegate];
        [_downloaderForURL setObject:downloader forKey:url];
        
        [downloader start];
        //downloader.delegate = self;
    }
    else
    {
        // Reuse shared downloader
        downloader.userInfo = info;
        [_downloaders addObject:downloader];
        [_downloadDelegates addObject:delegate];
        [_downloaderForURL setObject:downloader forKey:url];
    }
    
}


- (void)cancelForDelegate:(id<LYWebImageManagerDelegate>)delegate
{
    NSUInteger idx;
 
    while ((idx = [_downloadDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        LYWebImageDownloader *downloader = [[_downloaders objectAtIndex:idx] retain];
        
        [_downloadDelegates removeObjectAtIndex:idx];
        [_downloaders removeObjectAtIndex:idx];
        
        if (![_downloaders containsObject:downloader])
        {
            // No more delegate are waiting for this download, cancel it
            [downloader cancel];
            [_downloaderForURL removeObjectForKey:downloader.url];
        }
        
        [downloader release];
    }
}

#pragma mark SDWebImageDownloaderDelegate

- (void)imageDownloader:(LYWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    [downloader retain];
    
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[_downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        LYWebImageDownloader *aDownloader = [_downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<LYWebImageManagerDelegate> delegate = [_downloadDelegates objectAtIndex:uidx];
            [delegate retain];
            [delegate autorelease];
            
            if (image)
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, downloader.url);
                }
            }
            else
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:nil];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, nil, downloader.url);
                }
            }
            
            [_downloaders removeObjectAtIndex:uidx];
            [_downloadDelegates removeObjectAtIndex:uidx];
        }
    }
        
    // Release the downloader
    [_downloaderForURL removeObjectForKey:downloader.url];
    [downloader release];
}

- (void)imageDownloader:(LYWebImageDownloader *)downloader didFailWithError:(NSError *)error;
{
    [downloader retain];
    
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[_downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        LYWebImageDownloader *aDownloader = [_downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<LYWebImageManagerDelegate> delegate = [_downloadDelegates objectAtIndex:uidx];
            [delegate retain];
            [delegate autorelease];
            
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
            {
                [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, error, downloader.url);
            }
            
            [_downloaders removeObjectAtIndex:uidx];
            [_downloadDelegates removeObjectAtIndex:uidx];
        }
    }
    
    // Release the downloader
    [_downloaderForURL removeObjectForKey:downloader.url];
    [downloader release];
}

@end
