//
//  HDDiscoverVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDDiscoverVC.h"
#import "HBDiscoverCell.h"
#import "HBDiscoverModel.h"


@interface HDDiscoverVC ()<UINavigationControllerDelegate>
{
    IBOutlet UITextField    *tfSearch;
    IBOutlet UIButton       *btnAll;
    IBOutlet UIButton       *btnSimple;
    IBOutlet UIButton       *btnHighPrice;
    IBOutlet UIButton       *btnVIP;
    IBOutlet UIView         *vSearch;
    IBOutlet UITableView    *tbv;
    NSArray                     *arBtn;
    NSURLSessionDataTask        *task;
    NSMutableArray              *marDiscoverList;
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
    return marDiscoverList.count;
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
    HBDiscoverModel *model = marDiscoverList[indexPath.section];
    
    cell.vBackground.layer.cornerRadius = 6.f;
    cell.vBackground.layer.masksToBounds= YES;
    
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = model.TaskTitle;
    NSString *strAmount = HDFORMAT(@"%@/%@", model.HasSaleNum, model.Quantity);
    cell.lbSubheading.text  = strAmount;
    cell.lbMoney.text = model.Commission;//@"¥ +1.99元";
    
    return cell;
}

#pragma mark - http event

- (void)httpGetRecentlyNews:(NSInteger)indexPage //获取前10条热门任务
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    task = [helper postPath:@"Act204" object:[HBDiscoverModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                if (error) {
                    if (error.code != 0 ) {
                        [HDHelper say:error.desc];
                    }
                    return ;
                }
                if (!object) {
                    return;
                }
                marDiscoverList = object;
                [tbv reloadData];
                
            }];
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

    [vSearch addBorderWidth:.1f color:nil cornerRadius:15.0];
    
    arBtn = @[btnAll, btnSimple, btnHighPrice, btnVIP];
}
@end
