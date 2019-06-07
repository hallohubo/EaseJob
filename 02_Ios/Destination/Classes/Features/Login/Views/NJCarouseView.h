//
//  NJCarouseView.h
//  Destination
//
//  Created by TouchWorld on 2019/1/8.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NJCarouseViewScrollDirection) {
    NJCarouseViewScrollDirectionUp = 0,//先向上滚
    NJCarouseViewScrollDirectionDown
};
@class NJLoginCarouseImageItem;
NS_ASSUME_NONNULL_BEGIN

@interface NJCarouseView : UIView
/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NJLoginCarouseImageItem *> * carouseImageArr;

/********* 起始偏移量 *********/
@property(nonatomic,assign)CGFloat scrollOffSetY;
/********* 滚动时间 *********/
@property(nonatomic,assign)CGFloat scrollTime;
/********* 滚动距离 *********/
@property(nonatomic,assign)CGFloat scrollDistance;
/********* 滚动方向 *********/
@property(nonatomic,assign)NJCarouseViewScrollDirection direction;


//开始动画
- (void)beginAnimation;
@end

NS_ASSUME_NONNULL_END
