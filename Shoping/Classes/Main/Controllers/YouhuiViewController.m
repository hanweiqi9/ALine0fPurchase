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

@interface YouhuiViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL isRefresh;
}
@property (nonatomic, strong) PullingRefreshTableView *pullTbaleView;
@property (nonatomic, strong) NSMutableArray *YouArray;
@end

@implementation YouhuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"arrow_left_pink"];
    
    [self.view addSubview:self.pullTbaleView];
    //注册cell
    [self.pullTbaleView registerNib:[UINib nibWithNibName:@"YouhuiTableViewCell"  bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getYouData];
}
#pragma mark ------------- 数据请求
- (void)getYouData{
    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc] init];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manage GET:@"http://api.gjla.com/app_admin_v400/api/coupon/exclusiveCouponList?pageSize=10&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *root = responseObject;
        NSArray *datas = root[@"datas"];
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
      NSLog(@"%ld",indexPath.row);
//    if (indexPath.row < self.YouArray.count) {
//    
//        NSString *sting = [NSString stringWithFormat:@"%@%@",kImageString,self.YouArray[indexPath.row][@"picUrl"]];
//      NSLog(@"%ld",indexPath.row);
//        [cell.IconImageView sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
//        cell.titleLable.text = self.YouArray[indexPath.row][@"couponName"];
//        NSString *price = self.YouArray[indexPath.row][@"couponType"] ;
//        if ([price integerValue] == 1) {
//            
//            cell.priceLable.text = self.YouArray[indexPath.row][@"costPrice"];
//        }
//        else{
//            cell.priceLable.text = @"免费" ;
//        }

//    }
    cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
}

#pragma mark ------------- 懒加载
-(PullingRefreshTableView *)pullTbaleView{
    if (_pullTbaleView == nil) {
        _pullTbaleView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) pullingDelegate:self];
        self.pullTbaleView.dataSource = self;
        self.pullTbaleView.delegate = self;
        self.pullTbaleView.rowHeight = kHeight/2-30;
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
