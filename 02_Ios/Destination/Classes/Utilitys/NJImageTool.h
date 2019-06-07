//
//  NJImageTool.h
//  Destination
//
//  Created by TouchWorld on 2018/11/8.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>


typedef void (^completedBlock)(PHAsset * _Nullable asset, NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface NJImageTool : NSObject
+ (instancetype)shareInstance;


/**
 是否相册授权

 @return 授权状态
 */
+ (BOOL)isPhotoAuthorization;

- (void)saveImageToAlbumWithImage:(UIImage *)image metadata:(NSDictionary *)metadataDic location:(CLLocation *)location completed:(completedBlock)completed;

/**
 判断是否HEIF/HEVC格式的图片

 @param data 数据
 @return 是否HEIF/HEVC格式的图片
 */
+ (BOOL)is_iOS11ImageType:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
