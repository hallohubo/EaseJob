//
//  NJBankCell.m
//  Destination
//
//  Created by TouchWorld on 2018/10/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJBankCell.h"
//#import "NJBankCardItem.h"

@interface NJBankCell ()
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@end
@implementation NJBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(NJBankCardItem *)item
{
    _item = item;
//    self.bankNameLabel.text = [NSString stringWithFormat:@"%@ %@", item.bank_name, item.bank_no];
}

@end
