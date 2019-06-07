//
//  NJShareCardListView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareCardListView.h"
#import "NJShareCardCell.h"
#import "NJShareItem.h"

#define CardViewWidth ((HDScreenW - 35) * 0.5)
#define CardViewHeight 209
@interface NJShareCardListView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/********* containerView *********/
@property(nonatomic,weak)UIView * containerView;
/********* collectionView *********/
@property(nonatomic,weak)UICollectionView * collectionView;
@end
@implementation NJShareCardListView
static NSString * const ID = @"NJShareCardCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

#pragma mark - 设置初始化
- (void)setupInit
{
    UIView * containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(14, 0, 14, 0));
    }];
    
    self.containerView = containerView;
    
    [self setupCollectView];
}

#pragma mark - collectionView
- (void)setupCollectView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.containerView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    self.collectionView = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.allowsSelection = YES;
    collectionView.allowsMultipleSelection = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NJShareCardCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    
}

#pragma mark - setupSelectBgView
- (void)setupSelectBgView
{
    UIView * selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CardViewWidth, CardViewHeight)];
    [self.containerView addSubview:selectBgView];
    selectBgView.backgroundColor = NJGrayColor(238);
    
    
}

#pragma mark - UICollectionViewDataSource方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.type == ShareCardTypeBoth ? 2 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDWeakSelf;
    NJShareCardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if(self.type == ShareCardTypeBoth)
    {
        cell.type = indexPath.row == 0 ? ShareCardTypeImage : ShareCardTypeLink;
    }
    else
    {
        cell.type = self.type;
    }
    cell.shareItem = self.shareItem;
    cell.qrCodeBlock = ^{
        if(weakSelf.qrCodeBlock != nil)
        {
            weakSelf.qrCodeBlock();
        }
    };
//        HDLog(@"%p--%ld", cell, indexPath.row);
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CardViewWidth, CardViewHeight);
}


#pragma mark - 其他
- (void)setType:(ShareCardType)type
{
    _type = type;
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat oneSection = (HDScreenW - CardViewWidth) * 0.5;
    CGFloat leftInset = type == ShareCardTypeBoth ? 15 : oneSection;
    layout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, leftInset);
    
    [self.collectionView reloadData];
    
    //默认选中
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (ShareCardType)selectedType;
{
     NSIndexPath * indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
    NJShareCardCell * cell = (NJShareCardCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.type;
    
}

#pragma mark - setter
- (void)setShareItem:(NJShareItem *)shareItem
{
    _shareItem = shareItem;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}



@end
