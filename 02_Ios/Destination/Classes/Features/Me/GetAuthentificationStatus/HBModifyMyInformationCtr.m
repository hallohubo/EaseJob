//
//  HBModifyMyInformationCtr.m
//  Demo
//
//  Created by hubo on 2017/11/28.
//Copyright © 2017年 hufan. All rights reserved.
//

#import "HBModifyMyInformationCtr.h"

@interface HBModifyMyInformationCtr (){
    IBOutlet UITextField *tf_;
    NSURLSessionDataTask *task;
    NSString *title;
    NSString *defaultValue;
}
@end

@implementation HBModifyMyInformationCtr


- (instancetype)initWithTitle:(NSString *)tile defaultValue:(NSString *)value
{
    self = [super init];
    if (self) {
        title = tile;
        defaultValue = value;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    task = nil;
}

#pragma mark - event

- (void)save:(id)sender
{
    if (!(tf_.text.length > 0)) {
        [LBXAlertAction sayWithTitle:@"提示" message:@"输入的内容不能为空" buttons:@[ @"确认"] chooseBlock:nil];
        return;
    }else if (self.HBModifyMyInformationBlock) {
        self.HBModifyMyInformationBlock(tf_.text);
    }
}

#pragma mark - setter
- (void)setup
{
    self.title      = title;
    tf_.text        = defaultValue;
    tf_.placeholder = title;
    [tf_ becomeFirstResponder];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    [anotherButton setTintColor:HDCOLOR_WHITE];
    self.navigationItem.rightBarButtonItem  = anotherButton;
}

@end


