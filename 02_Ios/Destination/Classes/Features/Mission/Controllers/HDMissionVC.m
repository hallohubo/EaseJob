//
//  HDMIssionVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDMissionVC.h"

@interface HDMissionVC ()
{
    IBOutlet UIButton       *btnReceivedNotPaid;    //已接不垫付
    IBOutlet UIButton       *btnReceivedPrepaid;    //已接垫付
    IBOutlet UIButton       *btnIssuedNotPaid;      //已发布不垫付
    IBOutlet UIButton       *btnIssuedPrepaid;      //已发布垫付
    
    IBOutlet UILabel        *lbReceivedNotPaid;
    IBOutlet UILabel        *lbReceivedPrepaid;
    IBOutlet UILabel        *lbIssuedNotPaid;
    IBOutlet UILabel        *lbIssuedPrepaid;
}

@end

@implementation HDMissionVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark - UI event

- (IBAction)touchButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - setter and getter

- (void)setup
{
    self.title = @"任";
    [btnIssuedNotPaid addDottedBorderWithLineWidth:1.f lineColor:RGB(134, 136, 137)];
    [btnIssuedPrepaid addDottedBorderWithLineWidth:1.f lineColor:RGB(134, 136, 137)];
    [btnReceivedNotPaid addDottedBorderWithLineWidth:1.f lineColor:RGB(134, 136, 137)];
    [btnReceivedPrepaid addDottedBorderWithLineWidth:1.f lineColor:RGB(134, 136, 137)];
}

@end
