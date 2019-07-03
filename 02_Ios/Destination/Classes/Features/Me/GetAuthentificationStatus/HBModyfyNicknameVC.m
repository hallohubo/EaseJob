//
//  HBModyfyAvatarVC.m
//  Destination
//
//  Created by 胡勃 on 7/3/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBModyfyNicknameVC.h"

@interface HBModyfyNicknameVC ()
{
    IBOutlet UITextField *tf_;
    NSURLSessionDataTask *task;
    NSString *title;
    NSString *defaultValue;
}

@end

@implementation HBModyfyNicknameVC

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
    }
    
    NSDictionary *dic = @{@"nickName" : tf_.text,
                          };
    [self httpCommitMyProfile:dic];

}

#pragma mark - http event

- (void)httpCommitMyProfile:(NSDictionary *)personalData{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:personalData];
    
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act118" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        
        [NJProgressHUD showSuccess:@"保存成功"];
        [NJProgressHUD dismissWithDelay:1.2];
        
        if (self.HBModifyMyInformationBlock) {
            self.HBModifyMyInformationBlock(tf_.text);
        }

    }];
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
