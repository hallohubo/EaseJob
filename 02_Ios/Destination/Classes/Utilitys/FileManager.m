//
//  FileManager.m
//  Casting
//
//  Created by 启辰 on 15/11/24.
//  Copyright © 2015年 启辰. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (BOOL)createFolder:(NSString *)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:folderName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (NSString *)getFolder:(NSString *)folderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:folderName];
    return folderPath;
}

+ (void)deleteFilePathString:(NSString *)filePathString {
    
    if (filePathString.length <= 0) {
        return;
    }
    
    //delete
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = filePathString;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
        }
    });
    
}

+ (void)deleteFolderPathString:(NSString *)folderName {
    if (folderName.length <= 0) {
        return;
    }
    //delete
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:folderName];
        
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    });
    
}

+ (BOOL)writeToTmpFolder:(NSData *)data fileName:(NSString *)fileName {
    if (!data || fileName.length <= 0) {
        return NO;
    }
    
    [FileManager createFolder:Tmp_FOLDER];
    
    NSString * fullPath = [[FileManager getFolder:Tmp_FOLDER] stringByAppendingPathComponent:fileName];
    // 将图片写入文件
    return [data writeToFile:fullPath atomically:YES];
}

+ (void)writeOutlineFolder:(NSData *)data fileName:(NSString *)fileName {
    if (!data || fileName.length <= 0) {
        return ;
    }
    
    [FileManager createFolder:Outline_FOLDER];
    
    NSString *fullPath = [[FileManager getFolder:Outline_FOLDER] stringByAppendingPathComponent:fileName];
    // 将图片写入文件
    [data writeToFile:fullPath atomically:NO];
}

+ (NSString *)getTmpFilePath:(NSString *)fileName {
    [FileManager createFolder:Tmp_FOLDER];
    NSString *fullPath = [[FileManager getFolder:Tmp_FOLDER] stringByAppendingPathComponent:fileName];
    return fullPath;
}

+ (NSString *)getOutlineFilePath:(NSString *)fileName {
    [FileManager createFolder:Outline_FOLDER];
    NSString *fullPath = [[FileManager getFolder:Outline_FOLDER] stringByAppendingPathComponent:fileName];
    return fullPath;
}


+ (void)deleteTmpFolder
{
    [FileManager deleteFolderPathString:Tmp_FOLDER];
}


/**
 获取文件／文件夹大小
 
 @param fileName 文件／文件夹路径
 @return 大小
 */
+ (CGFloat)getFileSizeWithFileName:(NSString *)fileName
{
    //文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断字符串是否为文件/文件夹
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:fileName isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) return 0;
    //self是文件夹
    if (dir){
        //遍历文件夹中的所有内容
        NSArray *subpaths = [mgr subpathsAtPath:fileName];
        //计算文件夹大小
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths){
            //拼接全路径
            NSString *fullSubPath = [fileName stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO){//是文件
                NSDictionary *attr = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                totalByteSize += [attr[NSFileSize] integerValue];
            }
        }
        return totalByteSize;
        
    } else{//是文件
        NSDictionary *attr = [mgr attributesOfItemAtPath:fileName error:nil];
        return [attr[NSFileSize] floatValue];
    }
}

+ (CGFloat)sizeOfTmpDir
{
    NSString * tmpDirPath = [FileManager getFolder:Tmp_FOLDER];
    CGFloat size = [FileManager getFileSizeWithFileName:tmpDirPath];
    return size;
}

+ (NSString *)writeImageToCache:(UIImage *)image
{
    //图片压缩
    NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //图片名
    NSString * imageName = [NSString timeStampWithSubffix:@"construction.jpg" index:0];
    NSLog(@"imageName:%@", imageName);
    
    //写入缓存
    BOOL writeSuccess = [FileManager writeToTmpFolder:imageData fileName:imageName];
    if(writeSuccess == false)
    {
        NSLog(@"图片写入tmp失败");
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD dismiss];
        return nil;
    }
    
    
    //获取图片路径
    NSString * imagePath = [FileManager getTmpFilePath:imageName];
    return imagePath;
}



@end
