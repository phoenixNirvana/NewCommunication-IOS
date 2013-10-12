//
//  YGlobalNetwork.m
//  yushiyi
//
//  Created by yu shiyi on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YGlobalNetwork.h"
#import "LYUserfulMacros.h"
#import <pthread.h>

static int              gNetworkTaskCount = 0;
static pthread_mutex_t  gMutex = PTHREAD_MUTEX_INITIALIZER;


///////////////////////////////////////////////////////////////////////////////////////////////////
void YNetworkRequestStarted() {
    pthread_mutex_lock(&gMutex);
    
    if (0 == gNetworkTaskCount) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    gNetworkTaskCount++;
    
    pthread_mutex_unlock(&gMutex);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void YNetworkRequestStopped() {
    pthread_mutex_lock(&gMutex);
    
    --gNetworkTaskCount;
    // If this asserts, you don't have enough stop requests to match your start requests.
    //YDASSERT(gNetworkTaskCount >= 0);
    gNetworkTaskCount = MAX(0, gNetworkTaskCount);
    
    if (gNetworkTaskCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    pthread_mutex_unlock(&gMutex);
}