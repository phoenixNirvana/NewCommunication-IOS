//
//  LYModelViewController.m
//  Leyingke
//
//  Created by yu on 12-9-19.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYModelViewController.h"
#import "YModel.h"
#import "LYUserfulMacros.h"
#import "LYAppDelegate.h"
#import "MBProgressHUD.h"
#import "UIView+LYAdditions.h"

@interface LYModelViewController (){
    UILabel* _emptyLabel;
}
@property (nonatomic, retain)UILabel* emptyLabel;

@end

@implementation LYModelViewController

@synthesize model       = _model;
@synthesize modelError  = _modelError;
@synthesize isDelayed;
@synthesize emptyLabel = _emptyLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _flags.isViewInvalid = YES;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithNibName:nil bundle:nil];
    if (self) {
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [_model.delegates removeObject:self];
    LY_RELEASE_SAFELY(_model);
    LY_RELEASE_SAFELY(_modelError);
    LY_RELEASE_SAFELY(_emptyLabel);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resetViewStates {
    if (_flags.isShowingLoading) {
        [self showLoading:NO];
        _flags.isShowingLoading = NO;
    }
    if (_flags.isShowingModel) {
        [self showModel:NO];
        _flags.isShowingModel = NO;
    }
    if (_flags.isShowingError) {
        [self showError:NO];
        _flags.isShowingError = NO;
    }
    if (_flags.isShowingEmpty) {
        [self showEmpty:NO];
        _flags.isShowingEmpty = NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewStates {
    if (_flags.isModelDidRefreshInvalid) {
        [self didRefreshModel];
        _flags.isModelDidRefreshInvalid = NO;
    }
    if (_flags.isModelWillLoadInvalid) {
        [self willLoadModel];
        _flags.isModelWillLoadInvalid = NO;
    }
    if (_flags.isModelDidLoadInvalid) {
        [self didLoadModel:_flags.isModelDidLoadFirstTimeInvalid];
        _flags.isModelDidLoadInvalid = NO;
        _flags.isModelDidLoadFirstTimeInvalid = NO;
        _flags.isShowingModel = NO;
    }
    
    BOOL showModel = NO, showLoading = NO, showError = NO, showEmpty = NO;
    
    if (_model.isLoaded || ![self shouldLoad]) {
        if ([self canShowModel]) {
            showModel = !_flags.isShowingModel;
            _flags.isShowingModel = YES;
            
        } else {
            if (_flags.isShowingModel) {
                [self showModel:NO];
                _flags.isShowingModel = NO;
            }
        }
        
    } else {
        if (_flags.isShowingModel) {
            [self showModel:NO];
            _flags.isShowingModel = NO;
        }
    }
    
    if (_model.isLoading) {
        showLoading = !_flags.isShowingLoading;
        _flags.isShowingLoading = YES;
        
    } else {
        if (_flags.isShowingLoading) {
            [self showLoading:NO];
            _flags.isShowingLoading = NO;
        }
    }
    
    if (_modelError) {
        showError = !_flags.isShowingError;
        _flags.isShowingError = YES;
        
    } else {
        if (_flags.isShowingError) {
            [self showError:NO];
            _flags.isShowingError = NO;
        }
    }
    
    if (!_flags.isShowingLoading && !_flags.isShowingModel && !_flags.isShowingError) {
        showEmpty = !_flags.isShowingEmpty;
        _flags.isShowingEmpty = YES;
        
    } else {
        if (_flags.isShowingEmpty) {
            [self showEmpty:NO];
            _flags.isShowingEmpty = NO;
        }
    }
    
    if (showModel) {
        [self showModel:YES];
        [self didShowModel:_flags.isModelDidShowFirstTimeInvalid];
        _flags.isModelDidShowFirstTimeInvalid = NO;
    }
    if (showEmpty) {
        [self showEmpty:YES];
    }
    if (showError) {
        [self showError:YES];
    }
    if (showLoading) {
        [self showLoading:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createInterstitialModel {
    self.model = [[[YModel alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    _isViewAppearing = YES;
    _hasViewAppeared = YES;
    
    [self updateView];
    
    [super viewWillAppear:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    if (_hasViewAppeared && !_isViewAppearing) {
        [super didReceiveMemoryWarning];
        [self resetViewStates];
        [self refresh];
        
    } else {
        [super didReceiveMemoryWarning];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)delayDidEnd {
    self.isDelayed = NO;
    [self invalidateModel];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidStartLoad:(id<YModel>)model {
    if (model == self.model) {
        _flags.isModelWillLoadInvalid = YES;
        _flags.isModelDidLoadFirstTimeInvalid = YES;
        [self invalidateView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidFinishLoad:(id<YModel>)model {
    if (model == _model) {
        LY_RELEASE_SAFELY(_modelError);
        _flags.isModelDidLoadInvalid = YES;
        [self invalidateView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidFinishLoad304:(id<YModel>)model {
    if (model == _model) {
        LY_RELEASE_SAFELY(_modelError);
        _flags.isModelDidLoadInvalid = YES;
        [self invalidateView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)model:(id<YModel>)model didFailLoadWithError:(NSError*)error {
    if (model == _model) {
        self.modelError = error;
        self.modelError = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidCancelLoad:(id<YModel>)model {
    if (model == _model) {
        [self invalidateView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidChange:(id<YModel>)model {
    if (model == _model) {
        [self refresh];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)model:(id<YModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)model:(id<YModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)model:(id<YModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidBeginUpdates:(id<YModel>)model {
    if (model == _model) {
        [self beginUpdates];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)modelDidEndUpdates:(id<YModel>)model {
    if (model == _model) {
        [self endUpdates];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<YModel>)model {
    if (!_model) {
        if (!self.isDelayed) {
            [self createModel];
        }
        
        if (!_model) {
            [self createInterstitialModel];
        }
    }
    return _model;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setModel:(id<YModel>)model {
    if (_model != model) {
        [_model.delegates removeObject:self];
        [_model release];
        _model = [model retain];
        [_model.delegates addObject:self];
        LY_RELEASE_SAFELY(_modelError);
        
        if (_model) {
            _flags.isModelWillLoadInvalid = NO;
            _flags.isModelDidLoadInvalid = NO;
            _flags.isModelDidLoadFirstTimeInvalid = NO;
            _flags.isModelDidShowFirstTimeInvalid = YES;
        }
        
        [self refresh];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setModelError:(NSError*)error {
    if (error != _modelError) {
        [_modelError release];
        _modelError = [error retain];
        
        [self invalidateView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateModel {
    BOOL wasModelCreated = self.isModelCreated;
    [self resetViewStates];
    [_model.delegates removeObject:self];
    LY_RELEASE_SAFELY(_model);
    if (wasModelCreated) {
        [self model];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isModelCreated {
    return !!_model;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoad {
    return !self.model.isLoaded;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldReload {
    return !_modelError && self.model.isOutdated;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoadMore {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canShowModel {
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
    _flags.isViewInvalid = YES;
    [self.model load:YURLRequestCachePolicyNetwork more:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadIfNeeded {
    if ([self shouldReload] && !self.model.isLoading) {
        [self reload];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)refresh {
    _flags.isViewInvalid = YES;
    _flags.isModelDidRefreshInvalid = YES;
    
    BOOL loading = self.model.isLoading;
    BOOL loaded = self.model.isLoaded;
    if (!loading && !loaded && [self shouldLoad]) {
        [self.model load:YURLRequestCachePolicyDefault more:NO];
        
    } else if (!loading && loaded && [self shouldReload]) {
        [self.model load:YURLRequestCachePolicyNetwork more:NO];
        
    } else if (!loading && [self shouldLoadMore]) {
        [self.model load:YURLRequestCachePolicyDefault more:YES];
        
    } else {
        _flags.isModelDidLoadInvalid = YES;
        if (_isViewAppearing) {
            [self updateView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginUpdates {
    _flags.isViewSuspended = YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endUpdates {
    _flags.isViewSuspended = NO;
    [self updateView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateView {
    _flags.isViewInvalid = YES;
    if (_isViewAppearing) {
        [self updateView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateView {
    if (_flags.isViewInvalid && !_flags.isViewSuspended && !_flags.isUpdatingView) {
        _flags.isUpdatingView = YES;
        
        // Ensure the model is created
        [self model];
        // Ensure the view is created
        [self view];
        
        [self updateViewStates];
        
//        if (_frozenState && _flags.isShowingModel) {
//            [self restoreView:_frozenState];
//            LY_RELEASE_SAFELY(_frozenState);
//        }
        
        _flags.isViewInvalid = NO;
        _flags.isUpdatingView = NO;
        
        [self reloadIfNeeded];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRefreshModel {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willLoadModel {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLoadModel:(BOOL)firstTime {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didShowModel:(BOOL)firstTime {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showModel:(BOOL)show {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty{
    return @"暂无数据！";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show {
    if(show){
        if(!self.emptyLabel){
            self.emptyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.height-30)/2, self.view.width, 30)] autorelease];
            self.emptyLabel.backgroundColor = [UIColor clearColor];
            self.emptyLabel.text = [self titleForEmpty];
            self.emptyLabel.textColor = [UIColor grayColor];
            self.emptyLabel.textAlignment = UITextAlignmentCenter;
            self.emptyLabel.font = [UIFont systemFontOfSize:12];
            [self.view addSubview:self.emptyLabel];
        }
        else{
            self.emptyLabel.hidden = NO;
        }
    }
    else{
        if(self.emptyLabel){
            self.emptyLabel.hidden = YES;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show {
    if (show) {
                LYAppDelegate* delegate = (LYAppDelegate*)[UIApplication sharedApplication].delegate;
                UIWindow* window = delegate.window;
        
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
        NSString* errtext = nil;
        if (_modelError.code == 100) {
            errtext = _modelError.domain;
        }else{
            errtext = [_modelError localizedDescription];
        }
                hud.labelText = [NSString stringWithFormat:@"%@",errtext];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
        
               [hud hide:YES afterDelay:1.5];
       // _flags.isShowingError = NO;
    }
}
@end
