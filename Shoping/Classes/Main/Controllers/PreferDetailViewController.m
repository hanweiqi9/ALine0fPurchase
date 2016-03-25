//
//  PreferDetailViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "PreferDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+Common.h"
#import "NearTableViewCell.h"
#import "ProgressHUD.h"
#import "ActivityMianViewController.h"
#import "MapViewController.h"
#import "MangoSingleton.h"
@interface PreferDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *DetailsTableView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSDictionary *datasDic;
@property (nonatomic, strong) NSMutableArray *cellArray;
@end

@implementation PreferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self showBackButtonWithImage:@"titlebarback"];
    [self.view addSubview:self.DetailsTableView];
    
    [self.DetailsTableView registerNib:[UINib nibWithNibName:@"NearTableViewCell" bundle:nil] forCellReuseIdentifier:@"preferCell"];
    
    
    [self getActivityDetailData];
}
#pragma mark ========== 数据请求
- (void)getActivityDetailData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"加载中"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/discount/detail?cityId=391db7b8fdd211e3b2bf00163e000dce&userId=c649ac4bf87f43fea924f52a2639e533&discountId=%@&longitude=112.426796&latitude=34.618748",self.preferId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        self.datasDic = dic[@"datas"];
        NSArray *array =self.datasDic[@"couponOrDiscounts"];
        for (NSDictionary *dics in array) {
            [self.cellArray addObject:dics];

        }
        [self.DetailsTableView reloadData];
        [self settingHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark ========== 设置区头
- (void)settingHeadView{
    NSArray *array = self.datasDic[@"otherPicUrls"];
    if (array.count > 1) {
        self.headView.frame = CGRectMake(0, 0, kWidth,kHeight /3+kWidth /6 + kHeight /20 *7+15);
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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /2 - kWidth /3/2 , kHeight /3-10+kWidth /6, kWidth /3, kHeight /20)];
    title.font = [UIFont systemFontOfSize:14.0];
    title.text = self.datasDic[@"brandNameEn"];
    title.textColor = [UIColor grayColor];
    //    title.backgroundColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:title];
    
    UILabel *enTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /8, kHeight /3-10+kWidth /6+kHeight /20, kWidth-kWidth/8*2 , kHeight /20)];
    //    enTitle.backgroundColor = [UIColor cyanColor];
    enTitle.text = self.datasDic[@"discountTitle"];
    enTitle.font = [UIFont systemFontOfSize:18.0];
    enTitle.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:enTitle];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 ,kHeight /3-10+kWidth /6 + kHeight /20 *2, kWidth- kWidth / 8 * 2, kHeight /20)];
    //时间日期转换
    //开始日期
    NSTimeInterval start =[ self.datasDic[@"beginDate"] integerValue] /1000;
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"YYYY/MM/dd"];
    NSDate *timeSter = [NSDate dateWithTimeIntervalSince1970:start ];
    NSString *timeSting = [matter stringFromDate:timeSter];
    //结束
    NSTimeInterval end = [self.datasDic[@"endDate"]integerValue] / 1000;
    
    NSDate *timeEnd = [NSDate dateWithTimeIntervalSince1970:end];
    NSDateFormatter *endmatter = [[NSDateFormatter alloc] init];
    [endmatter setDateFormat:@"YYYY/MM/dd"];
    NSString *timeEndSting = [endmatter stringFromDate:timeEnd];
    
    NSString *timeLabels = [NSString stringWithFormat:@"有效期:%@至%@",timeSting,timeEndSting];
    price.text = timeLabels;
    price.font = [UIFont systemFontOfSize:16.0];
    price.textColor = [UIColor redColor];
    price.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:price];
    NSString *name = self.datasDic[@"mallName"];
    NSString *dis = self.datasDic[@"distance"];
    NSString *wei = self.datasDic[@"address"];
    
    if ([name isEqual:[NSNull null]] && [dis isEqual:[NSNull null]] &&[wei isEqual:[NSNull null]]) {
        CGFloat height = kHeight /3-10+kWidth /6 + kHeight /20 *3;
        CGRect frame = self.headView.frame;
        frame.size.height = height;
        self.headView.frame = frame;
    }
    else{
        
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 8 ,kHeight /3+kWidth /6 + kHeight /20 *4, kWidth - kHeight / 8, 0.5)];
        titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
        [self.headView addSubview:titleView
         ];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight /3+kWidth /6 + kHeight /20 *3+15, kWidth/5,kHeight/20)];
        
        titleL.text = @"适用门店";
        
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor whiteColor];
        titleL.font = [UIFont systemFontOfSize:15.0];
        [self.headView addSubview:titleL];
        
        
        UILabel *eTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/8 , kHeight /3+kWidth /6 + kHeight /20 *4+15, kWidth - kWidth /8*2, kHeight /20)];
        //        eTitle.backgroundColor = [UIColor redColor];
        eTitle.font = [UIFont systemFontOfSize:15.0];
        eTitle.textAlignment = NSTextAlignmentCenter;
        [self.headView addSubview:eTitle];
        
        
        UIButton *distance = [UIButton buttonWithType:UIButtonTypeCustom];
        distance.frame = CGRectMake(kWidth / 3, kHeight /3+kWidth /6 + kHeight /20 *5+15, kWidth /3, kHeight /20);
        [distance setImage:[UIImage imageNamed:@"address_i1"] forState:UIControlStateNormal];
        [distance setImageEdgeInsets:UIEdgeInsetsMake(2,2,2,5)];
        [distance setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 2)];
        [distance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        distance.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.headView addSubview:distance];
        
        //位置
        UIButton *weizhi = [UIButton buttonWithType:UIButtonTypeCustom];
        weizhi.frame = CGRectMake(kWidth /6 ,kHeight /3+kWidth /6 + kHeight /20 *6+15, kWidth - kWidth /3, kHeight /20);
        [weizhi setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
        [weizhi setImageEdgeInsets:UIEdgeInsetsMake(2,2, 2, 5)];
        [weizhi setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 2)];
        [weizhi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        weizhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [weizhi addTarget:self action:@selector(dituLook) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:weizhi];
        
        eTitle.text = name ;
        [distance setTitle:[NSString stringWithFormat:@"%.2fkm",[dis floatValue]/1000 ] forState:UIControlStateNormal];
        [weizhi setTitle:wei forState:UIControlStateNormal];
        
        
        
        UIImageView *cellTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 8 ,kHeight /3+kWidth /6 + kHeight /20 *8 +16, kWidth - kHeight / 8, 0.5)];
        cellTitleView.image = [UIImage imageNamed:@"icon_tblack_a"];
        [self.headView addSubview:cellTitleView
         ];
        UILabel *cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight /3+kWidth /6 + kHeight /20 *8, kWidth/5,kHeight/20)];
        
        cellTitle.text = @"其他优惠";
        
        cellTitle.textAlignment = NSTextAlignmentCenter;
        cellTitle.backgroundColor = [UIColor whiteColor];
        cellTitle.font = [UIFont systemFontOfSize:15.0];
        [self.headView addSubview:cellTitle];
        
        
        CGFloat height = kHeight /3+kWidth /6 + kHeight /20 *9+15;
        CGRect frame = self.headView.frame;
        frame.size.height = height;
        self.headView.frame = frame;
        
    }
    self.DetailsTableView.tableHeaderView = self.headView;
}
- (void)dituLook{
    MapViewController *mapVC = [[MapViewController alloc] init];
    NSString *latitude = self.datasDic[@"latitude"];
    NSString *longitude = self.datasDic[@"longitude"];
    mapVC.lat = [latitude floatValue];
    mapVC.lng = [longitude floatValue];
    NSString *name = self.datasDic[@"mallName"];
    NSString *address = self.datasDic[@"address"];
    //使用单例传值
    MangoSingleton *mango = [MangoSingleton sharInstance];
    //如果获取到的经纬度值不为空，就传到地图页面
    if ([name isEqual:[NSNull null]] && [address isEqual:[NSNull null]]) {
        mango.title = name;
        mango.inputText = address;
        
    }
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark ========== 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"preferCell" forIndexPath:indexPath];
    NSString *typesting =self.cellArray[indexPath.row][@"type"];
        if ([typesting compare:@"0"] == NSOrderedSame) {
            cell.imageView.image = [UIImage imageNamed:@"discount_bg.9"];
            //时间日期转换
            //开始日期
            NSTimeInterval start =[ self.cellArray[indexPath.row][@"beginDate"] integerValue] /1000;
            NSDateFormatter *matter = [[NSDateFormatter alloc] init];
            [matter setDateFormat:@"YYYY/MM/dd"];
            NSDate *timeSter = [NSDate dateWithTimeIntervalSince1970:start ];
            NSString *timeSting = [matter stringFromDate:timeSter];
            
            //结束
            NSTimeInterval end = [self.cellArray[indexPath.row][@"endDate"]integerValue] / 1000;
            
            NSDate *timeEnd = [NSDate dateWithTimeIntervalSince1970:end];
            NSDateFormatter *endmatter = [[NSDateFormatter alloc] init];
            [endmatter setDateFormat:@"YYYY/MM/dd"];
            NSString *timeEndSting = [endmatter stringFromDate:timeEnd];
            
            NSString *timeLabels = [NSString stringWithFormat:@"有效期 %@-%@",timeSting,timeEndSting];
            cell.timeLable.text = timeLabels;
        }
        
        else{
            cell.imageView.image = [UIImage imageNamed:@"coupon_bg.9"];
            cell.timeLable.text = @"免费";
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLable.text = self.cellArray[indexPath.row][@"name"];
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = self.cellArray[indexPath.row][@"type"];
    if ([type isEqual:@"1"]) {
        ActivityMianViewController *activityMianVC = [[ActivityMianViewController alloc] init];
        activityMianVC.trunId  =  self.cellArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:activityMianVC animated:YES];
    }
    if ([type isEqual:@"0"]) {
        PreferDetailViewController *preferVC = [[PreferDetailViewController alloc] init];
//        preferVC.nameId = self.cellArray[indexPath.section][@"brandId"];
        preferVC.preferId = self.cellArray[indexPath.row][@"id"];
        preferVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preferVC animated:YES];
    }

}
#pragma mark ========== 懒加载

- (UITableView *)DetailsTableView{
    if (_DetailsTableView == nil) {
        self.DetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.DetailsTableView.delegate = self;
        self.DetailsTableView.dataSource = self;
        self.DetailsTableView.rowHeight = 90;
        self.DetailsTableView.separatorColor =[UIColor clearColor];
        //隐藏滚动条
        self.DetailsTableView.showsVerticalScrollIndicator =
        NO;
    }
    return _DetailsTableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] init];
    }
    return _headView;
}

- (NSDictionary *)datasDic{
    if (_datasDic == nil) {
        self.datasDic = [NSDictionary new];
    }
    return _datasDic;
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
