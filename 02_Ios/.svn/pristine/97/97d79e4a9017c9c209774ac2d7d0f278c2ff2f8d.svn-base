//
//  NJShareListView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareListView.h"
#import "NJShareItemCell.h"
#import "NJShareIconItem.h"
#import <MJExtension.h>
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>

@interface NJShareListView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/********* collectionView *********/
@property(nonatomic,weak)UICollectionView * collectionView;
/********* 数据 *********/
@property(nonatomic,strong)NSArray<NJShareIconItem *> * shareDataArr;

@end

@implementation NJShareListView
static NSString * const ID = @"NJShareItemCell";

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
    [self setupCollectionView];
}

#pragma mark - collectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = NJGrayColor(246);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NJShareItemCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    
}

#pragma mark - UICollectionViewDataSource方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shareDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NJShareItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NJShareIconItem * item =  self.shareDataArr[indexPath.row];
    cell.item = item;
//    HDLog(@"%p--%ld", cell, indexPath.row);
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NJShareIconItem * item = self.shareDataArr[indexPath.row];
    if(self.shareBlock != nil)
    {
        self.shareBlock(item.type);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(81, 120);
}


#pragma mark - 懒加载
- (NSArray<NJShareIconItem *> *)shareDataArr
{
    if(_shareDataArr == nil)
    {
        NSMutableArray<NSDictionary *> * shareDicArrM = [NSMutableArray array];
        if([WXApi isWXAppInstalled])
        {
            [shareDicArrM addObjectsFromArray:@[
                                                @{
                                                    @"iconName" : @"icon_wechat",
                                                    @"title" : @"微信",
                                                    @"type" : @(ShareTypeWeChat)
                                                    
                                                    },
                                                @{
                                                    @"iconName" : @"icon_circle_of_friends",
                                                    @"title" : @"朋友圈",
                                                    @"type" : @(ShareTypeFriendCircle)
                                                    
                                                    }
                                                ]];
        }
        
        if([WeiboSDK isWeiboAppInstalled])
        {
            [shareDicArrM addObjectsFromArray:@[
                                                @{
                                                    @"iconName" : @"icon_weibo",
                                                    @"title" : @"微博",
                                                    @"type" : @(ShareTypeWeibo)
                                                    }
                                                ]];
        }
        
        if([QQApiInterface isQQInstalled])
        {
            [shareDicArrM addObjectsFromArray:@[
                                                @{
                                                    @"iconName" : @"icon_qq",
                                                    @"title" : @"QQ",
                                                    @"type" : @(ShareTypeQQ)
                                                    },
                                                @{
                                                    @"iconName" : @"icon_qq_zone",
                                                    @"title" : @"QQ空间",
                                                    @"type" : @(ShareTypeZone)
                                                    }
                                                ]];
        }
        
        _shareDataArr = [NJShareIconItem mj_objectArrayWithKeyValuesArray:shareDicArrM];
    }
    return _shareDataArr;
}
@end
