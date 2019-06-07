//
//  NJPhotoBrowserModalAnimationTransition.h
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NJPhotoBrowserTransitionParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoBrowserModalAnimationTransition : NSObject <UIViewControllerTransitioningDelegate>
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserTransitionParameter * transitionParameter;

@end

NS_ASSUME_NONNULL_END
