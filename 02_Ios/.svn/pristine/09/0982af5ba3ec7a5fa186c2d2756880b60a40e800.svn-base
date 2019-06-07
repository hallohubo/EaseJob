//
//  NJShareItemCell.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJShareItemCell.h"
#import "NJShareIconItem.h"
//#import <UIImageView+WebCache.h>
@interface NJShareItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation NJShareItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(NJShareIconItem *)item
{
    _item = item;
    
    self.iconImageV.image = [UIImage imageNamed:item.iconName];
    
    self.titleLabel.text = item.title;
}

@end
