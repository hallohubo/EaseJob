//
//  NJPhotoPickerManager.h
//  Destination
//
//  Created by TouchWorld on 2018/11/14.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAsset;
typedef void (^pickImageCompletedBlock)(UIImage * _Nullable image, NSError * _Nonnull error);

typedef void (^pickAssetCompletedBlock)(PHAsset * _Nullable asset, UIImage * _Nullable image, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, NJPhotoPickerType)
{
    NJPhotoPickerTypePhotoLibrary = 0,
    NJPhotoPickerTypeCamera,
    NJPhotoPickerTypeSavedPhotosAlbum
};
NS_ASSUME_NONNULL_BEGIN

@interface NJPhotoPickerManager : NSObject
+ (instancetype)shareInstance;


/**
 选择图片 不需要asset

 @param type 类型
 @param vc 控制器
 @param completed 回调
 */
- (void)presentPicker:(NJPhotoPickerType)type target:(UIViewController *_Nonnull)vc completed:(pickImageCompletedBlock __nonnull)completed;


/**
 选择图片 

 @param type 类型
 @param vc 控制器
 @param isNeed 拍照的图片是否需要元数据
 @param completed 回调
 */
- (void)presentPicker:(NJPhotoPickerType)type target:(UIViewController *)vc needMetadata:(BOOL)isNeed completed:(pickAssetCompletedBlock __nonnull)completed;
@end

NS_ASSUME_NONNULL_END
