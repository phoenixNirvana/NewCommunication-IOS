//
//  YModel.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YModel.h"
#import "YGlobalCore.h"
#import "NSArray+YAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation YModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    LY_RELEASE_SAFELY(_delegates);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)delegates {
    if (nil == _delegates) {
        _delegates = YCreateNonRetainingArray();
    }
    return _delegates;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoadingMore {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isOutdated {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(YURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidate:(BOOL)erase {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didStartLoad {
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad {
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad304 {
    [_delegates perform:@selector(modelDidFinishLoad304:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadWithError:(NSError*)error {
    [_delegates perform:@selector(model:didFailLoadWithError:) withObject:self
             withObject:error];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didCancelLoad {
    [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginUpdates {
    [_delegates perform:@selector(modelDidBeginUpdates:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endUpdates {
    [_delegates perform:@selector(modelDidEndUpdates:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [_delegates perform: @selector(model:didUpdateObject:atIndexPath:)
             withObject: self
             withObject: object
             withObject: indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [_delegates perform: @selector(model:didInsertObject:atIndexPath:)
             withObject: self
             withObject: object
             withObject: indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [_delegates perform: @selector(model:didDeleteObject:atIndexPath:)
             withObject: self
             withObject: object
             withObject: indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didChange {
    [_delegates perform:@selector(modelDidChange:) withObject:self];
}


@end
