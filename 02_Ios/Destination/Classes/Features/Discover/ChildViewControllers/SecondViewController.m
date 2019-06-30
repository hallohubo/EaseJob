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

#pragma mark = life cycle;

- (void)viewWillAppear:(BOOL)animated
{
    Dlog(@"----SecondViewController viewWillAppear------:%@", HDSTR(HDGI.typeID));
    self.typeID = HDSTR(HDGI.typeID);
    self.type   = @"1";
    [self httpGetPageTask:@"1"type:self.type typeId:HDSTR(HDGI.typeID)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    Dlog(@"----SecondViewController viewDidLoad------:%@", self.typeID);
    
}

@end
