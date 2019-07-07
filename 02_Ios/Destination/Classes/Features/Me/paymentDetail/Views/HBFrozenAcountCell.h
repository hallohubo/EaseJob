//
//  HBFrozenAcountCell.h
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBFrozenAcountCell : UITableViewCell
@property (nonatomic, strong) IBOutlet  UILabel   *lbSerialNumber;
@property (nonatomic, strong) IBOutlet  UILabel   *lbType;
@property (nonatomic, strong) IBOutlet  UILabel   *lbTitle;
@property (nonatomic, strong) IBOutlet  UILabel   *lbFrozenAmount;
@property (nonatomic, strong) IBOutlet  UILabel   *lbFrozenMargin;
@property (nonatomic, strong) IBOutlet  UIImageView *imvPhoto;
@end

NS_ASSUME_NONNULL_END
