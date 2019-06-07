//
//  NJPhotoBrowserImageView.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserImageView.h"
#import "NJPhotoBrowserItem.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
@interface NJPhotoBrowserImageView ()

@end

@implementation NJPhotoBrowserImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setItem:(NJPhotoBrowserItem *)item
{
    _item = item;
    HDWeakSelf;
    if([NSString isEmptyString:item.originURL] && item.localImage == nil)
    {
        HDLog(@"图片模型没有图片地址和本地图片");
    }
    else if(item.localImage != nil)
    {
        self.image = item.localImage;
        item.originalSize = CGSizeMake(weakSelf.frame.size.width, weakSelf.frame.size.width * 1.0 * item.localImage.size.height / item.localImage.size.width);
        if(self.imageLoadedBlock != nil)
        {
            self.imageLoadedBlock();
        }
    }
    else if(![NSString isEmptyString:item.originURL])
    {
        [self sd_setImageWithURL:[NSURL URLWithString:item.originURL] placeholderImage:[UIImage imageNamed:@"default_pic"] options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            CGFloat progress = receivedSize * 1.0 / expectedSize;
            [SVProgressHUD showProgress:progress];
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [SVProgressHUD dismiss];
            item.originalSize = CGSizeMake(weakSelf.frame.size.width, weakSelf.frame.size.width * 1.0 * image.size.height / image.size.width);
            if(weakSelf.imageLoadedBlock != nil){
                weakSelf.imageLoadedBlock();
            }
        }];
    }
    
    
}
@end
