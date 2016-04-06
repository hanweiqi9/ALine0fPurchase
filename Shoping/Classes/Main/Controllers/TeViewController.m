//
//  TeViewController.m
//  Shoping
//
//  Created by scjy on 16/4/6.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "TeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+Common.h"
#import "ProgressHUD.h"

@interface TeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) UITableView *tableviwe;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSDictionary *datasDic;

@end

@implementation TeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithImage:@"titlebarback"];

    [self getActivityDetailData];
    
    [self.view addSubview:self.tableviwe];
}
#pragma mark ========== 数据请求
- (void)getActivityDetailData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"加载中"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/discount/detail?cityId=%@&userId=&discountId=%@&longitude=112.426685&latitude=34.6187",self.cityID,self.trunId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        self.datasDic = dic[@"datas"];
        [self.tableviwe reloadData];
        [self setViewAction];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)setViewAction{
    NSArray *array = self.datasDic[@"otherPicUrls"];
    self.title = self.datasDic[@"brandNameEn"];
    if (array.count > 1) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight /3 - 30)];
        scrollView.contentSize = CGSizeMake(kWidth * array.count, kHeight /3-30);
        for (int i = 0; i < array.count; i++) {
            UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight /3-30)];
            [iamgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,array[i]]] placeholderImage:nil];
            [scrollView addSubview:iamgeView];
        }
        [self.headView addSubview:scrollView];
    }

    if (array.count == 1) {
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight /3-30)];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,array[0]]] placeholderImage:nil];
        [self.headView addSubview:iamgeView];
    }
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth /2 - kWidth /6 /2, kHeight /3-10, kWidth /6, kWidth /6)];
    icon.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.7];
    icon.layer.cornerRadius = 3;
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,self.datasDic[@"brandLogoUrl"]]] placeholderImage:nil];
    [self.headView addSubview:icon];

}
#pragma mark --------  代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStrings = @"cell";
    UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:cellStrings];
    if (cells == nil) {
        cells = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStrings];
    }
    for (UILabel *lable in cells.contentView.subviews) {
        [lable removeFromSuperview];
    }
    if (indexPath.row == 0) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        title.text = self.datasDic[@"brandNameEn"];
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentCenter;
        [cells.contentView addSubview:title];
    }
    if (indexPath.row == 1) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        name.text = self.datasDic[@"discountTitle"];
        name.textAlignment = NSTextAlignmentCenter;
        [cells.contentView addSubview:name];
    }
    if (indexPath.row == 2) {
        //有效期
        NSTimeInterval start =[ self.datasDic[@"beginDate"] integerValue] /1000;
        NSDateFormatter *matter = [[NSDateFormatter alloc] init];
        [matter setDateFormat:@"YYYY.MM.dd"];
        NSDate *timeSter = [NSDate dateWithTimeIntervalSince1970:start ];
        NSString *timeSting = [matter stringFromDate:timeSter];
        //结束
        NSTimeInterval end = [self.datasDic[@"endDate"]integerValue] / 1000;
        
        NSDate *timeEnd = [NSDate dateWithTimeIntervalSince1970:end];
        NSDateFormatter *endmatter = [[NSDateFormatter alloc] init];
        [endmatter setDateFormat:@"YYYY.MM.dd"];
        NSString *timeEndSting = [endmatter stringFromDate:timeEnd];
        
        NSString *timeLabels = [NSString stringWithFormat:@"有效期:%@至%@",timeSting,timeEndSting];
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        title1.text = timeLabels;
        title1.textColor = [UIColor redColor];
        title1.font = [UIFont systemFontOfSize:16.0];
        title1.textAlignment = NSTextAlignmentCenter;
        [cells.contentView addSubview:title1];
    }
    
    cells.backgroundColor = [UIColor clearColor];
    cells.selectionStyle = UITableViewCellSelectionStyleNone;
    return cells;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark --------  懒加载
- (UITableView *)tableviwe{
    if (_tableviwe == nil) {
        self.tableviwe = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableviwe.delegate = self;
        self.tableviwe.dataSource = self;
        self.tableviwe.rowHeight = 30;
        //隐藏滚动条
        self.tableviwe.showsVerticalScrollIndicator =
        NO;
        self.tableviwe.tableHeaderView = self.headView;
        self.tableviwe.separatorColor = [UIColor clearColor];
    }
    return _tableviwe;
}
- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight /3 + kWidth /6)];
    }
    return _headView;
}
- (NSDictionary *)datasDic{
    if (_datasDic == nil) {
        self.datasDic = [NSDictionary new];
    }
    return _datasDic;
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
