//
//  HBCommissionBalanceCell.h
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBCommissionBalanceCell : UITableViewCell
@property (nonatomic, strong) IBOutlet  UILabel   *lbTitle;
@property (nonatomic, strong) IBOutlet  UILabel   *lbDetail;
@property (nonatomic, strong) IBOutlet  UILabel   *lbNote;
@property (nonatomic, strong) IBOutlet  UILabel   *lbAmount;
@end

NS_ASSUME_NONNULL_END
