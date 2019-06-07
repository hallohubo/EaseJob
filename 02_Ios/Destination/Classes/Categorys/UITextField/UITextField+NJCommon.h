//
//  UITextField+NJCommon.h
//  Destination
//
//  Created by TouchWorld on 2019/1/10.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (NJCommon)
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitNumber:(NSInteger)limitNumber;
@end

NS_ASSUME_NONNULL_END
