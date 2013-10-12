//
//  LYSideRefreshHeaderView.m
//  Leyingke
//
//  Created by apple on 13-3-28.
//  Copyright (c) 2013年 leyingke.com. All rights reserved.
//

#import "LYSideRefreshHeaderView.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define kShowCancelTimerInterval 8

@implementation LYSideRefreshHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
//        UIImageView* logoView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_title_logo"]] autorelease];
//        [logoView setFrame:CGRectMake((self.frame.size.width-57.5)/2, frame.size.height-35-23.5, 57.5, 23.5)];
//        [self addSubview:logoView];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-100-10, frame.size.height/2+25, 100, 8.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label.textColor = [UIColor grayColor];
//        label.font = [UIFont systemFontOfSize:8];
//		label.textAlignment = UITextAlignmentRight;
//        label.backgroundColor = [UIColor clearColor];
//		[self addSubview:label];
//		_statusLabel=label;
//		[label release];
//		
//        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-100-10, label.origin.y+label.height+5, 100, 8.0f)];
//		label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label1.textColor = [UIColor grayColor];
//        label1.font = [UIFont systemFontOfSize:8];
//        label1.textAlignment = UITextAlignmentRight;
//        label1.backgroundColor = [UIColor clearColor];
//		[self addSubview:label1];
//		_lastUpdatedLabel=label1;
//		[label1 release];
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(frame.size.width-25-10, frame.size.height/2, 15.0f, 25.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refresh_arrow"].CGImage;
        layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(frame.size.width-20-10, frame.size.height/2, 20.0f, 20.0f);
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
//		_lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@", @"%@"), [dateFormatter stringFromDate:date]];
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
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 270.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case LYPullRefreshNormal:
			if (_state == LYPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"右拉更新数据...", @"右拉更新数据...");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
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
		
		CGFloat offset = MAX(scrollView.contentOffset.x * -1, 0);
		offset = MIN(60, offset);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f,offset, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == LYPullRefreshPulling && scrollView.contentOffset.x > -kHeaderActiveHeight && scrollView.contentOffset.x < 0.0f && !_loading) {
			[self setState:LYPullRefreshNormal];
		} else if (_state == LYPullRefreshNormal && scrollView.contentOffset.x < -kHeaderActiveHeight && !_loading) {
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
	
	if (scrollView.contentOffset.x <= - kHeaderActiveHeight && !_loading) {
		
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
