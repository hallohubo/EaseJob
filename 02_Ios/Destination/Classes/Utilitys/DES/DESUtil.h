//
//  DES.h
//  test
//
//  Created by fatty on 14-4-2.
//  Copyright (c) 2014年 com.vtion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESUtil : NSObject

+ (NSString *)encryptWithText:(NSString *)sText key:(NSString *)sKey;//加密
+ (NSString *)decryptWithText:(NSString *)sText key:(NSString *)sKey;//解密
@end
