//
//  SecondViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpGetPageTask:1 type:@"1" typeId:HDSTR(self.typeID)];

    // 请进入 "BaseViewController"
}

@end
