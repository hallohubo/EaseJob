//
//  NJPhotoBrowserVC.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserVC.h"
#import "NJPhotoBrowserCell.h"
#import "NJPhotoBrowserItem.h"
#import "NJPhotoBrowserScrollView.h"
#import "HD3DScrollView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ImageInteritemSpace 10.0f
@interface NJPhotoBrowserVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CAAnimationDelegate>
/********* collectionView *********/
@property(nonatomic,weak)HD3DScrollView * collectionView;

/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NJPhotoBrowserItem *> * photoDataArr;
/********* 双击 *********/
@property(nonatomic,strong)UITapGestureRecognizer * doubleTapGestureRecognizer;

/********* 单击 *********/
@property(nonatomic,strong)UITapGestureRecognizer * singleTapGestureRecognizer;

/********* 长按手势 *********/
@property(nonatomic,strong)UILongPressGestureRecognizer * longGestureRecognizer;

/********* 过渡前，记录图片的中心点（占位图片的中心点） *********/
@property(nonatomic,assign)CGPoint transitionImgViewCenter;
/********* 过渡的占位图片 *********/
@property(nonatomic,strong)UIImageView * imgView;
/********* 是否是dimiss手势，用于解决导航条问题 *********/
@property(nonatomic,assign)BOOL isPopGesture;

@end

@implementation NJPhotoBrowserVC
static NSString * const ID = @"NJPhotoBrowserCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInit];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO
//                                             animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(!self.isPopGesture)
    {
        [self.navigationController setNavigationBarHidden:NO
                                                 animated:YES];
        return;
    }
    
//    [self.navigationController setNavigationBarHidden:NO
//                                             animated:YES];
}
    



#pragma mark - 设置初始化
- (void)setupInit
{
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    self.isPopGesture = NO;
    [self setupCollectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addGestureRecognizer:self.singleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.swipeUpGestureRecognizer];
    [self.view addGestureRecognizer:self.swipeDownGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
//    [self.view addGestureRecognizer:self.longGestureRecognizer];
    
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.swipeUpGestureRecognizer];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.panGestureRecognizer];
//    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.longGestureRecognizer];
    [self.panGestureRecognizer requireGestureRecognizerToFail:self.swipeUpGestureRecognizer];
//    [self.panGestureRecognizer requireGestureRecognizerToFail:self.swipeDownGestureRecognizer];
//    [self.swipeUpGestureRecognizer requireGestureRecognizerToFail:self.longGestureRecognizer];
//    [self.panGestureRecognizer requireGestureRecognizerToFail:self.longGestureRecognizer];
    
    
    [self scrollToStartPageAnimated:NO];
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
////    if (self.bottomView.btn_fold.selected) {
////        return NO;
////    }
//    return NO;
//}
#pragma mark - collectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    HD3DScrollView * collectionView = [[HD3DScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth + ImageInteritemSpace, ScreenHeight) collectionViewLayout:flowLayout];
    collectionView.effect = HD3DScrollViewEffectTranslation;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [collectionView registerClass:[NJPhotoBrowserCell class] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionViewDataSource方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDWeakSelf;
    NJPhotoBrowserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NJPhotoBrowserItem * item = self.photoDataArr[indexPath.row];
    cell.item = item;
//    cell.didEndDownDraggingBlock = ^{
////        [weakSelf didEndDownDragging];
//    };
//    cell.didEndUpSwipingBlock = ^{
////        [weakSelf didEndUpDraggin];
//    };
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.view.frame.size.width + ImageInteritemSpace, self.view.frame.size.height);
    return size;
}

#pragma mark - UIScrollViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = [self currentCellIndex];
    _currentPage = currentIndex;
    
    if(!self.delegate)
    {
        return;
    }
    if([self.delegate conformsToProtocol:@protocol(NJPhotoBrowserDelegate)])
    {
        if([self.delegate respondsToSelector:@selector(viewController:didEndDecelerating:)])
        {
            [self.delegate viewController:self didEndDecelerating:currentIndex];
        }
    }
}

#pragma mark - 事件&&手势
- (void)handleDoubleTapAction:(UITapGestureRecognizer *)sender
{
    if(sender.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
//    CGPoint location = [sender locationInView:self.view];
//    NJPhotoBrowserScrollView * scrollView = [self currentCell].contentScrollView;
//
//    [scrollView handelZoomForLocation:location];
    if(!self.delegate){
        return;
    }
    if([self.delegate conformsToProtocol:@protocol(NJPhotoBrowserDelegate)]){
        if([self.delegate respondsToSelector:@selector(viewController:didDoubleTapedAtIndex:)]){
            [self.delegate viewController:self didDoubleTapedAtIndex:[self currentCellIndex]];
        }
    }
}

- (void)handleSingleTapAction:(UITapGestureRecognizer *)sender
{
    if(sender.state != UIGestureRecognizerStateEnded){
        return;
    }
    if(!self.delegate){
        return;
    }
    if([self.delegate conformsToProtocol:@protocol(NJPhotoBrowserDelegate)]){
        if([self.delegate respondsToSelector:@selector(viewController:didSingleTapedAtIndex:)]){
            [self.delegate viewController:self didSingleTapedAtIndex:[self currentCellIndex]];
        }
    }
}

- (void)handleSwipeUpAction:(UISwipeGestureRecognizer *)gesture
{
    [self didEndUpSwiping];
    
}

- (void)handleSwipeDownAction:(UISwipeGestureRecognizer *)gesture
{
    [self didEndDownSwiping];
    
}

- (void)handlePanAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    HDLog(@"%s---", __func__);
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGFloat scale = 1 - (translation.y / HDScreenH);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            HDLog(@"拖拽手势开始");
            if([self.delegate respondsToSelector:@selector(viewController:isPop:)])
            {
                [self.delegate viewController:self isPop:YES];
            }
            self.isPopGesture = YES;
            [self setupBaseViewControllerProperty:[self currentCellIndex]];
            self.collectionView.hidden = YES;
            self.imgView.hidden = NO;
        self.animatedTransition.transitionParameter.gestureRecognizer = gestureRecognizer;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            HDLog(@"拖拽手势改变");
            _imgView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
            _imgView.transform = CGAffineTransformMakeScale(scale, scale);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            HDLog(@"拖拽手势结束");
            if(scale > 0.95f){
                [UIView animateWithDuration:0.2 animations:^{
                    self.imgView.center = self.transitionImgViewCenter;
                    self.imgView.transform = CGAffineTransformMakeScale(1, 1);
                    
                } completion:^(BOOL finished) {
                    self.imgView.transform = CGAffineTransformIdentity;
                }];
                HDLog(@"取消过场");
                self.isPopGesture = NO;
                if([self.delegate respondsToSelector:@selector(viewController:isPop:)])
                {
                    [self.delegate viewController:self isPop:NO];
                }
                self.collectionView.hidden = NO;
                self.imgView.hidden = YES;
                
            }else{
                
            }
            self.animatedTransition.transitionParameter.transitionImage = _imgView.image;
            self.animatedTransition.transitionParameter.currentPanGestImgFrame = _imgView.frame;
            self.animatedTransition.transitionParameter.gestureRecognizer = nil;
        }
            break;
            
        default:
            break;
    }
}

- (void)handleLongPressAction:(UILongPressGestureRecognizer *)sender
{
    HDLog(@"长按手势");
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(viewController:didLongPress:)])
    {
        [self.delegate viewController:self didLongPress:[self currentCellIndex]];
    }
}

#pragma mark - 懒加载 && setter
//- (NSArray<NSString *> *)imageUrlArr
//{
//    if(_imageUrlArr == nil)
//    {
//        NSMutableArray *originalImageUrls = [NSMutableArray array];
//        // 添加图片(原图)链接
//        [originalImageUrls addObject:@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
//        [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
//        [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
//        [originalImageUrls addObject:@"http://ww4.sinaimg.cn/large/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
//        [originalImageUrls addObject:@"http://ww2.sinaimg.cn/large/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
//        [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
//        [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
//        [originalImageUrls addObject:@"http://ww4.sinaimg.cn/bmiddle/406ef017jw1ec40av2nscj20ip4p0b29.jpg"];
//        [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
//        _imageUrlArr = [NSArray arrayWithArray:originalImageUrls];
//    }
//    return _imageUrlArr;
//}

- (NSArray<NJPhotoBrowserItem *> *)photoDataArr
{
    if(_photoDataArr == nil)
    {
        NSMutableArray * photoDataArrM = [NSMutableArray array];
        [self.imageUrlArr enumerateObjectsUsingBlock:^(NSString * _Nonnull imageURL, NSUInteger idx, BOOL * _Nonnull stop) {
            NJPhotoBrowserItem * item = [[NJPhotoBrowserItem alloc] init];
            item.originURL = imageURL;
            [photoDataArrM addObject:item];
        }];
        
        _photoDataArr = [NSArray arrayWithArray:photoDataArrM];
    }
    return _photoDataArr;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer
{
    if(_singleTapGestureRecognizer == nil)
    {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapAction:)];
        
    }
    return _singleTapGestureRecognizer;
}

- (UISwipeGestureRecognizer *)swipeUpGestureRecognizer
{
    if(_swipeUpGestureRecognizer == nil)
    {
        _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpAction:)];
        _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        
    }
    return _swipeUpGestureRecognizer;
}

- (UISwipeGestureRecognizer *)swipeDownGestureRecognizer
{
    if(_swipeDownGestureRecognizer == nil)
    {
        _swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownAction:)];
        _swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        
    }
    return _swipeDownGestureRecognizer;
}


- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if(_doubleTapGestureRecognizer == nil)
    {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapAction:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if(_panGestureRecognizer == nil)
    {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    }
    return _panGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longGestureRecognizer
{
    if(_longGestureRecognizer == nil)
    {
        _longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
    }
    return _longGestureRecognizer;
}

- (void)setImageUrlArr:(NSArray<NSString *> *)imageUrlArr{
    _imageUrlArr = imageUrlArr;
    _numberOfPages = imageUrlArr.count;
}

- (void)setStartPage:(NSInteger)startPage
{
    _startPage = startPage;
    _currentPage = startPage;
}

- (UIImageView *)imgView
{
    if(_imgView == nil)
    {
        _imgView = [[UIImageView alloc] init];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

#pragma mark - 其他
- (void)scrollToStartPageAnimated:(BOOL)isAnimate{
    if (self.photoDataArr.count == 0) {
        return;
    }
    _startPage = _startPage > 0 && _startPage < self.imageUrlArr.count ? _startPage : 0;
    _currentPage = self.startPage;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:isAnimate];
}

- (NSInteger)currentCellIndex{
    NSInteger current = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    if(current < 0){
        current = 0;
    }
    if(current >= self.photoDataArr.count){
        current = self.photoDataArr.count - 1;
    }
    return current;
}

- (NJPhotoBrowserCell *)currentCell{
    return (NJPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self currentCellIndex] inSection:0]];
}

- (void)reloadAllData
{
    _photoDataArr = nil;
    [self.collectionView reloadData];
    
}

- (void)reloadDataWithIndex:(NSInteger)index
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)didEndUpSwiping
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(viewController:didEndUpSwiping:)])
    {
        NSInteger currentIndex = [self currentCellIndex];
        [self.delegate viewController:self didEndUpSwiping:currentIndex];
    }
}

- (void)didEndDownSwiping{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(viewController:didEndDownSwiping:)])
    {
        NSInteger currentIndex = [self currentCellIndex];
        [self.delegate viewController:self didEndDownSwiping:currentIndex];
    }
}

- (void)setupBaseViewControllerProperty:(NSInteger)cellIndex
{
    
    NJPhotoBrowserCell *cell = (NJPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
    
    self.imgView.frame = cell.contentScrollView.photoImageV.frame;
    self.imgView.image = cell.contentScrollView.photoImageV.image;
    self.imgView.hidden = YES;
    self.transitionImgViewCenter = _imgView.center;
}

@end
