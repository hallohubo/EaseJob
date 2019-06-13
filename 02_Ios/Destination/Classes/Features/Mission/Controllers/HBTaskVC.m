//
//  HBTaskVC.m
//  Destination
//
//  Created by 胡勃 on 6/13/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBTaskVC.h"

@interface HBTaskVC ()
{
    IBOutlet UIButton       *btnReceivedNotPaid;    //已接不垫付
    IBOutlet UIButton       *btnReceivedPrepaid;    //已接垫付
    IBOutlet UIButton       *btnIssuedNotPaid;      //已发布不垫付
    IBOutlet UIButton       *btnIssuedPrepaid;      //已发布垫付
    
    IBOutlet UILabel        *lbReceivedNotPaid;
    IBOutlet UILabel        *lbReceivedPrepaid;
    IBOutlet UILabel        *lbIssuedNotPaid;
    IBOutlet UILabel        *lbIssuedPrepaid;
    
    IBOutlet UIView         *v0;
    IBOutlet UIView         *v1;
    IBOutlet UIView         *v2;
    IBOutlet UIView         *v3;
}

@end

@implementation HBTaskVC

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
    self.title = @"任务";
    
    v0 = [v0 addDottedBorderWithView:v0 LineWidth:1.0f lineColor:RGB(136, 136, 136)];
    v1 = [v1 addDottedBorderWithView:v1 LineWidth:1.0f lineColor:RGB(136, 136, 136)];
    v2 = [v2 addDottedBorderWithView:v2 LineWidth:1.0f lineColor:RGB(136, 136, 136)];
    v3 = [v3 addDottedBorderWithView:v3 LineWidth:1.0f lineColor:RGB(136, 136, 136)];
}

@end
