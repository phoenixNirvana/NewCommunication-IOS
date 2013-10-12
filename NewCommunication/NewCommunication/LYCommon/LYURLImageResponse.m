//
//  LYURLImageResponse.m
//  Leyingke
//
//  Created by 思 高 on 12-9-21.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYURLImageResponse.h"
#import "YURLCache.h"
#import "YURLRequest.h"

@implementation LYURLImageResponse

@synthesize image = _image;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    LY_RELEASE_SAFELY(_image);
    
    [super dealloc];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTURLResponse


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSError*)request:(YURLRequest*)request processResponse:(NSHTTPURLResponse*)response
               data:(id)data {
    // This response is designed for NSData and UIImage objects, so if we get anything else it's
    // probably a mistake.
//    TTDASSERT([data isKindOfClass:[UIImage class]]
//              || [data isKindOfClass:[NSData class]]);
//    TTDASSERT(nil == _image);
    
    if ([data isKindOfClass:[UIImage class]]) {
        _image = [data retain];
        
    } else if ([data isKindOfClass:[NSData class]]) {
        // TODO(jverkoey Feb 10, 2010): This logic doesn't entirely make sense. Why don't we just store
        // the data in the cache if there was a cache miss, and then just retain the image data we
        // downloaded? This needs to be tested in production.
        UIImage* image = nil;
        if(!(request.cachePolicy | YURLRequestCachePolicyNoCache)) {
            image = [[YURLCache sharedCache] imageForURL:request.urlPath fromDisk:NO];
        }
        if (nil == image) {
            image = [UIImage imageWithData:data];
        }
        if (nil != image) {
            if (!request.respondedFromCache) {
                // XXXjoe Working on option to scale down really large images to a smaller size to save memory
                //        if (image.size.width * image.size.height > (300*300)) {
                //          image = [image transformWidth:300 height:(image.size.height/image.size.width)*300.0
                //                         rotate:NO];
                //          NSData* data = UIImagePNGRepresentation(image);
                //          [[TTURLCache sharedCache] storeData:data forURL:request.URL];
                //        }
                [[YURLCache sharedCache] storeImage:image forURL:request.urlPath];
            }
            
            _image = [image retain];
            
        } else {
            return [NSError errorWithDomain:@"leying.com" code:1001 userInfo:nil];        
        }
    }
    
    return nil;
}



@end
