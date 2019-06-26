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

#import "SPPageMenu.h"
#import "BaseViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThidViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "SevenViewController.h"
#import "EightViewController.h"

#import "JSBadgeView.h"



@interface HDDiscoverVC ()<UINavigationControllerDelegate ,SPPageMenuDelegate, UIScrollViewDelegate>
{
    IBOutlet UITextField    *tfSearch;
    IBOutlet UIView         *vSearch;
    IBOutlet UITableView    *tbv;
    IBOutlet SPPageMenu     *vPageMenu;
    NSArray                     *arBtn;
    NSURLSessionDataTask        *task;
    NSMutableArray              *marDiscoverList;
}

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation HDDiscoverVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupPageMenuInit];
//    [self httpGetRecentlyNews:1];
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

- (void)httpGetRecentlyNews:(NSInteger)indexPage  //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          @"type": @"0",
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
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



#pragma mark - setter and getter

- (void)setup
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self

    [vSearch addBorderWidth:.1f color:nil cornerRadius:15.0];
}

- (void)setupPageMenuInit
{
    self.dataArr = @[@"生活",@"影视中心",@"交通",@"电视剧",@"搞笑",@"综艺"];
    
    // trackerStyle:跟踪器的样式
    CGRect frame = [vPageMenu convertRect:vPageMenu.bounds toView:self.view];
    Dlog(@"WINDowframe:%@", NSStringFromCGRect(frame));
    
    vPageMenu = [SPPageMenu pageMenuWithFrame:frame trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第2个
    [vPageMenu setItems:self.dataArr selectedItemIndex:1];
    // 设置代理
    vPageMenu.delegate = self;
    // 给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    vPageMenu.bridgeScrollView = tbv;
    [self.view addSubview:vPageMenu];
    
}
@end
