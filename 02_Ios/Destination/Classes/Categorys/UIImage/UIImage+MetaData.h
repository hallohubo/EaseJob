//
//  UIImage+MetaData.h
//  ImageMeteDataTest
//
//  Created by TouchWorld on 2018/11/23.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MetaData)

/**
 获取图片元数据

 @param fileURL 图片文件地址
 @return 元数据
 */
+ (NSDictionary *)imageMetaDataWithFileURL:(NSURL *)fileURL;


/**
 获取图片EXIF数据

 @param fileURL 图片文件地址
 @return EXIF数据
 */
+ (NSDictionary *)imageEXIFDataWithFileURL:(NSURL *)fileURL;


/**
 获取图片TIFF数据

 @param fileURL 图片文件地址
 @return TIFF数据
 */
+ (NSDictionary *)imageTIFFDataWithFileURL:(NSURL *)fileURL;



/**
  获取图片GPS数据

 @param fileURL 图片文件地址
 @return GPS数据
 */
+ (NSDictionary *)imageGPSDataWithFileURL:(NSURL *)fileURL;


/**
 更改图片元数据
 */
+ (void)changeImageGPSInfo;

- (NSString *)changeImageMetaData:(NSDictionary *)metaDataDic;
@end

NS_ASSUME_NONNULL_END
