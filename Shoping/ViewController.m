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
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate >
//UI控件
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UIScrollView *scrollView;
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
@property (nonatomic, strong) NSDictionary *youDic;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSString *cityId;

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
    [self startTimer];
    [self MoreThead];
    
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
    dispatch_async(mainThead, ^{
        [self getCityData];
    });
    
}
//轮播图
- (void)settingTurn{
    self.pageC.numberOfPages = self.turnArray.count;
    
    for (int i = 0; i < self.turnArray.count; i++) {
        self.scrollView.contentSize = CGSizeMake(kWidth * self.turnArray.count, kHeight / 2-50);
        UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight/2-50)];
        //        images.backgroundColor = [UIColor redColor];
        [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.turnArray[i][@"mainPicUrl"]]] placeholderImage:nil];
        [self.scrollView addSubview:images];
    }
    [self.HeadView addSubview:self.scrollView];
    [self.HeadView addSubview:self.pageC];
    
}

//列表的设置
- (void)settingTools{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight/2-5, kWidth, kWidth/3+0.5)];
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
            toolButton.frame = CGRectMake(kWidth/4*(i- 3)+5,kHeight/2+kWidth/3, kWidth/4-10, kWidth/4-10);
            toolButton.tag = i;
            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, toolButton.frame.size.width - 5, toolButton.frame.size.height - 5)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
            
            [toolButton addSubview:imageview];
            [self.HeadView addSubview:toolButton];
        }
    }
    UIButton *guButton = [UIButton buttonWithType:UIButtonTypeSystem];
    guButton.frame = CGRectMake(kWidth/4*3+5,kHeight/2+kWidth/3+5, kWidth/4-10, kWidth/4-15);
    guButton.tag = 6;
    [guButton setBackgroundImage:[UIImage imageNamed:@"home_more.jpg"] forState:UIControlStateNormal];
    [guButton addTarget:self action:@selector(AllYouhuiShow) forControlEvents:UIControlEventTouchUpInside];
    [self.HeadView addSubview:guButton];
    
    
}
//在你周围的设置
- (void)settingYourground{
    UIButton *youButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    youButton.backgroundColor = [UIColor yellowColor];
    youButton.frame = CGRectMake(5, kHeight/2+kWidth/3 + kWidth /4 + 7+ kWidth/13, kWidth / 2 + 30, kWidth/2);
    youButton.tag = 6;
    [youButton addTarget:self action:@selector(AllBottonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *string =[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.youDic[@"mainPicUrl"]];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, youButton.frame.size.width, youButton.frame.size.height)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
    [youButton addSubview:imageview];
    [self.HeadView addSubview:youButton];
    for (int i = 0; i < 2; i++) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.backgroundColor = [UIColor orangeColor];
        Button.frame = CGRectMake(kWidth /2+40, kHeight/2+kWidth/3 + kWidth /4 + 10 + kWidth/13 + kWidth/4*i, kWidth / 2 - 50, kWidth /4-3);
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
    [manger GET:[NSString stringWithFormat:@"%@%@",sring,self.cityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
        if (self.turnArray.count > 0) {
            [self.turnArray removeAllObjects];
        }
        for (NSDictionary *dics in data) {
            [self.turnArray addObject:dics];
        }
        [self.tableview reloadData];
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
        for (NSDictionary *dics in data) {
            [self.cellArray addObject:dics[@"mainPicUrl"]];
        }
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)toolViewData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/recommend?appVersion=4.2.0&cityId=%@",self.cityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *dataArray = dic[@"datas"];
        for (NSDictionary *dics in dataArray) {
            [self.toolArray addObject:dics];
        }
        [self.tableview reloadData];
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
        self.youDic = dic[@"datas"];
        [self.tableview reloadData];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 设置区头
- (void)headSettingView{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight /2 - 50, kWidth, 45)];
    toolView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"main_search_bg.9"] forState:UIControlStateNormal];
    button.tag = 0;
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(20, 5, kWidth - 40, 35);
    
    [toolView addSubview:button];
    
    [self.HeadView addSubview:toolView];
    
    // 在你周围
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/2+kWidth/3 + kWidth/4 +15, kWidth /2 + 10, 0.5)];
    //    titleView.backgroundColor = [UIColor redColor];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/2+kWidth/3 + kWidth/4 , kWidth/5,kWidth/13)];
    titleL.text = @"在你周围";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleL];
    
    
    
    
    //每日精选
    UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/2+kWidth/3 + kWidth /4 + 33+ kWidth/13 + kWidth / 2, kWidth /2 + 10, 0.5)];
    //    titleView.backgroundColor = [UIColor redColor];
    goodView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:goodView
     ];
    UILabel *titleLgood = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/2+kWidth/3 +kWidth /2+ kWidth /4 + 18+ kWidth/13, kWidth/5,kWidth/13)];
    titleLgood.text = @"每日精选";
    titleLgood.textAlignment = NSTextAlignmentCenter;
    titleLgood.backgroundColor = [UIColor whiteColor];
    titleLgood.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleLgood];
    
}
//圆点随着滑动变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGFloat pagenum = self.scrollView.frame.size.width;
    CGPoint offset =  self.scrollView.contentOffset;
    NSInteger num = offset.x / pagenum;
    self.pageC.currentPage = num;
}

- (void)startTimer{
    
    //如果定时器存在的话， 不在执行
    if (_timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(rollScreen) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//每两秒执行一次图片自动轮播
- (void)rollScreen{
    if (self.turnArray.count > 0) {
        //当前页 +1
        //self.idArray.count的元素可能为0，当0时对取余的时候，没有意义
        NSInteger rollPage = (self.pageC.currentPage + 1) % self.turnArray.count;
        self.pageC.currentPage = rollPage;
        
        CGFloat offset = rollPage * kWidth;
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self rollScreen];
    //停止定时器后，将定时器置为nil，再次启动时，定时器才能保证正常执行。
    //        self.timer = nil;
    //    [self startTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
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
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.cellArray[indexPath.row]]] placeholderImage:nil];
        [cell addSubview:imageview];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidth -100;
}
#pragma mark --------- 点击方法
- (void)leftBarButtonAction{
    [self getCityData];
    self.blackView.hidden = NO;
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    cityView.backgroundColor = [UIColor whiteColor];
    if (self.cityArray.count > 0) {
        for (int i = 0; i < self.cityArray.count; i++) {
            self.cityButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cityButton .backgroundColor = [UIColor cyanColor];
            self.cityButton .frame = CGRectMake(kWidth/3*i+ 10, 15, kWidth/3-20, 30);
            [self.cityButton  setTitle:self.cityArray[i][@"cityName"] forState:UIControlStateNormal];
            self.cityButton .tag = i;
            [self.cityButton  addTarget:self action:@selector(BackUpView:) forControlEvents:UIControlEventTouchUpInside];
            [cityView addSubview:self.cityButton ];
        }
    }
    [self.blackView addSubview:cityView];
}

- (void)BackUpView:(UIButton *)button{
    
    self.blackView.hidden = YES;
    
    self.cityId = self.cityArray[button.tag][@"cityId"];
    [self MoreThead];
    [self.cityButton  setTitle:self.cityArray[button.tag][@"cityName"] forState:UIControlStateNormal];
}

- (void)rightBarButtonAction{
    self.whiteView.hidden = NO;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 110)];
    selectView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(selectView.frame.size.width/2*i+5,5,selectView.frame.size.width/2-10,selectView.frame.size.height -10);
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"main_saoyisao"] forState:UIControlStateNormal];
            [button setTitle:@"扫一扫" forState:UIControlStateNormal];
        }
        else{
            [button setImage:[UIImage imageNamed:@"main_invite"] forState:UIControlStateNormal];
            [button setTitle:@"邀请好友" forState:UIControlStateNormal];
        }
        [button setImageEdgeInsets:UIEdgeInsetsMake(5,button.frame.size.width/4+10, kWidth /12, button.frame.size.width/6)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.frame.size.width/4*2, - (button.frame.size.width/3+10),kWidth /2 / 10,0)];
        button.tag = i+5;
        [button addTarget:self action:@selector(selectRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:button];
    }
    [self.whiteView addSubview:selectView];
}

- (void)selectRightBarAction:(UIButton *)button{
    if (button.tag-5 == 0) {
        ScanViewController *scanVC = [[ScanViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }
    if (button.tag-5 == 1) {
        NSLog(@"yaoqing");
    }
    self.whiteView.hidden = YES;
}

- (void)AllYouhuiShow{
    YouhuiViewController *youhuiVC = [[YouhuiViewController alloc] init];
    youhuiVC.hidesBottomBarWhenPushed = YES;
    youhuiVC.title = @"全部优惠券";
    [self.navigationController pushViewController:youhuiVC animated:YES];
}

- (void)AllBottonAction:(UIButton *)button {
    switch (button.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            NearPreferViewController *nearVC = [[NearPreferViewController alloc] init];
            nearVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nearVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark --------- 懒加载
- (UITableView *)tableview{
    if (_tableview == nil) {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:UITableViewStylePlain];
        
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        //        self.tableview.backgroundColor = [UIColor cyanColor];
        self.tableview.tableHeaderView = self.HeadView;
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

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/2-50)];
        //        self.scrollView.backgroundColor = [UIColor orangeColor];
        self.scrollView.delegate = self;
        //显示滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        //垂直滑动
        self.scrollView.alwaysBounceHorizontal = NO;
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIPageControl *)pageC{
    if (_pageC == nil) {
        self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(kWidth / 3, kHeight / 2 - 80, kWidth / 3, 30)];
        self.pageC.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageC.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageC;
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

- (NSDictionary *)youDic{
    if (_youDic == nil) {
        self.youDic = [NSDictionary new];
    }
    return _youDic;
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
