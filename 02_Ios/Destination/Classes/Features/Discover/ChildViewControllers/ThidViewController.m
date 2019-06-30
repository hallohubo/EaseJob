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

#pragma mark = life cycle;

- (void)viewWillAppear:(BOOL)animated
{
    Dlog(@"----ThidViewController viewWillAppear------:%@", HDSTR(HDGI.typeID));
    self.typeID = HDSTR(HDGI.typeID);
    self.type   = @"2";
    [self httpGetPageTask:1 type:self.type typeId:HDSTR(HDGI.typeID)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Dlog(@"----ThidViewController viewDidLoad------:%@", self.typeID);
}


@end
