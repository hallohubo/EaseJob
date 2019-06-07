//
//  NJPhotoBrowserTransitionParameter.h
//  Destination
//
//  Created by TouchWorld on 2019/1/2.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoBrowserTransitionParameter : NSObject
//************************** firstVC、secondVC 都需要传值
//转场过渡image
@property (nonatomic, strong) UIImage           *transitionImage;

/////所浏览图片的下标
//@property (nonatomic, assign) NSInteger         transitionImgIndex;


//************************** 只需要secondVC 传值
///滑动返回手势
@property (nonatomic, strong, nullable) UIPanGestureRecognizer * gestureRecognizer;
///当前滑动时，对应图片的frame
@property (nonatomic, assign) CGRect                 currentPanGestImgFrame;
@end

NS_ASSUME_NONNULL_END
