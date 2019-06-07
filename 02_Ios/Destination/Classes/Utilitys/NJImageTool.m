//
//  NJImageTool.m
//  Destination
//
//  Created by TouchWorld on 2018/11/8.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJImageTool.h"
#import "NJCommonTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+MetaData.h"
#import <ImageIO/ImageIO.h>

@interface NJImageTool ()

@end
@implementation NJImageTool
static NJImageTool * imageTool;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageTool = [[NJImageTool alloc] init];
        
    });
    return imageTool;
}

+ (BOOL)isPhotoAuthorization
{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //是否授权
    if(videoStatus == AVAuthorizationStatusDenied)
    {
        [self guideUserOpenAuth];
        return NO;
    }
    
    return YES;
}

- (void)saveImageToAlbumWithImage:(UIImage *)image metadata:(NSDictionary *)metadataDic location:(CLLocation *)location completed:(completedBlock)completed
{
    NSMutableDictionary * metadataDicM = [[NSMutableDictionary alloc] initWithDictionary:metadataDic];
    NSDictionary *gpsDict = [NSDictionary
                             dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:location.coordinate.latitude], kCGImagePropertyGPSLatitude,
                             @"N", kCGImagePropertyGPSLatitudeRef,
                             [NSNumber numberWithFloat:location.coordinate.longitude], kCGImagePropertyGPSLongitude,
                             @"E", kCGImagePropertyGPSLongitudeRef,
                             @"04:30:51.71", kCGImagePropertyGPSTimeStamp,
                             nil];
    [metadataDicM setObject:gpsDict forKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    
    NSString * metaDataImagePath = [image changeImageMetaData:[NSDictionary dictionaryWithDictionary:metadataDicM]];
    [self saveImageWithPath:metaDataImagePath completed:completed];

}

- (void)saveImageWithPath:(NSString *)path completed:(completedBlock)completed
{
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL URLWithString:path]];
        localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
        //        if (location) {
        //            request.location = location;
        //        }
        request.creationDate = [NSDate date];
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && completed) {
                PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
                HDLog(@"保存图片成功");
                completed(asset, nil);
            } else if (error) {
                NSLog(@"保存照片出错:%@",error.localizedDescription);
                if (completed) {
                    completed(nil, error);
                }
            }
        });
    }];
}

#pragma mark - 懒加载

#pragma mark - 其他
+ (void)guideUserOpenAuth
{
    [LBXAlertAction sayWithTitle:@"温馨提示" message:@"请打开相机权限" buttons:@[@"确定", @"去设置"] chooseBlock:^(NSInteger buttonIdx) {
        if(buttonIdx == 1)//去设置
        {
            [[NJCommonTool shareInstance] openAppSetting];
        }
    }];
}


//判断是否HEIF/HEVC格式的图片
+ (BOOL)is_iOS11ImageType:(NSData *)data
{
    if (!data) {
        return NO;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0x00: {
            if (data.length >= 12) {
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return YES;
                }
            }
            break;
        }
    }
    return NO;
}
@end
