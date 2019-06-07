//
//  NJPhotoPickerManager.m
//  Destination
//
//  Created by TouchWorld on 2018/11/14.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoPickerManager.h"
#import "NJImageTool.h"
#import "FileCacheTool.h"
#import "UIImage+MetaData.h"
#import <TZImageManager.h>
#import <Photos/Photos.h>

@interface NJPhotoPickerManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/********* <#注释#> *********/
@property(nonatomic,copy)pickAssetCompletedBlock completed;
/********* <#注释#> *********/
@property(nonatomic,weak)UIViewController * vc;
/********* 是否需要元数据 *********/
@property(nonatomic,assign)BOOL isNeedMetadata;
/********* 类型 *********/
@property(nonatomic,assign)NJPhotoPickerType type;

@end
@implementation NJPhotoPickerManager
static NJPhotoPickerManager * manager;

+ (instancetype)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NJPhotoPickerManager alloc] init];
    });
    
    return manager;
}

- (void)presentPicker:(NJPhotoPickerType)type target:(UIViewController *)vc completed:(pickImageCompletedBlock)completed
{
    [self presentPicker:type target:vc needMetadata:NO completed:^(PHAsset *asset, UIImage *image, NSError *error) {
        if(error)
        {
            completed(nil, error);
        }
        else
        {
            completed(image, error);
        }
    }];
}

- (void)presentPicker:(NJPhotoPickerType)type target:(UIViewController *)vc needMetadata:(BOOL)isNeed completed:(pickAssetCompletedBlock)completed
{
    if(![NJImageTool isPhotoAuthorization])
    {
        return;
    }
    
    self.completed = completed;
    self.vc = vc;
    self.type = type;
    self.isNeedMetadata = isNeed;
    
    if(type == NJPhotoPickerTypeCamera)//拍照
    {
        //相机是否可用
        BOOL flag = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if(!flag){
            HDLog(@"相机不可用");
            NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:500 userInfo:@{            NSLocalizedDescriptionKey : @"相机不可用"}];
            completed(nil, nil, error);
            return;
        }
        
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = NO;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [vc presentViewController:imagePickerVC animated:YES completion:nil];
    }else if(type == NJPhotoPickerTypeSavedPhotosAlbum){//相册
        //相册是否可用
        BOOL flag = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        if(!flag)
        {
            HDLog(@"相册不可用");
            NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:500 userInfo:@{
                                                                                              NSLocalizedDescriptionKey : @"相册不可用"
                                                                                              }];
            completed(nil, nil, error);
            return;
        }
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = NO;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [vc presentViewController:imagePickerVC animated:YES completion:nil];
    }
}


#pragma mark - UIImagePickerControllerDelegate方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
//    HDLog(@"%@", info);
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSDictionary * metadataDic = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    UIImage * image;
    if([mediaType isEqualToString:@"public.image"])
    {
        if([picker allowsEditing])//允许编辑
        {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    //不需要添加元数据
    if(self.type != NJPhotoPickerTypeCamera || !self.isNeedMetadata)
    {
        [self.vc dismissViewControllerAnimated:YES completion:^{
            self.completed(nil, image, nil);
        }];
        
        return;
    }
    
    
    //图片处理中
    NSNumber * longitudeNumber = (NSNumber *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultLocationLongitute];
    NSNumber * latitudeNumber = (NSNumber *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultLocationLatitute];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:[latitudeNumber doubleValue] longitude:[longitudeNumber doubleValue]];
    [NJProgressHUD showWithMessage:@"处理图片中"];
    
    
    
//    [[TZImageManager manager] savePhotoWithImage:metaDataImage completion:^(PHAsset *asset, NSError *error) {
//        HDLog(@"保存成功");
//    }];
    
    //保存图片到相册
    [[NJImageTool shareInstance] saveImageToAlbumWithImage:image metadata:metadataDic location:location completed:^(PHAsset *asset, NSError *error) {
        [NJProgressHUD dismiss];
        if(error)
        {
            [NJProgressHUD showError:@"保存图片失败"];
            [NJProgressHUD dismissWithDelay:1.2];
            [self.vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        }
        
        [self.vc dismissViewControllerAnimated:YES completion:^{
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                if(!isDegraded)
                {
                    self.completed(asset, image, error);
                }
            }];
            
        }];
    }];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    HDLog(@"取消拍照");
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

@end
