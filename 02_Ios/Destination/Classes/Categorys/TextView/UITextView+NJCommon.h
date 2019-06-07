//
//  UITextView+NJCommon.h
//  Destination
//
//  Created by TouchWorld on 2019/1/10.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (NJCommon)
+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limitNumber:(NSInteger)limitNumber;
@end

NS_ASSUME_NONNULL_END
