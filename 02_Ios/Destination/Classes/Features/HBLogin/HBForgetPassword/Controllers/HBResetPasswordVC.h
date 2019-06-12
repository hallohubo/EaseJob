//
//  HBResetPasswordVC.h
//  Destination
//
//  Created by 胡勃 on 6/12/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBResetPasswordVC : UIViewController
- (instancetype)initWithPhone:(NSString *)phoneNumber specifiedCode:(NSString *)sCode;
@end

NS_ASSUME_NONNULL_END
