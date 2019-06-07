//
//  DesNetUtil.m
//  PersonLocation
//
//  Created by yfzx on 13-8-30.
//  Copyright (c) 2013年 yfzx. All rights reserved.
//

#import "DesNetUtil.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation DesNetUtil

//static Byte iv[8]={1,2,3,4,5,6,7,8};

//+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
//    // 利用 GTMBase64 解碼 Base64 字串
//    NSData* cipherData = [GTMBase64 decodeString:cipherText];
//    
//    // update
//    
//    //
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//    
//    // IV 偏移量不需使用
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [cipherData bytes],
//                                          [cipherData length],
//                                          buffer,
//                                          1024,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//    }
//    return plainText;
//}
//
//
//+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
//{
//    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [data bytes],
//                                          [data length],
//                                          buffer,
//                                          1024,
//                                          &numBytesEncrypted);
//    
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        plainText = [GTMBase64 stringByEncodingData:dataTemp];
//    }else{
//        NSLog(@"DES加密失败");
//    }
//    return plainText;
//}

+(NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key
{
    NSData* bytes = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte * myByte = (Byte *)[bytes bytes];
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          myByte,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [GTMBase64 stringByEncodingData:data];
    }
    return ciphertext;
}
//
//+ (NSString *) encryptUseDES2:(NSString *)plainText key:(NSString *)key
//{
//    NSData* bytes = [key dataUsingEncoding:NSUTF8StringEncoding];
//    Byte * myByte = (Byte *)[bytes bytes];
//    
//    NSString *ciphertext = nil;
//    const char *textBytes = [plainText UTF8String];
//    NSUInteger dataLength = [plainText length];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          myByte,
//                                          textBytes, dataLength,
//                                          buffer, 1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        
//        ciphertext = [GTMBase64 stringByEncodingData:data];
//    }
//    return ciphertext;
//}

+(NSString*) decryptUseDES2:(NSString*)cipherText key:(NSString*)key {
    if([cipherText rangeOfString:@"http:"].length > 0)
        return cipherText;
    NSData* bytes = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte * myByte = (Byte *)[bytes bytes];
    
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          myByte,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

@end
