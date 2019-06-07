//
//  NJShareView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareView.h"
#import "NJShareListView.h"
#import "NJShareItem.h"
#import <ShareSDK/ShareSDK.h>
#import "NJShareImageBottomView.h"
#import "NJCIQRCodeTool.h"
#import <SDWebImageDownloader.h>

#define containerViewHeight (408 + HOME_INDICATOR_HEIGHT)
@interface NJShareView ()
/********* containerView *********/
@property(nonatomic,weak)UIView * containerView;

/********* <#注释#> *********/
@property(nonatomic,weak)NJShareCardListView * shareCardListView;
/********* <#注释#> *********/
@property(nonatomic,weak)NJShareImageBottomView * placeholderView;
@end
@implementation NJShareView
static NJShareView * shared;

+ (instancetype)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[NJShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return shared;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if(newWindow != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createShareImage];
        });
    }
}


#pragma mark - 设置初始化
- (void)setupInit
{
    self.backgroundColor = NJGrayColorAlpha(0, 0);
    
    UIView * bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
    
    [self setupContainerView];
    
}

#pragma mark - containerView
- (void)setupContainerView
{
    HDWeakSelf;
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(containerViewHeight);
        make.height.mas_equalTo(containerViewHeight);
    }];
    
    
    self.containerView = containerView;
    containerView.backgroundColor = NJGrayColor(126);
    
    //卡片分享图片，底部view
    NJShareImageBottomView * placeholderView = [NJShareImageBottomView NJ_loadViewFromXib];
    [containerView addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(88);
    }];
    self.placeholderView = placeholderView;
    
    //遮挡卡片分享图片的背景view
    UIView * bgView = [[UIView alloc] init];
    [containerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(containerView);
    }];
    
    bgView.backgroundColor = NJGrayColor(126);
    
    NJShareCardListView * shareCardListView = [[NJShareCardListView alloc] init];
    [containerView addSubview:shareCardListView];
    [shareCardListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(236);
    }];
    
    self.shareCardListView = shareCardListView;
    shareCardListView.backgroundColor = [UIColor whiteColor];
    shareCardListView.qrCodeBlock = ^{
        if(weakSelf.qrCodeBlock != nil)
        {
            weakSelf.qrCodeBlock();
        }
    };
    
    
    NJShareListView * shareListView = [[NJShareListView alloc] init];
    [containerView addSubview:shareListView];
    [shareListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerView);
        make.top.mas_equalTo(shareCardListView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(120);
    }];
    
    shareListView.shareBlock = ^(ShareType type) {
        [weakSelf shareClick:type];
    };
    
    shareListView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView * cancelView = [[UIView alloc] init];
    [self addSubview:cancelView];
    [cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shareListView.mas_bottom).mas_offset(1);
        make.left.right.bottom.mas_equalTo(containerView);
    }];
    
    cancelView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cancelView).insets(UIEdgeInsetsMake(0, 0, HOME_INDICATOR_HEIGHT, 0));
    }];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 事件
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    //动画开始前，强制刷新
    [self layoutIfNeeded];
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
 
    [UIView animateWithDuration:0.3 animations:^{
        //在动画中，强制刷新，产生动画效果
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0.4);
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHARE_SUCCESS object:@{}];

    }];
    
}

- (void)dismiss{
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(containerViewHeight);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.dismissBlock != nil){
            self.dismissBlock();
        }
    }];
    
}


- (void)cancelBtnClick:(UIButton *)cancenBtn
{
    [self dismiss];
}

- (void)setType:(ShareCardType)type
{
    _type = type;
    
    self.shareCardListView.type = type;
}

- (void)setShareItem:(NJShareItem *)shareItem
{
    _shareItem = shareItem;
    self.shareCardListView.shareItem = shareItem;
    self.placeholderView.shareItem = shareItem;
}

- (void)shareClick:(ShareType)type
{
    HDWeakSelf;
    ShareCardType cardType = self.shareCardListView.selectedType;
    NJShareItem * shareItem = self.shareCardListView.shareItem;
    SSDKPlatformType platformType;
    switch (type) {
        case ShareTypeWeChat://微信
        {
            platformType = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case ShareTypeFriendCircle://朋友圈
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case ShareTypeWeibo://微博
        {
            platformType = SSDKPlatformTypeSinaWeibo;
        }
            break;
        case ShareTypeQQ://QQ
        {
            platformType = SSDKPlatformSubTypeQQFriend;
        }
            break;
        case ShareTypeZone://QQ空间
        {
            platformType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        default:
        {
            platformType = SSDKPlatformTypeWechat;
        }
            break;
    }
    
    NSMutableDictionary * shareParames = [NSMutableDictionary dictionary];
    if(cardType == ShareCardTypeImage)
    {
        [shareParames SSDKSetupShareParamsByText:nil images:shareItem.shareImage url:nil title:nil type:SSDKContentTypeImage];
    }
    else
    {
//        NSString * path = [NSString stringWithFormat:@"Photography/share_photography?p_id=%@", [shareItem.p_id stringValue]];
//
//        NSString * shareURL = [NJPathPrefix stringByAppendingPathComponent:path];
        NSString * shareText = [NSString isEmptyString:shareItem.detailTitle] ? @"摄影师想阐述的理念都在图片里了，不点进来看看嘛？" : shareItem.detailTitle;
//        NSString * shareURL = shareItem.shareURL;
         NSString * shareURL = shareItem.shareAbsoluteURL;
        [shareParames SSDKSetupShareParamsByText:shareText images:shareItem.shareImageURL url:[NSURL URLWithString:shareURL] title:shareItem.title type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:platformType parameters:shareParames onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        BOOL isSuc = NO;
        if(state == SSDKResponseStateSuccess){
            HDLog(@"分享成功");
            [weakSelf dismiss];
            isSuc = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SHARE_SUCCESS object:nil];
        }else{
            HDLog(@"%@", error);
        }
        if (self.shareFinishBlock) {
            self.shareFinishBlock(isSuc, self.shareFlag);
        }
    }];
}

//创建分享图片
- (void)createShareImage
{
    HDWeakSelf;
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    if(![imageCache diskImageDataExistsWithKey:self.shareItem.shareImageURL])
    {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.shareItem.shareImageURL] options:kNilOptions progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [weakSelf getShareImage];
        }];
    }
    
    [self getShareImage];
    
}

- (void)getShareImage
{
    UIImage * discoverImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:_shareItem.shareImageURL];
    if(discoverImage == nil){
        return;
    }
    CGFloat bottomViewHeight = 88.0;
    CGFloat shareImageWidth = HDDeviceSize.width;
    CGFloat discoverImageHeight = shareImageWidth * discoverImage.size.height / discoverImage.size.width;
    CGFloat shareImageHeight = discoverImageHeight + bottomViewHeight;
    
    //开启图像上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(shareImageWidth, shareImageHeight), NO, 0.0);
    
    [self.placeholderView drawViewHierarchyInRect:CGRectMake(0, shareImageHeight - bottomViewHeight, shareImageWidth, bottomViewHeight) afterScreenUpdates:NO];
    [discoverImage drawInRect:CGRectMake(0, 0, shareImageWidth, discoverImageHeight)];
    
    UIImage * shareImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图像上下文
    UIGraphicsEndImageContext();
    self.shareQrcodeImage = shareImage;
    self.shareItem.shareImage = shareImage;
    self.shareCardListView.shareItem = self.shareItem;
    
}

@end
