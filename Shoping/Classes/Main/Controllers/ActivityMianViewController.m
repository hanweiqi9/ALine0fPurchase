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
#import "ProgressHUD.h"
#import "MapViewController.h"
#import "MangoSingleton.h"
#import "ShareView.h"
@interface ActivityMianViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *DetailsTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *twoView;
@property (nonatomic, strong) UIView *oneView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *introlArray;
@property (nonatomic, strong) NSDictionary *datasDic;
@end

@implementation ActivityMianViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self showBackButtonWithImage:@"titlebarback"];
    [self.view addSubview:self.DetailsTableView];
    [self getActivityDetailData];
    UIBarButtonItem *Item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareicon"] style:UIBarButtonItemStylePlain target:self action:@selector(ShareAction)];
    Item.tintColor  = [UIColor redColor];
     self.navigationItem.rightBarButtonItem = Item;
    [self.DetailsTableView registerNib:[UINib nibWithNibName:@"NearTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
}

- (void)ShareAction{
    ShareView *view = [[ShareView alloc] init];
    view.urlStr = [NSString stringWithFormat:@"%@%@",kImageString,self.datasDic[@"brandPicUrl"]];
    view.titStr = self.datasDic[@"brandNameEn"];
    [self.view addSubview:view];
}

#pragma mark ========== 数据请求
- (void)getActivityDetailData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"加载中"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/detail?cityId=%@&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f&couponId=%@&source=1&salesId=&longitude=112.42675&latitude=34.618929",self.cityID,self.trunId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        self.datasDic = dic[@"datas"];
        [self.DetailsTableView reloadData];
        [self settingHeadView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark ========== 设置区头
- (void)settingHeadView{
    NSArray *array = self.datasDic[@"couponPicUrls"];
    self.title = self.datasDic[@"brandNameEn"];
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
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,self.datasDic[@"brandPicUrl"]]] placeholderImage:nil];
    [self.headView addSubview:icon];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /2 - kWidth /3/2 , kHeight /3-10+kWidth /6, kWidth /3, kHeight /20)];
    title.font = [UIFont systemFontOfSize:14.0];
    title.text = self.datasDic[@"brandNameEn"];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:title];
    
    UILabel *enTitle = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /8, kHeight /3-10+kWidth /6+kHeight /20, kWidth-kWidth/8*2 , kHeight /20)];
    enTitle.text = self.datasDic[@"couponName"];
    enTitle.font = [UIFont systemFontOfSize:16.0];
    enTitle.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:enTitle];

    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 ,kHeight /3-10+kWidth /6 + kHeight /20 *2, kWidth /3, kHeight /20)];
    NSNumber *stinf = self.datasDic[@"costPrice"] ;
    if ([stinf isEqual:@(0)]) {
        price.text = @"免费";
    }
    else
        price.text = [NSString stringWithFormat:@"￥%@",stinf];
   
    price.textColor = [UIColor redColor];
    price.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:price];
    NSString *name = self.datasDic[@"storeName"];
    NSString *dis = self.datasDic[@"distance"];
    NSString *wei = self.datasDic[@"storeAddress"];
    
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
        weizhi.frame = CGRectMake(kWidth / 6 ,kHeight / 3 +kWidth / 6 + kHeight / 20 * 6 + 15, kWidth - kWidth / 3, kHeight / 20);
        [weizhi setImage:[UIImage imageNamed:@"address22"] forState:UIControlStateNormal];
        weizhi.titleLabel.adjustsFontSizeToFitWidth =YES;
        [weizhi setImageEdgeInsets:UIEdgeInsetsMake(2,2, 2, 5)];
        [weizhi setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 2)];
        [weizhi setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        weizhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [weizhi addTarget:self action:@selector(dituLook) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:weizhi];

        eTitle.text = name ;
        [distance setTitle:[NSString stringWithFormat:@"%.2fkm",[dis floatValue]/1000 ] forState:UIControlStateNormal];
        [weizhi setTitle:wei forState:UIControlStateNormal];
        CGFloat height = kHeight /3+kWidth /6 + kHeight /20 *7+15;
        CGRect frame = self.headView.frame;
        frame.size.height = height;
        self.headView.frame = frame;
        
    }
    self.DetailsTableView.tableHeaderView = self.headView;
}
- (void)dituLook{
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.lat = [self.datasDic[@"latitude"] floatValue];
    mapVC.lng = [self.datasDic[@"longitude"] floatValue];
    NSString *name = self.datasDic[@"storeName"];
    NSString *address = self.datasDic[@"storeAddress"];
    
    //使用单例传值
    MangoSingleton *mangos = [MangoSingleton sharInstance];
    //如果获取到的经纬度值不为空，就传到地图页面
    if ([name isEqual:[NSNull null]] && [address isEqual:[NSNull null]]) {
        mangos.title = @"当前位置";
        mangos.inputText = @"你的坐标";
    } else {
        mangos.title = name;
        mangos.inputText = address;
    }
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark ========== 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellsting = @"onecell";
        UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:cellsting];
        if (cells == nil) {
            cells = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellsting];
        }
        if (self.datasDic.count > 0) {
            for (UILabel *lable in cells.contentView.subviews) {
                [lable removeFromSuperview];
                
            }
            if (indexPath.row == 0) {
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
                
                NSString *timeLabels = [NSString stringWithFormat:@"有效期       %@-%@",timeSting,timeEndSting];
                self.DetailsTableView.rowHeight = 30;
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-20, 30)];
                title.font = [UIFont systemFontOfSize:15.0];
                title.text =  timeLabels;
                title.numberOfLines = 0;
                [cells.contentView addSubview:title];
            }
            if (indexPath.row == 1) {
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-20, 30)];
                title.font = [UIFont systemFontOfSize:15.0];
                title.text =  @"使用规则";
                title.numberOfLines = 0;
                [cells.contentView addSubview:title];
                self.DetailsTableView.rowHeight = 30;
            }
            if (indexPath.row == 2) {
                CGFloat height = [[self class] getTextHeightWithText:self.datasDic[@"couponDesc"]];
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-20, height)];
                title.font = [UIFont systemFontOfSize:13.0];
                title.text = self.datasDic[@"couponDesc"];
                title.numberOfLines = 0;
                [cells.contentView addSubview:title];
                self.DetailsTableView.rowHeight = title.frame.size.height+10;
            }
        }
        //点击cell时的颜色效果取消
        cells.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cells;
    }
    if (indexPath.section == 1) {
        NearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo" forIndexPath:indexPath];
        if (self.datasDic.count > 0) {
            NSMutableArray *group = self.datasDic[@"couponOrDiscounts"];
            NSString *typesting =group[indexPath.row][@"type"];
            if (group.count > 0) {
                if ([typesting compare:@"0"] == NSOrderedSame) {
                    cell.imageView.image = [UIImage imageNamed:@"discount_bg.9"];
                    //时间日期转换
                    //开始日期
                    NSTimeInterval start =[ group[indexPath.row][@"beginDate"] integerValue] /1000;
                    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
                    [matter setDateFormat:@"YYYY/MM/dd"];
                    NSDate *timeSter = [NSDate dateWithTimeIntervalSince1970:start ];
                    NSString *timeSting = [matter stringFromDate:timeSter];
                    //结束
                    NSTimeInterval end = [group[indexPath.row][@"endDate"]integerValue] / 1000;
                    
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
                cell.titleLable.text = group[indexPath.row][@"name"];
            }
        }
        self.DetailsTableView.rowHeight = 90;
        //点击cell时的颜色效果取消
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *cellstings = @"onecells";
        UITableViewCell *cellss = [tableView dequeueReusableCellWithIdentifier:cellstings];
        if (cellss == nil) {
            cellss = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstings];
        }
        return cellss;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *group = self.datasDic[@"couponOrDiscounts"];
    if (group.count > 0) {
        return 2;
    }else
        return 1;
}

+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kWidth - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *group = self.datasDic[@"couponOrDiscounts"];
    if (group.count > 0) {
        if (section == 0) {
            return 3;
        }
        if (section == 1) {
            NSMutableArray *group = self.datasDic[@"couponOrDiscounts"];
            return group.count;
        }
        else
            return 0;
    }
    else
        return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kWidth/13+10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kWidth, kWidth/13+5)];
    //    view.backgroundColor = [UIColor cyanColor];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 8, 15, kWidth - kHeight / 8, 0.5)];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [view addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2 - 5,0 , kWidth/5,kWidth/13)];
    NSMutableArray *group = self.datasDic[@"couponOrDiscounts"];
    if (group.count > 0) {
        if (section == 0) {
            titleL.text = @"使用须知";
        }
        else{
            titleL.text = @"其他优惠";
        }
    }
   else
       titleL.text = @"使用须知";
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
