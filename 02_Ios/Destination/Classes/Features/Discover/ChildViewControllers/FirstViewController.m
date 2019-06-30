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

#pragma mark = life cycle;

- (void)viewWillAppear:(BOOL)animated
{
    Dlog(@"----FirstViewController viewWillAppear------:%@", HDSTR(HDGI.typeID));
    self.typeID = HDSTR(HDGI.typeID);
    self.type = @"0";
    [self httpGetPageTask:1 type:self.type typeId:self.typeID];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 请进入 "BaseViewController"
}



@end
