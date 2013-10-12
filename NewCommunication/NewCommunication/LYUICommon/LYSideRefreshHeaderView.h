//
//  LYSideRefreshHeaderView.h
//  Leyingke
//
//  Created by apple on 13-3-28.
//  Copyright (c) 2013年 leyingke.com. All rights reserved.
//

#import "LYBaseView.h"
#import <QuartzCore/QuartzCore.h>
#import "LYBaseView.h"
#import "LYRefreshType.h"
#define kHeaderActiveHeight 65.0
#define kRefreshHeight 340.0

@protocol LYSideRefreshHeaderDelegate;
@interface LYSideRefreshHeaderView : LYBaseView{
	id _delegate;
	LYPullRefreshState _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
@property(nonatomic,assign) id <LYSideRefreshHeaderDelegate> delegate;

- (void)setState:(LYPullRefreshState)aState;
- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceBegain:(UIScrollView *)scrollView;

@end
@protocol LYSideRefreshHeaderDelegate
- (void)refreshTableHeaderDidTriggerRefresh:(LYSideRefreshHeaderView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(LYSideRefreshHeaderView*)view;
//- (UIScrollView *)refreshTableHeaderDataSourceCanceled:(LYRefreshTableHeaderView*)view;
@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(LYSideRefreshHeaderView*)view;

@end
