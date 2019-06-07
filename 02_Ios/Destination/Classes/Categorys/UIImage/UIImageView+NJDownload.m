//
//  UIImageView+NJDownload.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/28.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UIImageView+NJDownload.h"
#import <UIImageView+WebCache.h>
#import <AFNetworkReachabilityManager.h>
#import "UIImage+NJImage.h"
@implementation UIImageView (NJDownload)
- (void)setOriginImageWithURL:(NSString *)originImageURL setThumbnailImageWithURL:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder complete:( SDExternalCompletionBlock)completeBlock
{
    AFNetworkReachabilityManager * reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    //1.有没有原图(SDWebImage的图片缓存是用图片的url字符串作为key）
    SDImageCache * sharedImageCache = [SDImageCache sharedImageCache];
    UIImage * originImage = [sharedImageCache imageFromDiskCacheForKey:originImageURL];
    if(originImage != nil)//有原图
    {
//        self.image = originImage;
//        completeBlock(originImage,nil,0,[NSURL URLWithString:originImageURL]);
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completeBlock];
    }else
    {
        if([reachabilityManager isReachableViaWiFi])//wifi
        {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completeBlock];//下载原图
        }
        else if([reachabilityManager isReachableViaWWAN])// 3G/4G
        {
//#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            BOOL alwaysDownOriginImageWhen3GOr4G = NO;//用户偏好设置
            if(alwaysDownOriginImageWhen3GOr4G)
            {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completeBlock];//下载原图
            }
            else
            {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completeBlock];//下载小图
            }
            
        }else//没有网络
        {
            //看是否有小图缓存
            UIImage * smallImage = [sharedImageCache imageFromDiskCacheForKey:thumbnailImageURL];
            if(smallImage != nil)
            {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completeBlock];
            }
            else
            {
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completeBlock];//占位图
            }
        }
    }

}
- (void)setHeaderImage:(NSString *)headerImageURL
{
    UIImage * placeholder = [UIImage imageNamed:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:headerImageURL] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(image == nil)//图片下载失败
        {
            return ;
        }
        self.image = [image NJOricalImage];
    }];
}
@end
