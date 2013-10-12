//
//  YURLCache.m
//  yushiyi
//
//  Created by yu shiyi on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YURLCache.h"
#import "YGlobalNetwork.h"
#import "YGlobalCorePaths.h"
#import "NSString+YAdditions.h"


static const  CGFloat   kLargeImageSize = 600.0f * 400.0f;

static        NSString* kDefaultCacheName       = @"Three20";
static        NSString* kEtagCacheDirectoryName = @"etag";

static YURLCache*          gSharedCache = nil;
static NSMutableDictionary* gNamedCaches = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface YURLCache()

/**
 * Creates paths as necessary and returns the cache path for the given name.
 */
+ (NSString*)cachePathWithName:(NSString*)name;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation YURLCache

@synthesize disableDiskCache  = _disableDiskCache;
@synthesize disableImageCache = _disableImageCache;
@synthesize cachePath         = _cachePath;
@synthesize maxPixelCount     = _maxPixelCount;
@synthesize invalidationAge   = _invalidationAge;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithName:(NSString*)name {
	self = [super init];
    if (self) {
        _name             = [name copy];
        _cachePath        = [[YURLCache cachePathWithName:name] retain];
        _invalidationAge  = Y_CACHE_EXPIRATION_AGE_NEVER;
        
        // XXXjoe Disabling the built-in cache may save memory but it also makes UIWebView slow
        // NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0
        // diskPath:nil];
        // [NSURLCache setSharedURLCache:sharedCache];
        // [sharedCache release];
        
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector(didReceiveMemoryWarning:)
         name: UIApplicationDidReceiveMemoryWarningNotification
         object: nil];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithName:kDefaultCacheName];
    if (self) {
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: UIApplicationDidReceiveMemoryWarningNotification
     object: nil];
    
    LY_RELEASE_SAFELY(_name);
    LY_RELEASE_SAFELY(_imageCache);
    LY_RELEASE_SAFELY(_imageSortedList);
    LY_RELEASE_SAFELY(_cachePath);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (YURLCache*)cacheWithName:(NSString*)name {
    if (nil == gNamedCaches) {
        gNamedCaches = [[NSMutableDictionary alloc] init];
    }
    YURLCache* cache = [gNamedCaches objectForKey:name];
    if (nil == cache) {
        cache = [[[YURLCache alloc] initWithName:name] autorelease];
        [gNamedCaches setObject:cache forKey:name];
    }
    return cache;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (YURLCache*)sharedCache {
    if (nil == gSharedCache) {
        gSharedCache = [[YURLCache alloc] init];
    }
    return gSharedCache;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setSharedCache:(YURLCache*)cache {
    if (gSharedCache != cache) {
        [gSharedCache release];
        gSharedCache = [cache retain];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)createPathIfNecessary:(NSString*)path {
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    return succeeded;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)cachePathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
    NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
    NSString* etagCachePath = [cachePath stringByAppendingPathComponent:kEtagCacheDirectoryName];
    
    [self createPathIfNecessary:cachesPath];
    [self createPathIfNecessary:cachePath];
    [self createPathIfNecessary:etagCachePath];
    
    return cachePath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)expireImagesFromMemory {
    while (_imageSortedList.count) {
        NSString* key = [_imageSortedList objectAtIndex:0];
        UIImage* image = [_imageCache objectForKey:key];
        //YDCONDITIONLOG(YDFLAG_URLCACHE, @"EXPIRING %@", key);
        
        _totalPixelCount -= image.size.width * image.size.height;
        [_imageCache removeObjectForKey:key];
        [_imageSortedList removeObjectAtIndex:0];
        
        if (_totalPixelCount <= _maxPixelCount) {
            break;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeImage:(UIImage*)image forURL:(NSString*)URL force:(BOOL)force {
    if (nil != image && (force || !_disableImageCache)) {
        int pixelCount = image.size.width * image.size.height;
        
        if (force || pixelCount < kLargeImageSize) {
            UIImage* existingImage = [_imageCache objectForKey:URL];
            if (nil != existingImage) {
                _totalPixelCount -= existingImage.size.width * existingImage.size.height;
                [_imageSortedList removeObject:URL];
            }
            _totalPixelCount += pixelCount;
            
            if (_totalPixelCount > _maxPixelCount && _maxPixelCount) {
                [self expireImagesFromMemory];
            }
            
            if (nil == _imageCache) {
                _imageCache = [[NSMutableDictionary alloc] init];
            }
            
            if (nil == _imageSortedList) {
                _imageSortedList = [[NSMutableArray alloc] init];
            }
            
            [_imageSortedList addObject:URL];
            [_imageCache setObject:image forKey:URL];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * TODO (jverkoey May 3, 2010): Clean up this redundant code.
 */
- (BOOL)imageExistsFromBundle:(NSString*)URL {
    NSString* path = YPathForBundleResource([URL substringFromIndex:9]);
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)imageExistsFromDocuments:(NSString*)URL {
    NSString* path = YPathForDocumentsResource([URL substringFromIndex:12]);
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)loadImageFromBundle:(NSString*)URL {
    NSString* path = YPathForBundleResource([URL substringFromIndex:9]);
    return [UIImage imageWithContentsOfFile:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)loadImageFromDocuments:(NSString*)URL {
    NSString* path = YPathForDocumentsResource([URL substringFromIndex:12]);
    return [UIImage imageWithContentsOfFile:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)loadEtagFromCacheWithKey:(NSString*)key {
    NSString* path = [self etagCachePathForKey:key];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)createTemporaryURL {
    static int temporaryURLIncrement = 0;
    return [NSString stringWithFormat:@"temp:%d", temporaryURLIncrement++];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)createUniqueTemporaryURL {
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* tempURL = nil;
    NSString* newPath = nil;
    do {
        tempURL = [self createTemporaryURL];
        newPath = [self cachePathForURL:tempURL];
    } while ([fm fileExistsAtPath:newPath]);
    return tempURL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSNotifications


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning:(void*)object {
    // Empty the memory cache when memory is low
    [self removeAll:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)etagCachePath {
    return [self.cachePath stringByAppendingPathComponent:kEtagCacheDirectoryName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)keyForURL:(NSString*)URL {
    return [URL md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    return [self cachePathForKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForKey:(NSString*)key {
    return [_cachePath stringByAppendingPathComponent:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)etagCachePathForKey:(NSString*)key {
    return [self.etagCachePath stringByAppendingPathComponent:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForURL:(NSString*)URL {
    NSString* filePath = [self cachePathForURL:URL];
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForURL:(NSString*)URL {
    return [self dataForURL:URL expires:Y_CACHE_EXPIRATION_AGE_NEVER timestamp:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge
            timestamp:(NSDate**)timestamp {
    NSString* key = [self keyForURL:URL];
    return [self dataForKey:key expires:expirationAge timestamp:timestamp];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
        NSDate* modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)modifiedForKey:(NSString*)key{
    NSString* modifiedkey = [NSString stringWithFormat:@"%@modified",key];
    NSString* filePath = [self cachePathForKey:modifiedkey];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return [NSData dataWithContentsOfFile:filePath];
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge
            timestamp:(NSDate**)timestamp {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
        NSDate* modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return nil;
        }
        if (timestamp) {
            *timestamp = modified;
        }
        
        return [NSData dataWithContentsOfFile:filePath];
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * This method needs to handle urlPaths with and without extensions.
 * So @"path.png" will resolve to @"path@2x.png" and
 *    @"path" will resolve to @"path@2x"
 *
 * Paths beginning with @"." will not be changed.
 */
+ (NSString*)doubleImageURLPath:(NSString*)urlPath {
    if ([[urlPath substringToIndex:1] isEqualToString:@"."]) {
        return urlPath;
    }
    
    // We'd ideally use stringByAppendingPathExtension: in this method, but it seems
    // to wreck bundle:// urls by replacing them with bundle:/ prefixes. Strange.
    NSString* pathExtension = [urlPath pathExtension];
    
    NSString* urlPathWithNoExtension = [urlPath substringToIndex:
                                        [urlPath length] - [pathExtension length]
                                        - (([pathExtension length] > 0) ? 1 : 0)];
    
    urlPath = [urlPathWithNoExtension stringByAppendingString:@"@2x"];
    
    if ([pathExtension length] > 0) {
        urlPath = [urlPath stringByAppendingFormat:@".%@", pathExtension];
    }
    
    return urlPath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasImageForURL:(NSString*)URL fromDisk:(BOOL)fromDisk {
    BOOL hasImage = (nil != [_imageCache objectForKey:URL]);
    
    if (!hasImage && fromDisk) {
        if (YIsBundleURL(URL)) {
            hasImage = [self imageExistsFromBundle:URL];
            if (!hasImage) {
                hasImage = [self imageExistsFromBundle:[YURLCache doubleImageURLPath:URL]];
            }
            
        } else if (YIsDocumentsURL(URL)) {
            hasImage = [self imageExistsFromDocuments:URL];
            if (!hasImage) {
                hasImage = [self imageExistsFromDocuments:[YURLCache doubleImageURLPath:URL]];
            }
            
        }
    }
    
    return hasImage;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)imageForURL:(NSString*)URL {
    return [self imageForURL:URL fromDisk:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)imageForURL:(NSString*)URL fromDisk:(BOOL)fromDisk {
    UIImage* image = [_imageCache objectForKey:URL];
    
    if (nil == image && fromDisk) {
        if (YIsBundleURL(URL)) {
            image = [self loadImageFromBundle:URL];
            [self storeImage:image forURL:URL];
            
        } else if (YIsDocumentsURL(URL)) {
            image = [self loadImageFromDocuments:URL];
            [self storeImage:image forURL:URL];
        }
    }
    
    return image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)etagForKey:(NSString*)key {
    return [self loadEtagFromCacheWithKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    [self storeData:data forKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forKey:(NSString*)key {
    if (!_disableDiskCache) {
        NSString* filePath = [self cachePathForKey:key];
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:data attributes:nil];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeModified:(NSString*)modified forKey:(NSString*)key {
    if (!_disableDiskCache) {
        NSString* modifiedkey = [NSString stringWithFormat:@"%@modified",key];
        NSString* filePath = [self cachePathForKey:modifiedkey];
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:[modified dataUsingEncoding: NSUTF8StringEncoding] attributes:nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeImage:(UIImage*)image forURL:(NSString*)URL {
    [self storeImage:image forURL:URL force:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeEtag:(NSString*)etag forKey:(NSString*)key {
    NSString* filePath = [self etagCachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath: filePath
                contents: [etag dataUsingEncoding:NSUTF8StringEncoding]
              attributes: nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storeTemporaryData:(NSData*)data {
    NSString* URL = [self createUniqueTemporaryURL];
    [self storeData:data forURL:URL];
    return URL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storeTemporaryFile:(NSURL*)fileURL {
    if ([fileURL isFileURL]) {
        NSString* filePath = [fileURL path];
        NSFileManager* fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:filePath]) {
            NSString* tempURL = nil;
            NSString* newPath = nil;
            do {
                tempURL = [self createTemporaryURL];
                newPath = [self cachePathForURL:tempURL];
            } while ([fm fileExistsAtPath:newPath]);
            
            if ([fm moveItemAtPath:filePath toPath:newPath error:nil]) {
                return tempURL;
            }
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storeTemporaryImage:(UIImage*)image toDisk:(BOOL)toDisk {
    NSString* URL = [self createUniqueTemporaryURL];
    [self storeImage:image forURL:URL force:YES];
    
    NSData* data = UIImagePNGRepresentation(image);
    [self storeData:data forURL:URL];
    return URL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveDataForURL:(NSString*)oldURL toURL:(NSString*)newURL {
    id image = [self imageForURL:oldURL];
    if (image) {
        [_imageSortedList removeObject:oldURL];
        [_imageCache removeObjectForKey:oldURL];
        [_imageSortedList addObject:newURL];
        [_imageCache setObject:image forKey:newURL];
    }
    NSString* oldKey = [self keyForURL:oldURL];
    NSString* oldPath = [self cachePathForKey:oldKey];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:oldPath]) {
        NSString* newKey = [self keyForURL:newURL];
        NSString* newPath = [self cachePathForKey:newKey];
        [fm moveItemAtPath:oldPath toPath:newPath error:nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveDataFromPath:(NSString*)path toURL:(NSString*)newURL {
    NSString* newKey = [self keyForURL:newURL];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSString* newPath = [self cachePathForKey:newKey];
        [fm moveItemAtPath:path toPath:newPath error:nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)moveDataFromPathToTemporaryURL:(NSString*)path {
    NSString* tempURL = [self createUniqueTemporaryURL];
    [self moveDataFromPath:path toURL:tempURL];
    return tempURL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeURL:(NSString*)URL fromDisk:(BOOL)fromDisk {
    [_imageSortedList removeObject:URL];
    [_imageCache removeObjectForKey:URL];
    
    if (fromDisk) {
        NSString* key = [self keyForURL:URL];
        NSString* filePath = [self cachePathForKey:key];
        NSFileManager* fm = [NSFileManager defaultManager];
        if (filePath && [fm fileExistsAtPath:filePath]) {
            [fm removeItemAtPath:filePath error:nil];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeKey:(NSString*)key {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (filePath && [fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAll:(BOOL)fromDisk {
    [_imageCache removeAllObjects];
    [_imageSortedList removeAllObjects];
    _totalPixelCount = 0;
    
    if (fromDisk) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:_cachePath error:nil];
        [YURLCache createPathIfNecessary:_cachePath];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    return [self invalidateKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateKey:(NSString*)key {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (filePath && [fm fileExistsAtPath:filePath]) {
        NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
        NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
                                                          forKey:NSFileModificationDate];
        
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
        [fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
        [fm changeFileAttributes:attrs atPath:filePath];
#endif
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateAll {
    NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
    NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
                                                      forKey:NSFileModificationDate];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator* e = [fm enumeratorAtPath:_cachePath];
    for (NSString* fileName; fileName = [e nextObject]; ) {
        NSString* filePath = [_cachePath stringByAppendingPathComponent:fileName];
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
        [fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
        [fm changeFileAttributes:attrs atPath:filePath];
#endif
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logMemoryUsage {
#if TTLOGLEVEL_INFO <= TTMAXLOGLEVEL
   // YDCONDITIONLOG(YDFLAG_URLCACHE, @"======= IMAGE CACHE: %d images, %d pixels ========",
                   // _imageCache.count, _totalPixelCount);
//    NSEnumerator* e = [_imageCache keyEnumerator];
//    for (NSString* key ; key = [e nextObject]; ) {
//        UIImage* image = [_imageCache objectForKey:key];
//        //YDCONDITIONLOG(YDFLAG_URLCACHE, @"  %f x %f %@", image.size.width, image.size.height, key);
//    }
#endif
}


@end