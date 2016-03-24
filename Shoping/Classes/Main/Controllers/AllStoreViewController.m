//
//  AllStoreViewController.m
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
/*
 http://api.gjla.com/app_admin_v400/api/coupon/storeList?cityId=391db7b8fdd211e3b2bf00163e000dce&couponId=ea6731a3ead46325d297b1229d81c654&brandId=c68f79a234b711e4998d00163e0200e5&longitude=112.426777&latitude=34.618741&pageNum=1&pageSize=4&audit=
 */
#import "AllStoreViewController.h"
#import "StoreAllTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+Common.h"

@interface AllStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation AllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ self showBackButtonWithImage:@"arrow_left_pink"];

    [self.tableView registerNib:[UINib nibWithNibName:@"StoreAllTableViewCell" bundle:nil] forCellReuseIdentifier:@"allCell"];
    [self allStroeData];
    [self.view addSubview:self.tableView];
}
#pragma mark ---------数据
- (void)allStroeData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/storeList?cityId=391db7b8fdd211e3b2bf00163e000dce&couponId=ea6731a3ead46325d297b1229d81c654&brandId=%@&longitude=112.426777&latitude=34.618741&pageNum=1&pageSize=4&audit=",self.storeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *group = dic[@"datas"];
        for (NSDictionary *dics in group) {
            [self.cellArray addObject:dics];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
 
}
#pragma mark ---------代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCell" forIndexPath:indexPath];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,self.cellArray[indexPath.row][@"storePicUrl"]]] placeholderImage:nil];
    cell.iconView.layer.cornerRadius = 2;
    cell.titleLable.text = self.cellArray[indexPath.row][@"storeName"];
    cell.storeAddress.text = self.cellArray[indexPath.row][@"storeAddress"];
    CGFloat dis = [self.cellArray[indexPath.row][@"distance"] floatValue] /1000;
    cell.distanceL.text = [NSString stringWithFormat:@"%.2fkm",dis];
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}



#pragma mark ---------懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight ) style:UITableViewStylePlain ];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 100;
        //隐藏滚动条
        self.tableView.showsVerticalScrollIndicator =
        NO;
    }
    return _tableView;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        self.cellArray = [NSMutableArray new];
    }
    return _cellArray;
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
