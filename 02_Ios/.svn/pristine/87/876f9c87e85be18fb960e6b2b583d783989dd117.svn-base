//
//  FileManager.h
//  Casting
//
//  Created by 启辰 on 15/11/24.
//  Copyright © 2015年 启辰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Plot_FOLDER @"plots"
#define Tmp_FOLDER @"tmp" 
#define Outline_FOLDER @"outline" //草稿信箱


@interface FileManager : NSObject

+ (BOOL)createFolder:(NSString *)folderName;
+ (NSString *)getFolder:(NSString *)folderName;
+ (void)deleteFilePathString:(NSString *)filePathString;
+ (void)deleteFolderPathString:(NSString *)folderName;
+ (BOOL)writeToTmpFolder:(NSData *)data fileName:(NSString *)fileName;
+ (void)writeOutlineFolder:(NSData *)data fileName:(NSString *)fileName;
+ (NSString *)getTmpFilePath:(NSString *)fileName;
+ (NSString *)getOutlineFilePath:(NSString *)fileName;


/**
 删除tmp文件夹

 */
+ (void)deleteTmpFolder;

/**
 获取文件／文件夹大小
 
 @param fileName 文件／文件夹路径
 @return 大小
 */
+ (CGFloat)getFileSizeWithFileName:(NSString *)fileName;


/**
 临时文件夹的大小

 @return 大小
 */
+ (CGFloat)sizeOfTmpDir;


/**
 将图片写入外部缓存

 @param image tup
 @return 外部缓存地址
 */
+ (NSString *)writeImageToCache:(UIImage *)image;
@end
