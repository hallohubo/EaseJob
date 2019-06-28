//
//  ThidViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "ThidViewController.h"

@interface ThidViewController ()

@end

@implementation ThidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpGetPageTask:1 type:@"2" typeId:HDSTR(self.typeID)];
    // 请进入 "BaseViewController"
}


@end
