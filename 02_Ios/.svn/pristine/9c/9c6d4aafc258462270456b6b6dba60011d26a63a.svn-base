//
//  NJPhotoBrowserCell.h
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJPhotoBrowserItem, NJPhotoBrowserScrollView;
NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoBrowserCell : UICollectionViewCell
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserItem * item;
/********* contentScrollView *********/
@property(nonatomic,weak)NJPhotoBrowserScrollView * contentScrollView;

/********* 向下拖拽 *********/
@property(nonatomic,copy)void (^didEndDownDraggingBlock)(void);

/********* 向上拖拽 *********/
@property(nonatomic,copy)void (^didEndUpSwipingBlock)(void);
@end

NS_ASSUME_NONNULL_END
