//
//  ViewController2.m
//  CollectionViewCarousel
//
//  Created by Steve Smith on 4/18/16.
//  Copyright © 2016 Steve Smith. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewData;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) CGFloat lastScrollViewOffset;
@property (nonatomic, assign) NSUInteger currentPage;

@property (weak, nonatomic) IBOutlet UIScrollView *svScrollView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_svScrollView setDelegate:self];
    
    _viewData = [[NSMutableArray alloc] init];
    _views = [[NSMutableArray alloc] init];
    _data = @[@"1", @"2", @"3", @"4"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_viewData removeAllObjects];
    
//    for (NSString *item in _data){
//        [_viewData addObject:item];
//    }
//    
//    [_viewData addObject:[_data firstObject]];
//    [_viewData insertObject:[_data lastObject] atIndex:0];
    
    [_viewData addObjectsFromArray:_data];
    if ([_data count] >= 3){
        [_viewData addObjectsFromArray:_data];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUInteger firstItem = _data.count;
    _currentPage = firstItem;
    UIView *theView = [_views objectAtIndex:firstItem];
    [_svScrollView scrollRectToVisible:theView.frame animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self loadViews];
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastScrollViewOffset = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastScrollViewOffset < scrollView.contentOffset.x) {
        // moved right
        if (_currentPage == [_viewData count] - 2){
            id currentObj = [_viewData objectAtIndex:_currentPage];
            NSUInteger idx = [_viewData indexOfObject:currentObj];
            UIView *shadowView = [_views objectAtIndex:idx];
            [_svScrollView scrollRectToVisible:shadowView.frame animated:NO];
            _currentPage = idx;
        }else{
            _currentPage += 1;
        }
    } else if (self.lastScrollViewOffset > scrollView.contentOffset.x) {
        // moved left
        if (_currentPage == 2){
            UIView *shadowView = [_views objectAtIndex:(_views.count - _currentPage)];
            [_svScrollView scrollRectToVisible:shadowView.frame animated:NO];
            _currentPage = _views.count - _currentPage;
        }else{
            _currentPage -= 1;
        }
    } else {
        // didn't move
    }
}


#pragma mark - Private

- (void)loadViews {
    [_views removeAllObjects];
    CGRect frame = CGRectMake(0, 0, _svScrollView.frame.size.width, _svScrollView.frame.size.height);
    NSUInteger padding = 12.0;
    for (int i = 0; i < _viewData.count; i++){
        NSString *text = [_viewData objectAtIndex:i];
        UIView *view = [self viewWithFrame:frame andMessage:text];
        [_svScrollView addSubview:view];
        frame.origin.x = frame.origin.x + frame.size.width + padding;
        [_views addObject:view];
    }
    _svScrollView.contentSize = CGSizeMake(_viewData.count * frame.size.width + (2*padding), _svScrollView.frame.size.height);
}

- (UIView *)viewWithFrame:(CGRect)frame andMessage:(NSString *)message {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    [label setText:message];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [view addSubview:label];
    return view;
}

@end
