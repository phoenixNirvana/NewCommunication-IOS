//
//  LYNavigationTableViewController.m
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavigationTableViewController.h"
#import "YModel.h"
#import "YURLRequestModel.h"


@interface LYNavigationTableViewController ()

@end

@implementation LYNavigationTableViewController
@synthesize tableView = _tableView;
@synthesize refreshTableHeaderView = _refreshTableHeaderView;
@synthesize nextPageFooterView = _nextPageFooterView;
@synthesize dragToRefresh = _dragToRefresh;

- (void)dealloc {
    self.tableView = nil;
    self.refreshTableHeaderView.delegate = nil;
    self.refreshTableHeaderView = nil;
    self.nextPageFooterView.delegate = nil;
    self.nextPageFooterView = nil;
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dragToRefresh = YES;
        _loadMoreEnable = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect rect = CGRectMake(0, CONTENT_NAVIGATIONBAR_HEIGHT, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height - CONTENT_NAVIGATIONBAR_HEIGHT-BOTTOM_NAVIGATIONBAR_HEIGHT);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [tableView release];
    
    if (_refreshTableHeaderView == nil) {
        LYRefreshTableHeaderView *view = [[LYRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, PHONE_SCREEN_SIZE.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        self.refreshTableHeaderView = view;
        [view release];
    }
    
    if (_nextPageFooterView == nil) {
        _nextPageFooterView = [[LYNextPageFooterView alloc] initWithFrame:CGRectMake(0,0.0f - self.tableView.bounds.size.height,PHONE_SCREEN_SIZE.width, self.tableView.bounds.size.height)];
        _nextPageFooterView.delegate = self;
    }
    
    if(_dragToRefresh){
        [self.refreshTableHeaderView refreshLastUpdatedDate];
        [self.tableView addSubview:self.refreshTableHeaderView];
    }
    if(_loadMoreEnable){
        [self.tableView addSubview:self.nextPageFooterView];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    LY_NSLog(@"yushiyiyushiyi scrollViewDidEndDecelerating");
    if(!_loadMoreEnable)
        return;
    
    if ([self.model isLoading]) {
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	LY_NSLog(@"yushiyiyushiyi scrollViewDidScroll");
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDidScroll:scrollView];
    }
    if(_loadMoreEnable){
        if (self.model && [self.model isKindOfClass:[YURLRequestModel class]]) {
            [_nextPageFooterView rrRefreshScrollViewDidScroll:scrollView lastPage:((YURLRequestModel*)self.model).hasNoMore];
        }else{
            [_nextPageFooterView rrRefreshScrollViewDidScroll:scrollView lastPage:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    LY_NSLog(@"yushiyiyushiyi scrollViewDidEndDragging");
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDidEndDragging:scrollView];
    }
    if(_loadMoreEnable){
        if (self.model && [self.model isKindOfClass:[YURLRequestModel class]]) {
            [_nextPageFooterView rrRefreshScrollViewDidEndDragging:scrollView lastPage:((YURLRequestModel*)self.model).hasNoMore];
        }else{
            [_nextPageFooterView rrRefreshScrollViewDidEndDragging:scrollView lastPage:NO];
        }
    }
	
}

#pragma mark - RRNextPageFooterDelegate
- (void)rrRefreshNextPageFooterDidTriggerRefresh:(LYNextPageFooterView *)view{
    [self.model load:YURLRequestCachePolicyDefault more:YES];
}

#pragma mark -  RefreshTableHeaderView
- (void)refreshTableHeaderDidTriggerRefresh:(LYRefreshTableHeaderView*)view{
    if (!_dragToRefresh) {
        return;
    }
//    [_model load:YURLRequestCachePolicyDefault more:NO];
    [(YURLRequestModel*)(self.model) refreshData:YURLRequestCachePolicyNetwork];
    
}
- (BOOL)refreshTableHeaderDataSourceIsLoading:(LYRefreshTableHeaderView*)view{
    return NO;
}

- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(LYRefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

//- (UIScrollView *)refreshTableHeaderDataSourceCanceled:(LYRefreshTableHeaderView*)view
//{
//    
//}

#pragma mark - RNModelDelegate
// 完成
- (void)modelDidFinishLoad:(id<YModel>)model {
    // 子类实现
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    if(_loadMoreEnable){
        [_nextPageFooterView rrRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    [super modelDidFinishLoad:model];
}

- (void)modelDidFinishLoad304:(id<YModel>)model {
    // 子类实现
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    if(_loadMoreEnable){
        [_nextPageFooterView rrRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    [super modelDidFinishLoad304:model];
}

// 错误处理
- (void)model:(id<YModel>)model didFailLoadWithError:(NSError*)error {
    // 子类实现
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    if(_loadMoreEnable){
        [_nextPageFooterView rrRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    [super model:model didFailLoadWithError:error];
}

// 取消
- (void)modelDidCancelLoad:(id<YModel>)model {
    // 子类实现
    if (_dragToRefresh) {
        [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    if(_loadMoreEnable){
        [_nextPageFooterView rrRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    [super modelDidCancelLoad:model];
}


@end
