//
//  HDDiscoverVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDDiscoverVC.h"
#import "HBDiscoverCell.h"


@interface HDDiscoverVC ()<UINavigationControllerDelegate>
{
    IBOutlet UITextField    *tfSearch;
    IBOutlet UIButton       *btnAll;
    IBOutlet UIButton       *btnSimple;
    IBOutlet UIButton       *btnHighPrice;
    IBOutlet UIButton       *btnVIP;
    IBOutlet UIView         *vSearch;
    IBOutlet UITableView    *tbv;
    NSArray     *arBtn;
}

@end

@implementation HDDiscoverVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBDiscoverCell";
    HBDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBDiscoverCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.vBackground.layer.cornerRadius = 6.f;
    cell.vBackground.layer.masksToBounds= YES;
    
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = @"趣头条看新闻赚钱";
    cell.lbSubheading.text  = @"已抢4/15";
    cell.lbMoney.text = @"¥ +1.99元";
    
    return cell;
}



#pragma mark - event

- (IBAction)btnSelect:(UIButton *)sender
{
    [self changeBtnStatus:sender];
    
}

#pragma mark - setter and getter

- (void)changeBtnStatus:(UIButton *)sender
{
    for (UIButton *btn in arBtn) {
        btn.selected = [btn isEqual:sender]? YES : NO;
    }
}

- (void)setup
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self
    
    vSearch.layer.cornerRadius = 15.f;
    vSearch.layer.masksToBounds= YES;
    
    arBtn = @[btnAll, btnSimple, btnHighPrice, btnVIP];
}
@end
