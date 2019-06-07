//
//  NJPhotoBrowserScrollView.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserScrollView.h"
#import "NJPhotoBrowserItem.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define observer_keypath_image @"image"
@interface NJPhotoBrowserScrollView () <UIScrollViewDelegate>

/********* <#注释#> *********/
@property(nonatomic,assign)CGFloat velocity;


@end
@implementation NJPhotoBrowserScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
        
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if(newWindow)
    {
        [self addImageObserver];
    }
    else
    {
        [self removeImageObserver];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if(self.window)
    {
        [self updateScrollViewFrame];
    }
    
}


#pragma mark - 设置初始化
- (void)setupInit
{
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        
    }
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = YES;
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = NO;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 1.0;
    self.multipleTouchEnabled = YES;
    self.delegate = self;
    
    NJPhotoBrowserImageView * photoImageV = [[NJPhotoBrowserImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    [self addSubview:photoImageV];
    self.photoImageV = photoImageV;
}

#pragma mark - observer
- (void)addImageObserver
{
    [self.photoImageV addObserver:self forKeyPath:observer_keypath_image options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeImageObserver
{
    [self.photoImageV removeObserver:self forKeyPath:observer_keypath_image];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if(![object isEqual:self.photoImageV])
    {
        return;
    }
    
    if(![keyPath isEqualToString:observer_keypath_image])
    {
        return;
    }
    
    if(!self.photoImageV.image)
    {
        return;
    }
    
    [self updateScrollViewFrame];
}

#pragma mark - UIScrollViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.alwaysBounceVertical = scrollView.zoomScale != 1.0;
    
    [self reCenerImage];
    if(self.zoomDelegate != nil)
    {
        if([self.zoomDelegate respondsToSelector:@selector(scrollView:zoomScale:)])
        {
            [self.zoomDelegate scrollView:self zoomScale:self.zoomScale];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.velocity = velocity.y;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat rawPercent = [self rawContentOffSetVerticalPercent];
    CGFloat velocity = self.velocity;
    //需要在缩放比例为1时，才能下拉拖拽关闭，上拉显示其他界面操作
    if(self.zoomScale != 1.0)
    {
        return;
    }
    
    HDLog(@"rawPercent: %@", @(rawPercent));
    HDLog(@"velocity: %@", @(velocity));
    
    if(fabs(rawPercent) <= 0)
    {
        return;
    }
    
    
    if (fabs(rawPercent) < 0.12f && fabs(velocity) < 1) {
        return;
    }
    // 停止时有相反方向滑动操作时取消退出操作
    if (rawPercent * velocity < 0) {
        return;
    }
    
    //如果是长图，并且是向上滑动，需要滑到底部以下才能显示其他界面
    //向上滑动
    if(velocity > 0)
    {
        // 速度过快且滑过区域较小，防止误操作，取消
        // 速度过快且滑过区域较小，防止误操作，取消
        if (velocity > 2.8 && rawPercent < 0.1) {
            return;
        }
 
        if(self.contentOffset.y + CGRectGetHeight(self.bounds) < self.contentSize.height)
        {
            return;
        }

        if(self.didEndUpDraggingBlock != nil)
        {
            self.didEndUpDraggingBlock(self.velocity);
        }

    }
    else//向下滑动
    {
        // 向下滑动
        // 速度过快，防止误操作，取消
        if(fabs(velocity) > 2.8)
        {
            return;
        }

        if(self.contentOffset.y > 0)
        {
            return;
        }

        if(self.didEndDownDraggingBlock != nil)
        {
            self.didEndDownDraggingBlock(self.velocity);
        }
    }
}

/// +/- percent.
- (CGFloat)rawContentOffSetVerticalPercent {
    CGFloat percent = 0;
    
    CGFloat contentHeight = self.contentSize.height;
    CGFloat scrollViewHeight = CGRectGetHeight(self.bounds);
    CGFloat offsetY = self.contentOffset.y;
    CGFloat factor = 1.3;
    
    if (offsetY < 0) {
        percent = MIN(offsetY / (scrollViewHeight * factor), 1.0f);
    } else {
        if (contentHeight < scrollViewHeight) {
            percent = MIN(offsetY / (scrollViewHeight * factor), 1.0f);
        } else {
            offsetY += scrollViewHeight;
            CGFloat contentHeight = self.contentSize.height;
            if (offsetY > contentHeight) {
                percent = MIN((offsetY - contentHeight) / (scrollViewHeight * factor), 1.0f);
            }
        }
    }
    
    return percent;
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageV;
}

#pragma mark - setter
- (void)setItem:(NJPhotoBrowserItem *)item
{
    _item = item;
    self.photoImageV.item = item;
}

#pragma mark - 其他
- (void)updateScrollViewFrame
{
    [self setZoomScale:1.0 animated:YES];
    [self updateFrame];
    [self reCenerImage];
    [self setMaximumZoomScale];
}

//更新imageV尺寸和scrollView的contentView
- (void)updateFrame
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UIImage * image = self.photoImageV.image;
    if(!image)
    {
        return;
    }
    
    CGSize properSize = [self properPresentSizeForimage:image];
    self.photoImageV.frame = CGRectMake(0, 0, properSize.width, properSize.height);
    self.contentSize = properSize;

}

- (CGSize)properPresentSizeForimage:(UIImage *)image
{
    CGFloat ratio = CGRectGetWidth(self.bounds) * 1.0 / image.size.width;
    return CGSizeMake(CGRectGetWidth(self.bounds), ceil(ratio * image.size.height));
}

//设置imageV的center
- (void)reCenerImage
{
    CGFloat contentWidth = self.contentSize.width;
    CGFloat horizontalDiff = CGRectGetWidth(self.bounds) - contentWidth;
    CGFloat horizontalAddition = horizontalDiff > 0 ? horizontalDiff : 0;
    
    CGFloat contentHeight = self.contentSize.height;
    CGFloat verticalDiff = CGRectGetHeight(self.bounds) - contentHeight;
    CGFloat verticalAddition = verticalDiff > 0 ? verticalDiff : 0;
    
    self.photoImageV.center = CGPointMake((contentWidth + horizontalAddition) / 2.0f, (contentHeight + verticalAddition) / 2.0f);
    
//    HDLog(@"zoomScale:%lf", self.zoomScale);
}

//设置scrollView的缩放比例
- (void)setMaximumZoomScale
{
    CGSize imageSize = self.photoImageV.image.size;
    CGFloat scrollViewWidth = CGRectGetWidth(self.bounds);
    CGFloat scrollViewHeight = CGRectGetHeight(self.bounds);
    if(imageSize.width <= scrollViewWidth && imageSize.height <= scrollViewHeight)
    {
        self.maximumZoomScale = 1.0;
    }
    else
    {
        self.maximumZoomScale = MAX(MIN(imageSize.width / scrollViewWidth, imageSize.height / scrollViewHeight), 3.0f);
    }
}


- (void)handelZoomForLocation:(CGPoint)location
{
    CGPoint touchPoint = [self.superview convertPoint:location toView:self.photoImageV];
    if(self.zoomScale > 1)
    {
        [self setZoomScale:1.0 animated:YES];
    }
    else if(self.maximumZoomScale > 1.0)
    {
        CGFloat maximumZooScale = self.maximumZoomScale;
        CGFloat horizontalWidth = CGRectGetWidth(self.bounds) / maximumZooScale;
        CGFloat verticalHeight = CGRectGetHeight(self.bounds) / maximumZooScale;
        [self zoomToRect:CGRectMake(touchPoint.x - horizontalWidth / 2.0f, touchPoint.y - verticalHeight / 2.0f, horizontalWidth, verticalHeight) animated:YES];
    }
}

- (void)dealloc
{
    
}
@end
