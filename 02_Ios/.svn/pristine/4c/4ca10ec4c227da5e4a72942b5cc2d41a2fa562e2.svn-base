//
//  NJShareCardCell.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareCardCell.h"
#import "NJShareItem.h"
#import <SDImageCache.h>
#import "NJCIQRCodeTool.h"

@interface NJShareCardCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *linkView;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageV;
@property (weak, nonatomic) IBOutlet UIImageView *linkImageV;
@property (weak, nonatomic) IBOutlet UILabel *linkTitleLabel;

@end
@implementation NJShareCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageVClick)];
    [self.cardImageV addGestureRecognizer:tapGesture];
}



- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.contentView.backgroundColor = selected ? NJColor(239, 238, 243) : [UIColor whiteColor];
    self.selectBtn.selected = selected;
}

- (void)setType:(ShareCardType)type
{
    _type = type;
    self.cardView.hidden = type != ShareCardTypeImage;
    self.linkView.hidden = type != ShareCardTypeLink;
    self.titleLabel.text = type == ShareCardTypeImage ? @"卡片分享（点击预览）" : @"分享链接";
}

- (void)setShareItem:(NJShareItem *)shareItem
{
    _shareItem = shareItem;
    if(_type == ShareCardTypeImage)
    {
        if(shareItem.shareImage != nil)
        {
            self.cardImageV.image = shareItem.shareImage;
        }
        else
        {
            self.cardImageV.image = [UIImage imageNamed:@"side"];
        }
//        [self.cardImageV sd_setImageWithURL:[NSURL URLWithString:shareItem.shareImageURL] placeholderImage:[UIImage imageNamed:@"side"]];
    }
    else
    {
        [self.linkImageV sd_setImageWithURL:[NSURL URLWithString:shareItem.shareImageURL] placeholderImage:[UIImage imageNamed:@"side"]];
        self.linkTitleLabel.text = shareItem.title;
    }
}




- (void)cardImageVClick
{
    if(self.qrCodeBlock != nil)
    {
        self.qrCodeBlock();
    }
}

@end
