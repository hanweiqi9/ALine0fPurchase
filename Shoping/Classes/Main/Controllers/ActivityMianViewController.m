//
//  ActivityMianViewController.m
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ActivityMianViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "NearTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+Common.h"

@interface ActivityMianViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *DetailsTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *introlArray;
@property (nonatomic, strong) NSDictionary *datasDic;

@end

@implementation ActivityMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self showBackButtonWithImage:@"titlebarback"];
    [self.view addSubview:self.DetailsTableView];
    
    
    
    [self getActivityDetailData];
}
#pragma mark ========== 数据请求
- (void)getActivityDetailData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/detail?cityId=391db7b8fdd211e3b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f&couponId=%@&longitude=112.426829&latitude=34.618749&source=1&salesId=",self.trunId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.datasDic = dic[@"datas"];
        
        [self.cellArray addObject:self.datasDic[@"couponOrDiscounts"]];
        
        [self.DetailsTableView reloadData];
        [self settingHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark ========== 设置区头
- (void)settingHeadView{
    NSArray *array = self.datasDic[@"couponPicUrls"];
    if (array.count > 1) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight /3 - 30)];
        scrollView.contentSize = CGSizeMake(kWidth * array.count, kHeight /3-30);
        for (int i = 0; i < array.count; i++) {
            UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight /3-20)];
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
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth /2 - kWidth /8 /2-5, kHeight /3-20, kWidth /8, kWidth /8)];
    icon.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.7];
    icon.layer.cornerRadius = 2;
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,self.datasDic[@"brandPicUrl"]]] placeholderImage:nil];
    [self.headView addSubview:icon];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /2 - kWidth /8 , kHeight /3-20+kWidth /8, kHeight /8, kHeight /24)];
    title.font = [UIFont systemFontOfSize:13.0];
    title.text = self.datasDic[@"brandNameEn"];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:title];
    
    UILabel *enTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 -5, kHeight /3-20+kWidth /8+kHeight /24, kWidth /3 + 10, kHeight /24)];
    //    enTitle.backgroundColor = [UIColor cyanColor];
    enTitle.text = self.datasDic[@"couponName"];
    enTitle.font = [UIFont systemFontOfSize:15.0];
    enTitle.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:enTitle];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3-10 ,kHeight /3-20+kWidth /8 + kHeight /24 *2, kWidth /3, kHeight /24)];
    price.text = [NSString stringWithFormat:@"￥%@",self.datasDic[@"costPrice"]];
    price.textColor = [UIColor redColor];
    price.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:price];
    
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 8 - 5,kHeight /3- 10+kWidth /8 + kHeight /24 *3, kWidth - kHeight / 8, 0.5)];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.headView addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2-5,kHeight /3-25+kWidth /8 + kHeight /24 *3 , kWidth/5,kHeight/24)];
    
    titleL.text = @"适用门店";
    
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15.0];
    [self.headView addSubview:titleL];
    
    
    UILabel *eTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 - 10, kHeight /3-20+kWidth /8 + kHeight /24 *4, kWidth /3+30, kHeight /24)];
    eTitle.text = self.datasDic[@"storeName"];
    eTitle.font = [UIFont systemFontOfSize:15.0];
    eTitle.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:eTitle];
    
    UIButton *distance = [UIButton buttonWithType:UIButtonTypeCustom];
    distance.frame = CGRectMake(kWidth / 3, kHeight /3-20+kWidth /8 + kHeight /24 *5, kWidth /3, kHeight /24);
    NSString *dis = self.datasDic[@"distance"];
    [distance setImage:[UIImage imageNamed:@"address_icon"] forState:UIControlStateNormal];
    [distance setImageEdgeInsets:UIEdgeInsetsMake(8, 3, 6, 10)];
    [distance setTitle:[NSString stringWithFormat:@"%.2fkm",[dis floatValue]/1000 ] forState:UIControlStateNormal];
    [distance setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 2)];
    [distance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    distance.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.headView addSubview:distance];
    
    //位置
    UIButton *weizhi = [UIButton buttonWithType:UIButtonTypeCustom];
    weizhi.frame = CGRectMake(kWidth /6 , kHeight /3-20+kWidth /8 + kHeight /24 * 6, kWidth - kWidth /3, kHeight /24);
    NSString *wei = self.datasDic[@"storeAddress"];
    [weizhi setImage:[UIImage imageNamed:@"address_i"] forState:UIControlStateNormal];
    [weizhi setImageEdgeInsets:UIEdgeInsetsMake(2,2, 2, 5)];
    [weizhi setTitle:wei forState:UIControlStateNormal];
    [weizhi setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 2)];
    [weizhi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    weizhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [weizhi addTarget:self action:@selector(dituLook) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:weizhi];
    
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame = CGRectMake(kWidth /3, kHeight /3-20+kWidth /8 + kHeight /24 * 7, kWidth / 3, kHeight /24);
    [buttom setTitle:[NSString stringWithFormat:@"查看全部店铺(%@)",self.datasDic[@"storeNum"]] forState:UIControlStateNormal];
    buttom.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [buttom addTarget:self action:@selector(AllAction) forControlEvents:UIControlEventTouchUpInside];
    [buttom setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.headView addSubview:buttom];
}
- (void)dituLook{
    
}
- (void)AllAction{
    
}
#pragma mark ========== 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kWidth - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
        static NSString *cellsting = @"onecell";
        UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:cellsting];
        if (cells == nil) {
            cells = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellsting];
                    }
        if (self.datasDic.count > 0) {
            if (indexPath.row == 0) {
                cells.textLabel.text = [NSString stringWithFormat:@"有效期            %@",self.datasDic[@"beginDate"]];
                self.DetailsTableView.rowHeight = 30;
            }
            if (indexPath.row == 1) {
                cells.textLabel.text = @"使用规则";
                self.DetailsTableView.rowHeight = 30;
            }
            if (indexPath.row == 2) {
                cells.textLabel.text = self.datasDic[@"couponDesc"];
                CGFloat height = [[self class] getTextHeightWithText:self.datasDic[@"couponDesc"]];
                cells.textLabel.numberOfLines = 0;
                self.DetailsTableView.rowHeight = height + 30;
            }
            
        }
        return cells;
//    }
//    else{
//        static NSString *cellting = @"teocell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellting];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellting];
//                    }
////        if (indexPath.row <self.cellArray.count) {
//            UIImageView *iconLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kWidth /8, 70)];
//    
//        NSDictionary *type = self.cellArray[indexPath.row];
//        NSString *stingtype = type[@"type"] ;
//                if ([stingtype integerValue] == 0) {
//                iconLeft.image = [UIImage imageNamed:@"coupon_bg.9"];
//            }
//            else{
//                iconLeft.image = [UIImage imageNamed:@"discount_bg.9"];
//            }
//            [cell addSubview:iconLeft];
////
//            UIImageView *iconright = [[UIImageView alloc] initWithFrame:CGRectMake(10 + kWidth /8, 5,kWidth -kWidth/8-20, 70)];
//            //            iconright.backgroundColor = [UIColor cyanColor];
//            iconright.image = [UIImage imageNamed:@"confirm_list_item_bg2"];
//            [cell addSubview:iconright];
//            UILabel *introl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, iconright.frame.size.width - 40, 30)];
//            NSString *sting = self.cellArray[indexPath.row][@"name"];
//            introl.text = sting;
//            [iconright addSubview:introl];
////
//            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, iconright.frame.size.width - 40, 30)];
////            if ([self.cellArray[indexPath.row][@"type"]isEqualToString: @"1"] ) {
////                price.text = [NSString stringWithFormat:@"￥%@",self.cellArray[indexPath.row][@"costPrice"]];
////            }
////            else
////            {
//                price.text = @"20195-25566";
////            }
//            [iconright addSubview:price];
//            self.DetailsTableView.rowHeight = 90;
////        }
//
//        return cell;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 3;
//    }
//    if (section == 1) {
//        return self.cellArray.count;
//    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kWidth/13+10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kWidth, kWidth/13+5)];
    //    view.backgroundColor = [UIColor cyanColor];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 8 - 5, 15, kWidth - kHeight / 8, 0.5)];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [view addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2 - 5,0 , kWidth/5,kWidth/13)];
    if (section == 0) {
        titleL.text = @"使用须知";
    }
    else{
        titleL.text = @"其他优惠";
    }
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:titleL];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ========== 懒加载

- (UITableView *)DetailsTableView{
    if (_DetailsTableView == nil) {
        self.DetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.DetailsTableView.delegate = self;
        self.DetailsTableView.dataSource = self;
        self.DetailsTableView.tableHeaderView = self.headView;
    }
    return _DetailsTableView;
}

- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight /3+kWidth /8 + kHeight /24 * 8)];
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

- (NSMutableArray *)introlArray{
    if (_introlArray == nil) {
        self.introlArray = [NSMutableArray new];
    }
    return _introlArray;
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
