//
//  DesNetUtil.h
//  PersonLocation
//
//  Created by yfzx on 13-8-30.
//  Copyright (c) 2013年 yfzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesNetUtil : NSObject

//+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
//
//+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

+(NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key;

+(NSString *) decryptUseDES2:(NSString*)cipherText key:(NSString*)key;

@end
