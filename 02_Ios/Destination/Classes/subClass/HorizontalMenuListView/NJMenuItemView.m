//
//  NJMenuItemView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/17.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJMenuItemView.h"
@interface NJMenuItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)menuClick:(UITapGestureRecognizer *)sender;

@end
@implementation NJMenuItemView

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.iconImageV.image = [UIImage imageNamed:dataDic[@"img"]];
    self.titleLabel.text = dataDic[@"title"];
}

- (IBAction)menuClick:(UITapGestureRecognizer *)sender {
    
    if(self.didSelectedBlock != nil)
    {
        self.didSelectedBlock(self.row);
    }
}
@end
