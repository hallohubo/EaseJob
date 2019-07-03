//
//  HBModyfyAvatarVC.h
//  Destination
//
//  Created by 胡勃 on 7/3/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBModyfyNicknameVC : UIViewController
@property (nonatomic, copy) void(^HBModifyMyInformationBlock)(NSString *str_title);

- (instancetype)initWithTitle:(NSString *)strTile defaultValue:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
