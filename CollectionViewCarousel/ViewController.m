//
//  ViewController.m
//  CollectionViewCarousel
//
//  Created by Steve Smith on 4/18/16.
//  Copyright © 2016 Steve Smith. All rights reserved.
//

#import "ViewController.h"
#import "CustomFlowLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *viewData;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) CGFloat lastScrollViewOffset;
@property (nonatomic, assign) NSUInteger currentIdxItem;

@property (weak, nonatomic) IBOutlet UICollectionView *cvCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _viewData = [[NSMutableArray alloc] init];
    
//    _data = @[@"1", @"2", @"3", @"4"];
    _data = @[@"1", @"2", @"3", @"4", @"5", @"6"];
//    _data = @[@"1", @"2", @"3"];
//    _data = @[@"1", @"2"];
    
    CustomFlowLayout *layout = [CustomFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:12.0];
    [_cvCollectionView setCollectionViewLayout:layout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_viewData removeAllObjects];
    
//    for (NSString *item in _data){
//        [_viewData addObject:item];
//    }
    
//    [_viewData addObject:[_data firstObject]];
//    [_viewData insertObject:[_data lastObject] atIndex:0];
    
    [_viewData addObjectsFromArray:_data];
    if (_data.count >= 3){
        [_viewData addObjectsFromArray:_data];
//        [_viewData insertObject:[_data lastObject] atIndex:0];
//        [_viewData insertObject:[_data objectAtIndex:(_data.count - 1)] atIndex:0];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat height = CGRectGetHeight(self.cvCollectionView.frame);
    CGFloat newWidth = height;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[_cvCollectionView collectionViewLayout];
    [layout setItemSize:CGSizeMake(newWidth, height)];
    
    NSUInteger firstItem = _data.count >= 3 ? [_data count] : 0;
    [_cvCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:firstItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    _lastScrollViewOffset = [_cvCollectionView contentOffset].x;
    _currentIdxItem = firstItem;
}

#pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_viewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    NSString *item = [_viewData objectAtIndex:indexPath.item];
    UILabel *label = [cell viewWithTag:10];
    [label setText:item];
    
    return cell;
}

#pragma mark - ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastScrollViewOffset = scrollView.contentOffset.x;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastScrollViewOffset < scrollView.contentOffset.x) {
        // moved right
        NSUInteger movingToIdx = _currentIdxItem + 1;
        if (movingToIdx == [_viewData count] - 2){
            id shadowData = [_viewData objectAtIndex:movingToIdx];
            NSUInteger newIdx = [_viewData indexOfObject:shadowData];
            [_cvCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            _currentIdxItem = newIdx;
        }else{
            _currentIdxItem += 1;
        }
    } else if (self.lastScrollViewOffset > scrollView.contentOffset.x) {
        // moved left
        NSUInteger movingToIdx = _currentIdxItem - 1;
        if (movingToIdx == 1){
//            id shadowData = [_viewData objectAtIndex:_data.count + movingToIdx];
            NSUInteger newIdx = _data.count + movingToIdx;
            [_cvCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            _currentIdxItem = newIdx;
        }else{
            _currentIdxItem -= 1;
        }
    } else {
        // didn't move
    }
}

@end
