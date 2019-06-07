//
//  NJPhotoBrowserScrollView.h
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJPhotoBrowserImageView.h"
@class NJPhotoBrowserItem, NJPhotoBrowserScrollView;
NS_ASSUME_NONNULL_BEGIN

@protocol NJPhotoBrowserScrollViewDelegate <NSObject>

- (void)scrollView:(NJPhotoBrowserScrollView *)scrollView zoomScale:(CGFloat)zoomScale;
@end

@interface NJPhotoBrowserScrollView : UIScrollView
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserItem * item;
/********* <#注释#> *********/
@property(nonatomic,weak)id<NJPhotoBrowserScrollViewDelegate> zoomDelegate;

/********* photoImageV *********/
@property(nonatomic,weak)NJPhotoBrowserImageView * photoImageV;

- (void)handelZoomForLocation:(CGPoint)location;

/********* 向下拖拽 *********/
@property(nonatomic,copy)void (^didEndDownDraggingBlock)(CGFloat velocity);

/********* 向上拖拽 *********/
@property(nonatomic,copy)void (^didEndUpDraggingBlock)(CGFloat velocity);
@end

NS_ASSUME_NONNULL_END
