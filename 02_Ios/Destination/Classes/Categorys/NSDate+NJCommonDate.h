//
//  NSDate+NJCommonDate.h
//  Destination
//
//  Created by TouchWorld on 2018/11/7.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (NJCommonDate)


/**
 获取当前日期的格式化

 @return 格式后的字符串
 */
+ (NSString *)currentDateFormatter;
/**
 格式化日期

 @param formatterStr 格式 yyyy-MM-dd HH:mm:ss
 @return 格式后的字符串
 */
- (NSString *)formatterDate:(NSString *)formatterStr;
@end

NS_ASSUME_NONNULL_END
