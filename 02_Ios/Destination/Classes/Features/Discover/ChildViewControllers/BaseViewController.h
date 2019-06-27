//
//  BaseViewController.h
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSMutableArray  *marList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *type;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (void)httpGetPageTask:(NSInteger)indexPage type:(NSString *)type;
@end
