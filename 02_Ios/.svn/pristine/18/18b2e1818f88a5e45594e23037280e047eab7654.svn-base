//
//  NJPhotoBrowserCell.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserCell.h"
#import "NJPhotoBrowserItem.h"
#import "NJPhotoBrowserScrollView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJPhotoBrowserCell () <NJPhotoBrowserScrollViewDelegate>

/********* 双击 *********/
@property(nonatomic,strong)UITapGestureRecognizer * doubleTapGestureRecognizer;

@end

@implementation NJPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

#pragma mark - 设置初始化
- (void)setupInit{
    self.contentView.backgroundColor = [UIColor blackColor];
    [self setupContentScrollView];
}

#pragma mark - scrollView
- (void)setupContentScrollView{
    NJPhotoBrowserScrollView * contentScrollView = [[NJPhotoBrowserScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.contentView addSubview:contentScrollView];
    contentScrollView.zoomDelegate = self;
    HDWeakSelf;
    contentScrollView.didEndDownDraggingBlock = ^(CGFloat velocity) {
        HDLog(@"down:%lf", velocity);
        if(weakSelf.didEndDownDraggingBlock != nil){
            weakSelf.didEndDownDraggingBlock();
        }
    };
    contentScrollView.didEndUpDraggingBlock = ^(CGFloat velocity) {
        HDLog(@"up:%lf", velocity);
        if(weakSelf.didEndUpSwipingBlock != nil){
            weakSelf.didEndUpSwipingBlock();
        }
    };
    self.contentScrollView = contentScrollView;
}

- (void)setItem:(NJPhotoBrowserItem *)item
{
    _item = item;
    self.contentScrollView.item = item;
}

#pragma mark - NJPhotoBrowserScrollViewDelegate方法
- (void)scrollView:(NJPhotoBrowserScrollView *)scrollView zoomScale:(CGFloat)zoomScale
{
    HDLog(@"%lf", zoomScale);
}

#pragma mark - 懒加载
- (UITapGestureRecognizer *)doubleTapGestureRecognizer{
    if(_doubleTapGestureRecognizer == nil){
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapAction:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

#pragma mark - 其他


@end
