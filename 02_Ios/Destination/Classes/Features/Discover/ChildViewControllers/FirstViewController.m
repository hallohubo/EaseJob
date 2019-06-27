//
//  FirstViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "FirstViewController.h"
#import "HBDiscoverModel.h"

@interface FirstViewController ()
{
    }

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpGetPageTask:1 type:@"0"];

    // 请进入 "BaseViewController"
}



@end
