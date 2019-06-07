//
//  HBInformationCell.h
//  Demo
//
//  Created by hubo on 2018/1/11.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBInformationCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView  *imvPhoto;
@property (nonatomic, strong) IBOutlet UILabel      *lbMainheading;
@property (nonatomic, strong) IBOutlet UILabel      *lbSubheading;
@property (nonatomic, strong) IBOutlet UILabel      *lbMoney;
@property (nonatomic, strong) IBOutlet UIView       *vBackground;
@end
