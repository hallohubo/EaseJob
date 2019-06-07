//
//  HDMainVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDMainVC.h"
#import "HB3DScrollView.h"
#import "HBInformationCell.h"

#define BANNER_RATIO 0.557
#define BANNER_MODEL @"BANNER_MODEL"

@interface HDMainVC ()<UINavigationControllerDelegate>
{
    IBOutlet UILabel            *lbMessage;
    IBOutlet UIView             *vHeadView;
    IBOutlet UIPageControl      *pageControl;
    IBOutlet HB3DScrollView     *scv_banner;
    IBOutlet UIView             *vScrollviewContent;
    IBOutlet UIView             *vMessage;
    IBOutlet UITableView        *tbv;
    IBOutlet UIButton           *btnCheck;
    
    IBOutlet UIButton           *btnRegister;
    IBOutlet UIButton           *btnVote;
    IBOutlet UIButton           *btnAttention;
    IBOutlet UIButton           *btnBrowse;
    IBOutlet UIButton           *btnDownloa;
    IBOutlet UIButton           *btnforward;
    IBOutlet UIButton           *btnPost;
    IBOutlet UIButton           *btnComment;
    IBOutlet UIButton           *btnECommerce;
    IBOutlet UIButton           *btnAll;
    
    NSArray                     *ar_bannerList;
    NSMutableArray              *mar_pakageList;
    NSMutableArray              *marOrderList;
    NSMutableArray              *marHeadScrollImageList;

    
    NSURLSessionDataTask        *task;
    NSTimer                     *timer;
    HDHUD                       *hud;
    int                         needReload; //失败一次+1，<= 0不用重新请求
}

@end

@implementation HDMainVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setTableHead];
    [self setBannerView:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scv_banner.scrollEnabled = YES;
    if ([scrollView isEqual:scv_banner]) {
        if (scv_banner.currentPage == ar_bannerList.count + 1) {
            [scv_banner loadPageIndex:1 animated:NO];
        }
        if (scv_banner.currentPage == 0) {
            [scv_banner loadPageIndex:ar_bannerList.count animated:NO];
        }
        int i = scrollView.contentOffset.x / (HDDeviceSize.width - 6.);
        if (i > ar_bannerList.count + 1) {
            pageControl.currentPage = i - 2;
        }else{
            pageControl.currentPage = i-1;
        }
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:scv_banner]) {
        if (scv_banner.currentPage == ar_bannerList.count + 1) {
            [scv_banner loadPageIndex:1 animated:NO];
        }
        if (scv_banner.currentPage == 0) {
            [scv_banner loadPageIndex:ar_bannerList.count animated:NO];
        }
        int i = scrollView.contentOffset.x / (HDDeviceSize.width - 6.);
        if (i > ar_bannerList.count + 1) {
            pageControl.currentPage = i - 2;
        }else{
            pageControl.currentPage = i-1;
        }
        [self setAutoScrollStart];
        return;
    }else {
        scv_banner.scrollEnabled = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:tbv]) {
        scv_banner.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //    if (refresh.refreshHeader) {
    //        [refresh.refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    //    }
}
#pragma mark - 3DScrollView event

- (void)setAutoScrollStart
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
}

- (void)bannerScroll
{
    [scv_banner loadNextPage:YES];
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
    return section == 0 ? 60. :.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v60 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    v60.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (tableView.bounds.size.width-20), 60)];
    v1.backgroundColor = [UIColor whiteColor];
    
    [v60 addSubview:v1];
    [v1 makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(v60);
        //make.size.equalTo(v);
        make.left.equalTo(v60).offset(10);
        make.top.equalTo(v60).offset(0);
    }];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:v1.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = v1.bounds;
    maskLayer.path = maskPath.CGPath;
    v1.layer.mask = maskLayer;
    
    if (section == 0){
        UILabel *lbColum = [[UILabel alloc] init];
        [lbColum setBackgroundColor:HDCOLOR_RED];
        [v1 addSubview:lbColum];
        [lbColum makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.size.mas_equalTo(CGSizeMake(2, 20));
            make.left.equalTo(v1).offset(10);
        }];
        
        UILabel *lb = [[UILabel alloc] init];
        [lb setFont:HDFONT_TITLE];
        [lb setText:@"热门资讯"];
        [lb setBackgroundColor:[UIColor whiteColor]];
        [v1 addSubview:lb];
        [lb makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(v1).offset(20);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(loadMoreInformation)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"更多资讯" forState:UIControlStateNormal];
        [button setTintColor:[UIColor darkGrayColor]];
        button.frame = CGRectMake(0, 0, 100., 30.0);
        
        [v1 addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1.centerY);
            make.right.equalTo(v1.mas_right).offset(-20);        }];
        
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5., 9.)];
        [imv setImage:HDIMAGE(@"main_rightArrow")];
        [v1 addSubview:imv];
        [imv makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1.centerY);
            make.right.equalTo(v1.mas_right).offset(-10);
        }];

        [v60 updateConstraints];
    }

    return v60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBInformationCell";
    HBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBInformationCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = @"趣头条看新闻赚钱";
    cell.lbSubheading.text  = @"已抢4/15";
    cell.lbMoney.text = @"¥ +1.99元";
   
    return cell;
}

#pragma mark - Button event

- (void)loadMoreInformation
{
    
}

- (void)goBannerDetail:(UITapGestureRecognizer *)tap
{
    
}

- (IBAction)checkTaskDetail:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{//注册
            
            break;
        }
        case 1:{//投票
            
            break;
        }
        case 2:{//关注
            
            break;
        }
        case 3:{//浏览
            
            break;
        }
        case 4:{//下载
            
            break;
        }
        case 5:{//转发
            
            break;
        }
        case 6:{//发帖
            
            break;
        }
        case 7:{//评论
            
            break;
        }
        case 8:{//电商
            
            break;
        }
        case 9:{//全部
            
            break;
        }

        default:
            break;
    }
}

#pragma mark - Http event

- (void)httpGetBannerImages {
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:@{@"modulettype": HDSTR(@"2")}];
    task = [helper postPath:@"Act204" object:[HDBannerModel class] finished:^(HDError *error, id object, BOOL isLast, id json) {
        if (error) {
            needReload++;
            if (error.code != 0) {
                [HDHelper say:error.desc];
            }
            return ;
        }
        needReload = needReload > 0? (needReload - 1): 0;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:BANNER_MODEL];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ar_bannerList = object;
        if (ar_bannerList.count == 0) {
            return;
        }
        [self setBannerView:ar_bannerList];
    }];
}


#pragma mark - setter and getter

- (void)setup
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self
    
    scv_banner.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    pageControl.numberOfPages = ar_bannerList.count;
    needReload = 0;
    
    [vMessage addBorderWidth:.1f color:nil cornerRadius:5.0];    
}

- (void)setTableHead
{
    CGFloat height = 290 + (HDDeviceSize.width) * BANNER_RATIO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HDDeviceSize.width, height)];
    [v addSubview:vHeadView];
    [vHeadView makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(v);
        make.center.equalTo(v);
    }];
    
    tbv.tableHeaderView = v;
}

- (void)setBannerView:(NSArray *)ar
{
    for (int i = 0; i < scv_banner.subviews.count; i++) {
        UIView *v = scv_banner.subviews[i];
        [v removeFromSuperview];
        i = 0;
    }
    CGFloat height = (HDDeviceSize.width) * BANNER_RATIO;
    if (!ar || ar.count < 1) {
        HDBannerModel *mTemp0 = [HDBannerModel new];
        HDBannerModel *mTemp1 = [HDBannerModel new];
        HDBannerModel *mTemp2 = [HDBannerModel new];
        HDBannerModel *mTemp3 = [HDBannerModel new];
        
        mTemp0.ImageUrl = @"local";
        mTemp1.ImageUrl = @"local";
        mTemp2.ImageUrl = @"local";
        mTemp3.ImageUrl = @"local";
        ar_bannerList = @[mTemp0, mTemp1, mTemp2, mTemp3];
        ar = ar_bannerList;
    }
    pageControl.numberOfPages = ar.count;
    pageControl.hidesForSinglePage = YES;
    
    NSMutableArray *mar = [[NSMutableArray alloc] initWithArray:ar];
    [mar insertObject:[ar lastObject] atIndex:0];
    [mar addObject:[ar firstObject]];
    marHeadScrollImageList = [[NSMutableArray alloc] init];
    marHeadScrollImageList = mar;//used for geting the link when click image;
    
    scv_banner.contentSize = CGSizeMake((HDDeviceSize.width) * mar.count, 10.);
    [scv_banner loadPageIndex:1 animated:NO];
    
    for (int i = 0; i < mar.count; i++) {
        HDBannerModel *m = mar[i];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake((HDDeviceSize.width) * i, 0, HDDeviceSize.width, height)];
        if ([m.ImageUrl isEqualToString:@"local"]) {//取写死本地的数据
            [imv setImage:HDIMAGE(@"main_banner")];//
        }else{
            [imv sd_setImageWithURL:[NSURL URLWithString:m.ImageUrl] placeholderImage:HDIMAGE(@"main_banner")];
        }
        imv.userInteractionEnabled = YES;
        imv.contentMode     = UIViewContentModeScaleAspectFill;
        imv.clipsToBounds   = YES;
        imv.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBannerDetail:)];
        [imv addGestureRecognizer:tap];
        [scv_banner addSubview:imv];//ar_bannerList
    }
    [self setAutoScrollStart];
}
@end

@implementation HDBannerModel



@end