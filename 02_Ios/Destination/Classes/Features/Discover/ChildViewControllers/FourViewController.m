//
//  FourViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()

@end

@implementation FourViewController

#pragma mark = life cycle;

- (void)viewDidAppear:(BOOL)animated
{
    Dlog(@"----FourViewController viewWillAppear------:%@", HDSTR(HDGI.typeID));
    self.typeID = HDSTR(HDGI.typeID);
    self.type   = @"3";
    [self httpGetPageTask:1 type:self.type typeId:HDSTR(HDGI.typeID)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Dlog(@"----FourViewController viewDidLoad------:%@", self.typeID);
   
}


@end
