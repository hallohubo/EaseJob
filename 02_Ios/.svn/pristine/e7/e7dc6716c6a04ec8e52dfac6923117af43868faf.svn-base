//
//  NJShareView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJShareCardListView.h"

@class NJShareItem;
NS_ASSUME_NONNULL_BEGIN

@interface NJShareView : UIView
+ (instancetype)sharedInstance;

- (void)show;

- (void)dismiss;

/********* 类型 *********/
@property(nonatomic,assign)ShareCardType type;

/********* <#注释#> *********/
@property(nonatomic,strong)NJShareItem * shareItem;

@property(nonatomic,strong) NSString *shareFlag;

/********* <#注释#> *********/
@property(nonatomic,copy)void (^qrCodeBlock)(void);

/********* 要分享的含有二维码的图片 *********/
@property(nonatomic,copy)UIImage * shareQrcodeImage;

/********* 隐藏回调 *********/
@property(nonatomic,copy)void (^dismissBlock)(void);
@property(nonatomic,copy)void (^shareFinishBlock)(BOOL isSuccess, NSString *shareFlag);


//@property(nonatomic,strong)NJDiscoveryInfoItem *discoveryInfoItem;
@property(nonatomic,strong)NSNumber * p_id;
@property(nonatomic,assign)NSInteger tags;

//@property(nonatomic,strong)NSIndexPath * indexs;
@end

NS_ASSUME_NONNULL_END
