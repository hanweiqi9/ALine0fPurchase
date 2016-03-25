//
//  ViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ScanViewController.h"
#import "YouhuiViewController.h"
#import "NearPreferViewController.h"
#import "ActivityViewController.h"
#import "HtmlViewController.h"
#import "ActivityMianViewController.h"
#import "ShopDetailViewController.h"
#import "SDCycleScrollView.h"
#import "PullingRefreshTableView.h"
#import "BrandDetailViewController.h"
#import "AppDelegate.h"
#import "NearbyViewController.h"
#import "PreferDetailViewController.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,PullingRefreshTableViewDelegate,UITabBarControllerDelegate>
//UI控件
@property (nonatomic, strong) PullingRefreshTableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageC;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIButton *cityButton;
//数据
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *turnArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *toolArray;
@property (nonatomic, strong) NSMutableArray *youArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, assign) BOOL refreshing;

@property (nonatomic, strong) AppDelegate *appdelegate;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"精选";
    
    self.cityId =@"391db7b8fdd211e3b2bf00163e000dce";
    [self.view addSubview:self.tableview];
    
    [self headSettingView];
    //数据请求
//    [self startTimer];
    [self.tableview launchRefreshing];

    [self MoreThead];
    [self getCityData];
    //黑背景
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    self.blackView.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:0.5];
    self.blackView.hidden = YES;
    [self.view addSubview:self.blackView];
    
    //白
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    self.whiteView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.1];
    self.whiteView.hidden = YES;
    [self.view addSubview:self.whiteView];
    
    //设置左导航栏
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame =CGRectMake(5, 30, 30, 20);
    //    leftButton.backgroundColor = [UIColor cyanColor];
    [leftButton setImage:[UIImage imageNamed:@"home_page_lbs_icon"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 5, 5, 5)];
    
    [leftButton setTitle:@"上海" forState:UIControlStateNormal];
    [leftButton setTintColor:[UIColor redColor]];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(17, -16, 5, 5)];
    [leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    //设置右导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"main_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    rightItem.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
#pragma merk ------- 多线程实现数据同时请求
- (void)MoreThead{
    
    dispatch_queue_t mainThead = dispatch_queue_create("com.turn queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    dispatch_async(mainThead, ^{
        [self getMainData];
    });
    dispatch_async(mainThead, ^{
        [self toolViewData];
    });
    dispatch_async(mainThead, ^{
        [self youData];
    });
    dispatch_async(mainThead, ^{
        [self getCellData];
    });
//    dispatch_async(mainThead, ^{
//        [self getCityData];
//    });

}
//轮播图
- (void)settingTurn{
    //使用第三方库
    UIScrollView  *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/2-60)];
    scrollView.contentSize = CGSizeMake(kWidth, kHeight / 2-60);
    
    NSMutableArray *group = [NSMutableArray new];
    for (int i = 0;i < self.turnArray.count; i++) {
        NSString *url =self.turnArray[i][@"mainPicUrl"];
        NSString *urlstinf = [NSString stringWithFormat:@"%@%@",kImageString,url];
        [group addObject:urlstinf];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 0,scrollView.bounds.size.width, kHeight/ 2 -60) shouldInfiniteLoop:YES imageNamesGroup:group];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    //轮播时间，默认1秒
    cycleScrollView.autoScrollTimeInterval = 3.0;
    
    [scrollView addSubview:cycleScrollView];
    [self.HeadView addSubview:scrollView];
}

//列表的设置
- (void)settingTools{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight/2-15, kWidth, kWidth/3+0.5)];
    toolView.backgroundColor = [UIColor grayColor];
    for (int i = 1 ; i < 6; i++) {
        
        [self.HeadView addSubview:toolView];
        UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [toolButton addTarget:self action:@selector(AllBottonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *sting = [NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.toolArray[i-1][@"recommendPic"]];
        toolButton.tag = i;
        if (i < 3) {
            toolButton.frame = CGRectMake(kWidth/ 2 * (i - 1)+0.5*(i-1), 0, kWidth/2, kWidth/3);
            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, toolButton.frame.size.width, toolButton.frame.size.height)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
            
            [toolButton addSubview:imageview];
            [toolView addSubview:toolButton];
        }if (i > 2 && i < 6) {
            toolButton.frame = CGRectMake(kWidth/4*(i- 3)+5,kHeight/2+kWidth/3-10, kWidth/4-10, kWidth/4-10);
            toolButton.tag = i;
            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, toolButton.frame.size.width - 5, toolButton.frame.size.height - 5)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
            
            [toolButton addSubview:imageview];
            [self.HeadView addSubview:toolButton];
        }
    }
}
//在你周围的设置
- (void)settingYourground{
    UIButton *youButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    youButton.backgroundColor = [UIColor yellowColor];
    youButton.frame = CGRectMake(5, kHeight/2+kWidth/3 + kWidth /4 -3+ kWidth/13, kWidth / 2 + 30, kWidth/2);
    youButton.tag = 6;
    [youButton addTarget:self action:@selector(AllBottonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = self.youArray[0];
    NSString *string =[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",dic[@"mainPicUrl"]];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, youButton.frame.size.width, youButton.frame.size.height)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
    [youButton addSubview:imageview];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, youButton.frame.size.height - 40,youButton.frame.size.width ,40)];
    lable.text = dic[@"mallName"];
    lable.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [imageview addSubview:lable];
    [self.HeadView addSubview:youButton];
    for (int i = 0; i < 2; i++) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.backgroundColor = [UIColor orangeColor];
        Button.frame = CGRectMake(kWidth /2+40, kHeight/2+kWidth/3 + kWidth /4  + kWidth/13 + kWidth/4*i, kWidth / 2 - 50, kWidth /4-3);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(Button.frame.size.width/4-10, Button.frame.size.height-25,Button.frame.size.width/2+20, 20)];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        UIImageView *store = [[UIImageView alloc] initWithFrame:CGRectMake( Button.frame.size.width/3, 10, Button.frame.size.width/3, Button.frame.size.height / 2 )];
        if (i == 0) {
            title.text = @"附近商城";
            store.backgroundColor = [UIColor orangeColor];
            Button.tag = 7;
            store.image =[UIImage imageNamed:@"nearby_mall_icon"];
        }
        if (i == 1) {
            title.text = @"附近优惠";
            store.image =[UIImage imageNamed:@"nearby_coupon_icon"];
            Button.tag = 8;
            Button.backgroundColor = [UIColor colorWithRed:168.0/255.0  green:138/255.0 blue:250.0/255.0 alpha:1.0];
        }
        [Button addTarget:self action:@selector(AllBottonAction:) forControlEvents:UIControlEventTouchUpInside];
        [Button addSubview:title];
        [Button addSubview:store];
        [self.HeadView addSubview:Button];
    }
}

#pragma mark ---------- 数据请求
- (void)getMainData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *sring = @"http://api.gjla.com/app_admin_v400/api/onlineActivity/list?cityId=";
    [manger GET:[NSString stringWithFormat:@"%@%@",sring,self.cityId]
 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
            if(self.turnArray.count > 0) {
                [self.turnArray removeAllObjects];
            }
        for (NSDictionary *dics in data) {
            [self.turnArray addObject:dics];
        }
        [self.tableview reloadData];
        [self.tableview tableViewDidFinishedLoading];
        self.tableview.reachedTheEnd = NO;
        [self settingTurn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getCellData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/home/dailyHandpick?pageSize=10&pageNum=1&cityId=%@",self.cityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
            if (self.cellArray.count > 0) {
                [self.cellArray removeAllObjects];
            }
        for (NSDictionary *dics in data) {
            [self.cellArray addObject:dics];
        }
        [self.tableview reloadData];
        [self.tableview tableViewDidFinishedLoading];
        self.tableview.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)toolViewData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *urlSting = [NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/recommend?appVersion=4.2.0&cityId=%@",self.cityId];
    [manger GET:urlSting parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *dataArray = dic[@"datas"];

            if (self.toolArray.count > 0) {
                [self.toolArray removeAllObjects];
            }
        for (NSDictionary *dics in dataArray) {
            [self.toolArray addObject:dics];
        }
        [self.tableview reloadData];
        [self.tableview tableViewDidFinishedLoading];
        self.tableview.reachedTheEnd = NO;
        [self settingTools];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)youData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/home/LBSMall?longitude=112.426904&districtId=&latitude=34.618929&userId=&cityId=%@",self.cityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dics = dic[@"datas"];

            if (self.youArray.count > 0) {
                [self.youArray removeAllObjects];
            }
        [self.youArray addObject:dics];
        [self.tableview reloadData];
        [self.tableview tableViewDidFinishedLoading];
        self.tableview.reachedTheEnd = NO;
        [self settingYourground];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)getCityData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.gjla.com/app_admin_v400/api/city/cityList" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.cityArray = dic[@"datas"];
        [self.tableview reloadData];
        [self.tableview tableViewDidFinishedLoading];
        self.tableview.reachedTheEnd = NO;
//        [self leftBarButtonAction];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 设置区头
- (void)headSettingView{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight /2 - 60, kWidth, 45)];
    toolView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"main_search_bg.9"] forState:UIControlStateNormal];
    button.tag = 0;
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(20, 5, kWidth - 40, 35);
    
    [toolView addSubview:button];
    
    [self.HeadView addSubview:toolView];
    
    UIButton *guButton = [UIButton buttonWithType:UIButtonTypeSystem];
    guButton.frame = CGRectMake(kWidth/4*3+5,kHeight/2+kWidth/3-5, kWidth/4-10, kWidth/4-15);
    guButton.tag = 6;
    [guButton setBackgroundImage:[UIImage imageNamed:@"home_more.jpg"] forState:UIControlStateNormal];
    [guButton addTarget:self action:@selector(AllYouhuiShow) forControlEvents:UIControlEventTouchUpInside];
    [self.HeadView addSubview:guButton];
    
    
    // 在你周围
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/2+kWidth/3 + kWidth/4 +5, kWidth /2 + 10, 0.5)];
    //    titleView.backgroundColor = [UIColor redColor];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/2+kWidth/3 + kWidth/4-10 , kWidth/5,kWidth/13)];
    titleL.text = @"在你周围";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleL];
    

    //每日精选
    UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/2+kWidth/3 + kWidth /4 + 23+ kWidth/13 + kWidth / 2, kWidth /2 + 10, 0.5)];
    //    titleView.backgroundColor = [UIColor redColor];
    goodView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:goodView
     ];
    UILabel *titleLgood = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/2+kWidth/3 +kWidth /2+ kWidth /4 + 8+ kWidth/13, kWidth/5,kWidth/13)];
    titleLgood.text = @"每日精选";
    titleLgood.textAlignment = NSTextAlignmentCenter;
    titleLgood.backgroundColor = [UIColor whiteColor];
    titleLgood.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleLgood];
    
}


#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"IOS";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    if (indexPath.row < self.cellArray.count) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kWidth, kWidth -110)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.cellArray[indexPath.row][@"mainPicUrl"]]] placeholderImage:nil];
        [cell addSubview:imageview];
    }
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidth -100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityViewController *activityVC = [[ActivityViewController alloc] init];
    
    activityVC.selectId = self.cellArray[indexPath.row][@"subjectId"] ;
    activityVC.type = [self.cellArray[indexPath.row][@"type"] integerValue];
    activityVC.userId = @"c649ac4bf87f43fea924f52a2639e533";
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(MoreThead) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
//    [[self class] showAlertMessageWithMessage:@"已是最后数据" duration:1.0];
    UIAlertController *alVC = [UIAlertController alertControllerWithTitle:nil message:@"已是最后数据"  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableview setScrollsToTop:YES];
    }];
    [alVC addAction:action];
    [self presentViewController:alVC animated:YES completion:nil];
    [self.tableview tableViewDidFinishedLoading];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableview tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableview tableViewDidEndDragging:scrollView];
}
#pragma mark --------- 点击方法
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
        NSString *urlsting = self.turnArray[index][@"linkUrl"];
        NSArray *array = [urlsting componentsSeparatedByString:@"/"];
        NSString *stinr = array[array.count-1];
        NSArray *typeArray = [stinr componentsSeparatedByString:@".html"];
        NSString *typestinr = typeArray[0];
        if ([typestinr isEqualToString:@"index9"] ||[typestinr isEqualToString:@"hq"]  ) {
            HtmlViewController *htmlVC = [[HtmlViewController alloc] init];
            htmlVC.urlString = self.turnArray[index][@"fuliId"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
        if ([typestinr isEqualToString:@"brandcoupon"]) {
            ActivityMianViewController *activityMianVC = [[ActivityMianViewController alloc] init];
            activityMianVC.hidesBottomBarWhenPushed = YES;
            activityMianVC.cityID = self.cityId;
            NSString *stinf = typeArray[1];
            NSArray *aarray = [stinf componentsSeparatedByString:@"="];
            NSString *csting = aarray[1];
            NSArray *barray = [csting componentsSeparatedByString:@"&ctype="];
            activityMianVC.trunId = barray[0];
            [self.navigationController pushViewController:activityMianVC animated:YES];
        }
    if ([typestinr isEqualToString:@"subject"]) {
        ActivityViewController *avtivity = [[ActivityViewController alloc] init];
        NSString *stinf = typeArray[1];
        NSArray *aarray = [stinf componentsSeparatedByString:@"="];
//        avtivity.cityId = self.cityId;
        NSString *csting = aarray[aarray.count - 1];
            avtivity.selectId = csting;
            avtivity.userId = @"c649ac4bf87f43fea924f52a2639e533";
            avtivity.type = 1;
        
        [self.navigationController pushViewController:avtivity animated:YES];
        
    }
    if ([typestinr isEqualToString:@"brandinfo"]) {
        BrandDetailViewController *brandVC = [[BrandDetailViewController alloc] init];
//        brandVC.cityId = self.cityId;
        NSString *stinf = typeArray[1];
        NSArray *aarray = [stinf componentsSeparatedByString:@"="];
        NSString *csting = aarray[aarray.count - 1];
        brandVC.brandId = csting;
        brandVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brandVC animated:YES];
    }
    
}
- (void)leftBarButtonAction{

    self.blackView.hidden = NO;
    UIButton *buttona = [UIButton buttonWithType:UIButtonTypeCustom];

    buttona.frame = CGRectMake(0, 30, kWidth, kHeight -30);
    [buttona addTarget:self action:@selector(BackMain) forControlEvents:UIControlEventTouchUpInside];
    [self.blackView addSubview:buttona];
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    cityView.backgroundColor = [UIColor whiteColor];
    if (self.cityArray.count > 0) {
        for (int i = 0; i < self.cityArray.count; i++) {
            self.cityButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cityButton .backgroundColor =[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            self.cityButton .frame = CGRectMake(kWidth/3*i+ 10, 15, kWidth/3-20, 30);
            [self.cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.cityButton  setTitle:self.cityArray[i][@"cityName"] forState:UIControlStateNormal];
            self.cityButton .tag = i;
            [self.cityButton  addTarget:self action:@selector(BackUpView:) forControlEvents:UIControlEventTouchUpInside];
            [cityView addSubview:self.cityButton ];
        }
    }
    [self.blackView addSubview:cityView];
}

- (void)BackUpView:(UIButton *)button{
//    [self.cityButton  setTitle:self.cityArray[button.tag][@"cityName"] forState:UIControlStateNormal];
    self.cityButton.titleLabel.text = self.cityArray[button.tag][@"cityName"];
    self.cityButton.backgroundColor = [UIColor redColor];
    self.cityButton.titleLabel.textColor = [UIColor whiteColor];
    self.blackView.hidden = YES;
    self.cityId = self.cityArray[button.tag][@"cityId"];
    [self MoreThead];
 
}
- (void)BackMain{
    self.blackView.hidden = YES;
}

- (void)rightBarButtonAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanViewController *scanVC = [story instantiateViewControllerWithIdentifier:@"scanvc"];
    scanVC.title = @"二维码扫描";
    scanVC.navigationController.navigationBar.tintColor = [UIColor redColor];
    scanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)AllYouhuiShow{
    YouhuiViewController *youhuiVC = [[YouhuiViewController alloc] init];
    youhuiVC.cityId = self.cityId;
    youhuiVC.hidesBottomBarWhenPushed = YES;
    youhuiVC.title = @"全部优惠券";
    [self.navigationController pushViewController:youhuiVC animated:YES];
}

- (void)AllBottonAction:(UIButton *)button {
    if (button.tag > 0 && button.tag < 6) {
        NSString *urlsting = self.toolArray[button.tag-1][@"recommendLink"];
        NSArray *array = [urlsting componentsSeparatedByString:@"/"];
        NSString *stinr = array[array.count-1];
        NSArray *typeArray = [stinr componentsSeparatedByString:@".html?"];
        NSString *typestinr = typeArray[0];
        if ([typestinr isEqualToString:@"index9"]) {
            HtmlViewController *htmlVC = [[HtmlViewController alloc] init];
            htmlVC.urlString = self.toolArray[button.tag][@"recommendLink"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
        if ([typestinr isEqualToString:@"brandcoupon"]) {
            NSString *stinf = typeArray[1];
            NSArray *aarray = [stinf componentsSeparatedByString:@"cid="];
            NSString *csting = aarray[1];
            NSArray *barray = [csting componentsSeparatedByString:@"&ctype="];
            NSString *type = barray[1];
            
            if (self.cityId == @""  && [type isEqualToString:@"1"]) {
                PreferDetailViewController *preferVC = [[PreferDetailViewController alloc] init];
                preferVC.cityID = self.cityId;
                preferVC.preferId = barray[0];
                preferVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:preferVC animated:YES];
            }
            
            
            ActivityMianViewController *activityMianVC = [[ActivityMianViewController alloc] init];
            activityMianVC.trunId = barray[0];
            activityMianVC.cityID = self.cityId;
            activityMianVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityMianVC animated:YES];
        }
    }
    if (button.tag == 6) {
        //广场详情
        ShopDetailViewController *shopVC = [[ShopDetailViewController alloc] init];
        NSDictionary *dic = self.youArray[0];
        shopVC.title = dic[@"mallName"];
        shopVC.detailId = dic[@"mallId"];
//        shopVC.cityID = self.cityId;
        shopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopVC animated:self];
    }
    if (button.tag == 7) {
//        附近商城
        
//         self.view.window.rootViewController = [[ShopDetailViewController alloc] init];//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Nearby" bundle:nil];
////        NearbyViewController *nearVC = [story instantiateViewControllerWithIdentifier:@"nearby"];
//        UINavigationController *nav = story.instantiateInitialViewController;
//        
        self.appdelegate = [[AppDelegate alloc] init];
        self.appdelegate.tablebarVC.selectedIndex = 1;
//
//        self.appdelegate.tablebarVC.delegate = self;
//        [self tabBarController:self.appdelegate.tablebarVC didSelectViewController:self.appdelegate.tablebarVC.navigationController.];
    }
    if (button.tag == 8) {
        //附近优惠
        NearPreferViewController *nearVC = [[NearPreferViewController alloc] init];
        nearVC.title = @"所有优惠";
        nearVC.cityID = self.cityId;
        nearVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nearVC animated:YES];
    }
}

#pragma mark --------- 懒加载
- (PullingRefreshTableView *)tableview{
    if (_tableview == nil) {
        self.tableview = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0,64, kWidth, kHeight )pullingDelegate:self];
//        self.tableview.pull≥/ingDelegate = self;
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        //        self.tableview.backgroundColor = [UIColor cyanColor];
        self.tableview.tableHeaderView = self.HeadView;
        //隐藏滚动条
        self.tableview.showsVerticalScrollIndicator =
        NO;
    }
    return _tableview;
}
- (UIView *)HeadView{
    if (_HeadView == nil) {
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight/2+kWidth/3 +kWidth /2+ kWidth /4 + 18+ kWidth/13*2)];
        //        self.HeadView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];;
    }
    return _HeadView;
}

- (NSMutableArray *)turnArray{
    if (_turnArray == nil) {
        self.turnArray = [NSMutableArray new];
    }
    return _turnArray;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        self.cellArray = [NSMutableArray new];
    }
    return _cellArray;
}

- (NSMutableArray *)toolArray{
    if (_toolArray == nil) {
        self.toolArray = [NSMutableArray new];
    }
    return _toolArray;
}

- (NSMutableArray *)youArray{
    if (_youArray == nil) {
        self.youArray = [NSMutableArray new];
    }
    return _youArray;
}

- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

 

