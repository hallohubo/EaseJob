//
//  NJPhotoBrowserDrivenInteractiveTransition.h
//  Destination
//
//  Created by TouchWorld on 2019/1/2.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NJPhotoBrowserTransitionParameter;
NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoBrowserDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
- (instancetype)initWithTransitionParameter:(NJPhotoBrowserTransitionParameter *)transitionParameter;
@end

NS_ASSUME_NONNULL_END
