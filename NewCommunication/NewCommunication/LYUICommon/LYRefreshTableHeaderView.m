//
//  RRRefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LYRefreshTableHeaderView.h"


#define FLIP_ANIMATION_DURATION 0.18f
#define kShowCancelTimerInterval 8


@interface LYRefreshTableHeaderView (Private)

@end

@implementation LYRefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
//        UIImageView* logoView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_title_logo"]] autorelease];
//        [logoView setFrame:CGRectMake((self.frame.size.width-57.5)/2, frame.size.height-35-23.5, 57.5, 23.5)];
//        [self addSubview:logoView];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 10.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label.textColor = [UIColor grayColor];
//        label.font = [UIFont systemFontOfSize:8];
//		label.textAlignment = UITextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//		[self addSubview:label];
//		_statusLabel=label;
//		[label release];
//		
//        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 10.0f-5, self.frame.size.width, 10.0f)];
//		label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label1.textColor = [UIColor grayColor];
//        label1.font = [UIFont systemFontOfSize:8];
//        label1.textAlignment = UITextAlignmentCenter;
//        label1.backgroundColor = [UIColor clearColor];
//		[self addSubview:label1];
//		_lastUpdatedLabel=label1;
//		[label1 release];
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake((frame.size.width-15)/2, frame.size.height - 30.0f, 15.0f, 25.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refresh_arrow"].CGImage;
        layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;

		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake((frame.size.width-20)/2, frame.size.height - 30.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
        
		[self setState:LYPullRefreshNormal];
    }
	
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {
		
//		NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//
//		_lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最后更新: %@", @"最后更新: %@"), [dateFormatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RRRefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
//		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(LYPullRefreshState)aState{
	switch (aState) {
		case LYPullRefreshPulling:
//			_statusLabel.text = NSLocalizedString(@"松开即可更新...", @"松开即可更新...");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case LYPullRefreshNormal:
			if (_state == LYPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"下拉更新数据...", @"下拉更新数据...");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case LYPullRefreshLoading:
			
//			_statusLabel.text = NSLocalizedString(@"正在更新数据...", @"正在更新数据...");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];

			break;
		default:
			break;
	}
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == LYPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == LYPullRefreshPulling && scrollView.contentOffset.y > -kHeaderActiveHeight && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:LYPullRefreshNormal];
		} else if (_state == LYPullRefreshNormal && scrollView.contentOffset.y < -kHeaderActiveHeight && !_loading) {
			[self setState:LYPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - kHeaderActiveHeight && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate refreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self refreshScrollViewDataSourceBegain:scrollView];
	}
}

-(void)refreshScrollViewDataSourceBegain:(UIScrollView *)scrollView{
    [self setState:LYPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:LYPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end
