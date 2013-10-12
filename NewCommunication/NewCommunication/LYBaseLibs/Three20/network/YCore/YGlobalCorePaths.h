//
//  YGlobalCorePaths.h
//  yushiyi
//
//  Created by yu shiyi on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @return YES if the URL begins with "bundle://"
 */
BOOL YIsBundleURL(NSString* URL);

/**
 * @return YES if the URL begins with "documents://"
 */
BOOL YIsDocumentsURL(NSString* URL);

/**
 * Used by TTPathForBundleResource to construct the bundle path.
 *
 * Retains the given bundle.
 *
 * @default nil (See TTGetDefaultBundle for what this means)
 */
void YSetDefaultBundle(NSBundle* bundle);

/**
 * Retrieves the default bundle.
 *
 * If the default bundle is nil, returns [NSBundle mainBundle].
 *
 * @see TTSetDefaultBundle
 */
NSBundle* YGetDefaultBundle();

/**
 * @return The main bundle path concatenated with the given relative path.
 */
NSString* YPathForBundleResource(NSString* relativePath);

/**
 * @return The documents path concatenated with the given relative path.
 */
NSString* YPathForDocumentsResource(NSString* relativePath);

