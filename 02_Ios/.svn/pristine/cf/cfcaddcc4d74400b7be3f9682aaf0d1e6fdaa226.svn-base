//
//  NJPhotoBrowserVC.h
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJPhotoBrowserModalAnimationTransition.h"
@class NJPhotoBrowserVC;
@protocol NJPhotoBrowserDelegate <NSObject>
@optional
- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc didDoubleTapedAtIndex:(NSInteger)index;

- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc didSingleTapedAtIndex:(NSInteger)index;

- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc didEndDecelerating:(NSInteger)index;


/**
 长按手势

 @param vc vc
 @param index 下标
 */
- (void)viewController:(NJPhotoBrowserVC *_Nonnull)vc didLongPress:(NSInteger)index;


/**
 是否在转场动画

 @param vc NJPhotoBrowserVC
 @param isPop 是否
 */
- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc isPop:(BOOL)isPop;

/**
 向下拖拽

 @param vc NJPhotoBrowserVC
 @param index 下标
 */
- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc didEndDownSwiping:(NSInteger)index;


/**
 向上swipe
 
 @param vc NJPhotoBrowserVC
 @param index 下标
 */
- (void)viewController:(NJPhotoBrowserVC *_Nullable)vc didEndUpSwiping:(NSInteger)index;

@end
NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoBrowserVC : UIViewController
/********* 拖拽手势 *********/
@property(nonatomic,strong)UIPanGestureRecognizer * panGestureRecognizer;
/********* 横扫手势up *********/
@property(nonatomic,strong)UISwipeGestureRecognizer * swipeUpGestureRecognizer;

/********* 横扫手势down *********/
@property(nonatomic,strong)UISwipeGestureRecognizer * swipeDownGestureRecognizer;
/********* delegate *********/
@property(nonatomic,weak)id<NJPhotoBrowserDelegate> delegate;
/********* 数据 *********/
@property(nonatomic,strong)NSArray<NSString *> * imageUrlArr;
/********* 起始页 *********/
@property(nonatomic,assign)NSInteger startPage;

/********* 总页数 *********/
@property(nonatomic,assign, readonly)NSInteger numberOfPages;
/********* 当前页 *********/
@property(nonatomic,assign, readonly)NSInteger currentPage;
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserModalAnimationTransition * animatedTransition;


- (void)reloadAllData;

- (void)reloadDataWithIndex:(NSInteger)index;



@end

NS_ASSUME_NONNULL_END
