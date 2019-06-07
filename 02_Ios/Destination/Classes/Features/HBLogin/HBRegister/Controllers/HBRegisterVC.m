//
//  HBRegisterVC.m
//  Destination
//
//  Created by 胡勃 on 6/6/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBRegisterVC.h"

@interface HBRegisterVC ()
{
    IBOutlet UITextField    *tfPhone;
    IBOutlet UITextField    *tfPassword;
    IBOutlet UITextField    *tfValidation;
    IBOutlet UITextField    *tfInvite;
    IBOutlet UIButton       *btnValidation;
    IBOutlet UIButton       *btnRegister;
}

@end

@implementation HBRegisterVC


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - setter and getter

- (void)setup
{
    self.title = @"注册";
    [btnRegister addBorderWidth:.1 color:nil cornerRadius:25.];
}
@end
