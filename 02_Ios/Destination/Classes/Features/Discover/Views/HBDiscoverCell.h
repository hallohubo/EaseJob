//
//  HBDiscoverCell.h
//  Destination
//
//  Created by 胡勃 on 6/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBDiscoverCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView  *imvPhoto;
@property (nonatomic, strong) IBOutlet UILabel      *lbMainheading;
@property (nonatomic, strong) IBOutlet UILabel      *lbSubheading;
@property (nonatomic, strong) IBOutlet UILabel      *lbMoney;
@property (nonatomic, strong) IBOutlet UIView       *vBackground;
@end

NS_ASSUME_NONNULL_END
