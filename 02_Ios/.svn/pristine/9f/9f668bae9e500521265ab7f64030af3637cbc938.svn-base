//
//  NJShareImageBottomView.m
//  Destination
//
//  Created by TouchWorld on 2018/12/26.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareImageBottomView.h"
#import "NJShareItem.h"
#import "NJCIQRCodeTool.h"

@interface NJShareImageBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageV;

@end

@implementation NJShareImageBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.iconImageV addAllCornerRadius:10.0];
    self.iconImageV.layer.masksToBounds = YES;
}

- (void)setShareItem:(NJShareItem *)shareItem
{
    _shareItem = shareItem;
    
    self.titleLabel.text = shareItem.title;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:shareItem.icon] placeholderImage:[UIImage imageNamed:@"side"]];
    self.nickNameLabel.text = shareItem.nickname;

    CGFloat qrCodeImageWidth = 65.0;
    UIImage * qrCodeImage = [NJCIQRCodeTool QRCodeGenerator:shareItem.shareAbsoluteURL centerImage:nil withSize:qrCodeImageWidth];
    
    self.qrCodeImageV.image = qrCodeImage;
}

@end
