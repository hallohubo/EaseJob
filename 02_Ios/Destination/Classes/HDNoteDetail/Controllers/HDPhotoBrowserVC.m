//
//  HDPhotoBrowserVC.m
//  Destination
//
//  Created by hufan on 2019/5/5.
//Copyright © 2019 Redirect. All rights reserved.
//

#import "HDPhotoBrowserVC.h"

@interface HDPhotoBrowserVC (){
    NSURLSessionDataTask *task;
    HDHUD *hud;
}

@property (nonatomic, strong) NSArray *photos;

@end

@implementation HDPhotoBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    task = nil;
    [hud hiden];
    hud = nil;
}

#pragma mark - event
- (void)http{
   
}


#pragma mark - setter
- (void)setup{
    self.title = @"";

}


@end
