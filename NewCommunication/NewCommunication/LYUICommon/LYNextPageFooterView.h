//
//  LYNextPageFooterView.h
//  Leyingke
//
//  Created by yu on 12-11-8.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYBaseView.h"

typedef enum{
	EGOOPullNextPagePulling = 0,
	EGOOPullNextPageNormal,
	EGOOPullNextPageLoading,
	EGOOPullLastPage,
} EGOPullNextPageState;

@protocol LYNextPageFooterDelegate;

@interface LYNextPageFooterView : LYBaseView{
    id _delegate;
    EGOPullNextPageState _state;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
@property(nonatomic,assign) id <LYNextPageFooterDelegate> delegate;

- (void)rrRefreshScrollViewDidScroll:(UIScrollView *)scrollView lastPage:(BOOL)isLastPage;
- (void)rrRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView lastPage:(BOOL)isLastPage;
- (void)rrRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol LYNextPageFooterDelegate
- (void)rrRefreshNextPageFooterDidTriggerRefresh:(LYNextPageFooterView *)view;
@end
