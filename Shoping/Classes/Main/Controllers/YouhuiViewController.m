//
//  YouhuiViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
/*
 http://api.gjla.com/app_admin_v400/api/coupon/exclusiveCouponList?pageSize=10&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1
 */
#import "YouhuiViewController.h"
#import "PullingRefreshTableView.h"
#import "YouhuiTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+Common.h"
#import "ActivityMianViewController.h"

@interface YouhuiViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger _pageNum;
}
@property (nonatomic, strong) PullingRefreshTableView *pullTbaleView;
@property (nonatomic, strong) NSMutableArray *YouArray;
@property (nonatomic, assign) BOOL Refreshing;
@end

@implementation YouhuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"arrow_left_pink"];
    
    [self.view addSubview:self.pullTbaleView];
    [self.pullTbaleView launchRefreshing];
    //注册cell
    [self.pullTbaleView registerNib:[UINib nibWithNibName:@"YouhuiTableViewCell"  bundle:nil] forCellReuseIdentifier:@"cell"];
    _pageNum = 1;
    [self getYouData];
}
#pragma mark ------------- 数据请求
- (void)getYouData{
    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] init];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manage GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/exclusiveCouponList?pageSize=10&cityId=%@&pageNum=%ld",self.cityId,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *root = responseObject;
        NSArray *datas = root[@"datas"];
        if (self.Refreshing) {
            if (self.YouArray.count > 0) {
                [self.YouArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in datas) {
            [self.YouArray addObject:dic];
        }
        [self.pullTbaleView reloadData];
        [self.pullTbaleView tableViewDidFinishedLoading];
        self.pullTbaleView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark ------------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YouhuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.YouArray.count > 0) {
        NSString *sting = [NSString stringWithFormat:@"%@%@",kImageString,self.YouArray[indexPath.row][@"picUrl"]];
        [cell.IconImageView sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
        cell.titleLable.text = self.YouArray[indexPath.row][@"couponName"];
        NSNumber *price = self.YouArray[indexPath.row][@"costPrice"] ;
        if ([price isEqual: @(0)]) {
            cell.priceLable.text = @"免费" ;
        }
        else{
            NSString *priceString = self.YouArray[indexPath.row][@"costPrice"];
            cell.priceLable.text = [NSString stringWithFormat:@"￥%@",priceString];
        }
    }
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.YouArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityMianViewController *activityMianVC = [[ActivityMianViewController alloc] init];
    activityMianVC.title = self.YouArray[indexPath.row][@"couponName"];
    activityMianVC.cityID = self.cityId;
    activityMianVC.trunId = self.YouArray[indexPath.row][@"couponId"];
    [self.navigationController pushViewController:activityMianVC animated:YES];
    
}
#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.Refreshing = YES;
    _pageNum = 1;
    [self performSelector:@selector(getYouData) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.Refreshing = NO;
    _pageNum +=1;
    [self performSelector:@selector(getYouData) withObject:nil afterDelay:1.0];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pullTbaleView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pullTbaleView tableViewDidEndDragging:scrollView];
}


#pragma mark ------------- 懒加载
-(PullingRefreshTableView *)pullTbaleView{
    if (_pullTbaleView == nil) {
        _pullTbaleView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight) pullingDelegate:self];
        self.pullTbaleView.dataSource = self;
        self.pullTbaleView.delegate = self;
        self.pullTbaleView.rowHeight = kHeight/3+20;
        self.pullTbaleView.separatorColor = [UIColor clearColor];
        //隐藏滚动条
//        self.pullTbaleView.showsVerticalScrollIndicator =
//        NO;
    }
    return _pullTbaleView;
}

- (NSMutableArray *)YouArray{
    if (_YouArray == nil) {
        _YouArray = [NSMutableArray new];
    }
    return _YouArray;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
