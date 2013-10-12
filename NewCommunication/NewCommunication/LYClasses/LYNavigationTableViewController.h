//
//  LYNavigationTableViewController.h
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYNavModeViewController.h"
#import "LYRefreshTableHeaderView.h"
#import "LYNextPageFooterView.h"

@interface LYNavigationTableViewController : LYNavModeViewController<UITableViewDelegate, UITableViewDataSource,LYRefreshTableHeaderDelegate,LYNextPageFooterDelegate>{
    UITableView *_tableView;
    LYRefreshTableHeaderView* _refreshTableHeaderView;
    LYNextPageFooterView* _nextPageFooterView;
    BOOL _dragToRefresh;
    BOOL _loadMoreEnable;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain)LYRefreshTableHeaderView* refreshTableHeaderView;
@property (nonatomic, retain)LYNextPageFooterView* nextPageFooterView;
@property (nonatomic, assign)BOOL dragToRefresh;

@end
