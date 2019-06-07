//
//  HDPhotoParameterVC.h
//  Destination
//
//  Created by hufan on 2019/4/19.
//Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJDiscoveryInfoItem.h"


@interface HDPhotoParameterView : UIViewController
@property(nonatomic,strong)NJDiscoveryInfoItem * discoveryInfoItem;
/********* <#注释#> *********/
@property(nonatomic,strong)NJDiscoveryImageItem * imageItem;
@property (nonatomic, strong) IBOutlet UIButton *btn_back;
@property (nonatomic, strong) IBOutlet UIButton *btn_head;
@property (nonatomic, strong) IBOutlet UIButton *btn_fold;
@property (nonatomic, strong) IBOutlet UIButton *btn_follow;
@property (nonatomic, strong) IBOutlet UIButton *btn_like;
@property (nonatomic, strong) IBOutlet UIButton *btn_comment;
@property (nonatomic, strong) IBOutlet UIButton *btn_share;
@property (weak, nonatomic) IBOutlet UILabel *lb_likeNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_commentNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_shareNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (nonatomic, weak) IBOutlet UILabel *lb_focal;
@property (nonatomic, weak) IBOutlet UILabel *lb_aperture;
@property (nonatomic, weak) IBOutlet UILabel *lb_flash;
@property (nonatomic, weak) IBOutlet UILabel *lb_iso;
@property (nonatomic, weak) IBOutlet UILabel *lb_wb;
@property (nonatomic, weak) IBOutlet UILabel *lb_shuter;
@property (nonatomic, weak) IBOutlet UILabel *lb_lens;
@property (nonatomic, weak) IBOutlet UILabel *lb_location;

@end
