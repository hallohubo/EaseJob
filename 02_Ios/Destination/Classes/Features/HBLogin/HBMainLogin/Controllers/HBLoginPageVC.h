//
//  HBLoginPageVC.h
//  Destination
//
//  Created by 胡勃 on 6/9/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBLoginPageVC : UIViewController
@property (nonatomic, copy) void(^loginFinishedBlock)(HDLoginUserModel *model);
@end

NS_ASSUME_NONNULL_END
