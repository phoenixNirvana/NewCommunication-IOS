//
//  LYNextPageFooterView.m
//  Leyingke
//
//  Created by yu on 12-11-8.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNextPageFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UIView+LYAdditions.h"

#define kBufferHeight 60
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@interface LYNextPageFooterView (){
    UIImageView* _titleLogoView;
}
@property (nonatomic, retain)UIImageView* titleLogoView;
- (void)setState:(EGOPullNextPageState)aState;
@end

@implementation LYNextPageFooterView
@synthesize delegate = _delegate;
@synthesize titleLogoView = _titleLogoView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 10)];
//		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		_statusLabel.font = [UIFont systemFontOfSize:8.0f];
//		_statusLabel.textColor = RGBCOLOR(149, 156, 161);
//		_statusLabel.backgroundColor = [UIColor clearColor];
//		_statusLabel.textAlignment = UITextAlignmentCenter;
//		[self setState:EGOOPullNextPageNormal];
//		[self addSubview:_statusLabel];
//        
//        self.titleLogoView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_title_logo"]] autorelease];
//        [self.titleLogoView setFrame:CGRectMake((frame.size.width-57.5)/2, 15+20, 57.5, 23.5)];
//        [self addSubview:self.titleLogoView];
        
		_arrowImage = [[CALayer alloc] init];
		_arrowImage.frame = CGRectMake((frame.size.width-15)/2, 9.0f, 15.0f, 25.0f);
		_arrowImage.contentsGravity = kCAGravityResizeAspect;
		_arrowImage.contents = (id)[UIImage imageNamed:@"refresh_arrow"].CGImage;
        [[self layer] addSublayer:_arrowImage];
		
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake((frame.size.width-20)/2, 9, 20, 20);
		_activityView.hidesWhenStopped = YES;
		[self addSubview:_activityView];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
	
    //	CGContextRef context = UIGraphicsGetCurrentContext();
    //	CGContextDrawPath(context,  kCGPathFillStroke);
    //	[[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_playline.png"]] setStroke];
    //	CGContextBeginPath(context);
    //	CGContextMoveToPoint(context, 0.0f, 1);
    //	CGContextAddLineToPoint(context, self.bounds.size.width, 1);
    //	CGContextStrokePath(context);
}


- (void)setState:(EGOPullNextPageState)aState{
	switch (aState) {
		case EGOOPullNextPagePulling:
			if (_state == EGOOPullNextPagePulling
				||_state == EGOOPullNextPageLoading) {
				return;
			}
//			_statusLabel.text = NSLocalizedString(@"松开即可加载更多...", @"");
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case EGOOPullNextPageNormal:
			if (_state == EGOOPullNextPageNormal) {
				return;
			}
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
//			_statusLabel.text = NSLocalizedString(@"上拉可以翻页...", @"");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullNextPageLoading:
			if (_state == EGOOPullNextPageLoading
				||_state == EGOOPullNextPageNormal) {
				return;
			}
//			_statusLabel.text = NSLocalizedString(@"加载中...", @"");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		case EGOOPullLastPage:
//			_statusLabel.text = NSLocalizedString(@"没有更多...", @"");
			[_activityView stopAnimating];
			_arrowImage.hidden = YES;
			
			break;
		default:
			break;
	}
	_state = aState;
}
- (void)rrRefreshScrollViewDidScroll:(UIScrollView *)scrollView lastPage:(BOOL)isLastPage{
    //是末页,向上拉
	if (scrollView.isDragging && scrollView.contentOffset.y>=0 && isLastPage) {
		[self setState:EGOOPullLastPage];
		return;
	}
	//不是末页 向上拉
	if (scrollView.isDragging && _state != EGOOPullNextPageLoading) {
		float offset = scrollView.contentSize.height <= scrollView.frame.size.height ?
        scrollView.contentOffset.y : scrollView.contentOffset.y - (scrollView.contentSize.height-scrollView.frame.size.height);
		[self setState:offset >= kBufferHeight ? EGOOPullNextPagePulling : EGOOPullNextPageNormal];
	}
}
- (void)rrRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView lastPage:(BOOL)isLastPage{
    // 末页，不加载
    if (scrollView.contentOffset.y>=0 && isLastPage) {
		[self setState:EGOOPullLastPage];
		return;
	}
    // 不是末页，加载
    if((scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height +kBufferHeight)
       && _state == EGOOPullNextPagePulling){
		[self setState:EGOOPullNextPageLoading];
        [UIView animateWithDuration:.2
                         animations:^{
                             scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
                         }
                         completion:^(BOOL finished) {
                             if ([_delegate respondsToSelector:@selector(rrRefreshNextPageFooterDidTriggerRefresh:)]) {
                                 [_delegate rrRefreshNextPageFooterDidTriggerRefresh:self];
                             }
                         }];
		return;
	}
}
- (void)rrRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
	self.frame = CGRectMake(0,  MAX(scrollView.contentSize.height, scrollView.height)
                            , scrollView.contentSize.width, 200);
    [self.titleLogoView setFrame:CGRectMake((self.frame.size.width-57.5)/2, 15+20, 57.5, 23.5)];
	[self setState:EGOOPullNextPageNormal];
	scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}
- (void)dealloc {
	[_activityView release];
	[_statusLabel release];
	[_arrowImage release];
    [_titleLogoView release];
    [super dealloc];
}
@end
