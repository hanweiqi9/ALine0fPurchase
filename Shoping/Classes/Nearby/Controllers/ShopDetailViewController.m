//
//  ShopDetailViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailModel.h"
#import "OneDetailTableViewCell.h"
#import "TwoDetailTableViewCell.h"
#import "TwoCellModel.h"
#import "BrandViewController.h"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kShopDetail @"http://api.gjla.com/app_admin_v400/api/mall/mallDetail?userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f&longitude=112.426904&latitude=34.618939&audit="

@interface ShopDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger clickCount;
}

@property (nonatomic, strong) NSString *categoryBtnId;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, assign) BOOL refreshing;  //是否刷新
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *discountsArray;
@property (nonatomic, strong) NSDictionary *headerDic;
@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏tableBar
    self.tabBarController.tabBar.hidden = YES;
    //自定义导航栏标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4, 0, kWidth / 4, 44)];
    label.text =  @"商场详情";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //自定义导航栏右侧按钮
    //喜爱
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.frame = CGRectMake(kWidth * 0.75 + 35, 0, 30, 30);
    self.likeButton.tag = 1;
    [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.likeButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightLikeBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kWidth * 0.75, 0, 30, 30);
    [shareButton setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[shareBtn, rightLikeBtn];
    
    [self.view addSubview:self.tableView];
    //网络请求
    [self requestData];

    //1.注册通知
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    //把通知的内容放入字典,把字典传过去
    [notification postNotificationName:@"数据Id" object:self userInfo:self.headerDic];
    

}


//网络请求
- (void)requestData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&mallId=%@", kShopDetail, _detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *datasDic = responseObject;
        self.headerDic = datasDic[@"datas"];
        
        //第一个cell需要显示的数据
        NSMutableArray *couponArray = self.headerDic[@"couponOrDiscounts"];
        for (NSDictionary *dic in couponArray) {
            DetailModel *model = [[DetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.discountsArray addObject:model];

        }
        //第二个cell需要显示的数据
        NSMutableArray *subjectArray = self.headerDic[@"subjectMall"];
        for (NSDictionary *dict in subjectArray) {
            TwoCellModel *model1 = [[TwoCellModel alloc] init];
            [model1 setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model1];
            
    }
        
        [self.tableView reloadData];
        [self configTableViewHeader];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


#pragma mark ---------------------------  协议方法
//返回分区有多少条目
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.discountsArray.count;
    } if (section == 1) {
        return self.dataArray.count;
    }
    else
        return 0;
}

//返回分区个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//cell显示内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cell = @"cell";
        OneDetailTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
        if (tableCell == nil) {
            tableCell = [[OneDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        }
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //防止数组越界
        if (indexPath.row < self.discountsArray.count) {
            tableCell.detailModel = self.discountsArray[indexPath.row];
        }
        return tableCell;
        
    } else{
        static NSString *cellId = @"cellId";
        TwoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[TwoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < self.dataArray.count) {
            cell.twoModel = self.dataArray[indexPath.row];
           
        }
        return cell;
        
    }
    
}


//点击方法

//返回每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return kHeight * 0.4 + 10;
    } else {
        return kHeight * 0.1 + 10;
    }

}

//返回区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

//自定义分区头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 39, kWidth / 3, 2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 10 , 20, kWidth / 3 - 10, 30)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 , 39, kWidth / 3 - 5, 2)];
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label1.alpha = 0.1;
    label2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label2.alpha = 0.1;
    
    if (section == 0) {
        label.text = @"商户优惠";
    }else {
    label.text = @"精彩推荐";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    
    [headerView addSubview:label1];
    [headerView addSubview:label];
    [headerView addSubview:label2];
    return headerView;
    
}

//头部视图
- (void)configTableViewHeader {
    //图片需要拼接的URl
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSArray *picUrlArray = self.headerDic[@"mallPirUrl"];
    NSString *mallUrl = picUrlArray[0];
    //头部图片
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, kWidth -10, kWidth * 0.335)];
    [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, mallUrl]] placeholderImage:nil];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kWidth * 0.335 + 5, kWidth - 10, 30)];
    titleLabel.text = [NSString stringWithFormat:@"%@",self.headerDic[@"mallName"]];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //营业时间
    NSString *closeTime = self.headerDic[@"closeTime"];
    NSString *openTime = self.headerDic[@"openTime"];
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, kWidth * 0.335 + 40, kWidth / 4, 30)];
    currentLabel.text = @"营业时间:";
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.textColor = kColor;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 85, kWidth * 0.335 + 40, kWidth / 4 + 20, 30)];
    timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",openTime, closeTime];
    timeLabel.textColor = kColor;
    //距离
    UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn.frame = CGRectMake(100, kWidth * 0.335 + 75, kWidth - 200, 30);
    [distanceBtn setTitle:[NSString stringWithFormat:@"%@ km",self.headerDic[@"distance"]] forState:UIControlStateNormal];
    //设置图片和内容的间距
    [distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [distanceBtn setImage:[UIImage imageNamed:@"address_icon"] forState:UIControlStateNormal];
    [distanceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //地址导航
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(20, kWidth * 0.335 + 110, kWidth - 40, 30);
    [addressBtn setTitle:[NSString stringWithFormat:@"%@",self.headerDic[@"address"]] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置图片和内容的间距
    [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [addressBtn setImage:[UIImage imageNamed:@"address_ico"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //入住商户
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, kWidth * 0.335 + 160, kWidth / 3, 2)];
    label1.alpha = 0.1;
    
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 32 , kWidth * 0.335 + 145, kWidth / 3 - 10, 30)];
    label2.text = @"入住商户";
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 , kWidth * 0.335 + 160, kWidth / 3 - 5, 2)];
    label3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label3.alpha = 0.1;
    //for循环创建8个按钮
    for (int i = 0; i < 8; i++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 4) {
            button1.frame = CGRectMake(kWidth / 4 * i + 5, kWidth * 0.335 + 180, kWidth / 4 - 10, kWidth / 4 - 10);
            button1.tag = i;
            NSString *imageStr = [NSString stringWithFormat:@"classify%02d",i + 1];
            [button1 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [self.detailView addSubview:button1];
        } else {
            button1.frame = CGRectMake(kWidth / 4 * (i - 4) + 5, kWidth * 0.335 + 180 + kWidth / 4 - 5, kWidth / 4 - 10, kWidth / 4 - 10);
            button1.tag = i;
            NSString *imageStr = [NSString stringWithFormat:@"classify%02d",i + 1];
            [button1 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            
            [self.detailView addSubview:button1];
        }
        [button1 addTarget:self action:@selector(classfiyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    
    [self.detailView addSubview:label1];
    [self.detailView addSubview:label2];
    [self.detailView addSubview:label3];
    [self.detailView addSubview:addressBtn];
    [self.detailView addSubview:distanceBtn];
    [self.detailView addSubview:timeLabel];
    [self.detailView addSubview:currentLabel];
    [self.detailView addSubview:titleLabel];
    [self.detailView addSubview:headerView];
    self.tableView.tableHeaderView = self.detailView;
    
}


//八个按钮的点击方法
- (void)classfiyBtnAction:(UIButton *)btn {
    //取出按钮的id
    NSMutableArray *categoryArray = self.headerDic[@"category"];
    if (btn.tag) {
        self.categoryBtnId = categoryArray[btn.tag][@"categoryId"];
        BrandViewController *brandVC = [[BrandViewController alloc] init];
        brandVC.catId = self.categoryBtnId;
        brandVC.tranlArray = categoryArray;
        [self.navigationController pushViewController:brandVC animated:YES];
        
    }
    
   
}

//打开地图导航按钮
- (void)addressBtnAction:(UIButton *)btn {


}

//返回按钮
- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];

}

//导航栏右侧按钮点击方法
- (void)rightBtnAction:(UIButton *)btn {
    //点击喜爱
    if (btn.tag == 1) {
        clickCount += 1;
        if (clickCount % 2 != 0) {
            [self.likeButton setImage:[UIImage imageNamed:@"favoryes"] forState:UIControlStateNormal];
        } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
        }
    }
    //点击分享
    
    

}




#pragma mark ---------------------------- 懒加载

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 45) style:UITableViewStylePlain];
        self.tableView.rowHeight = kHeight * 0.1 + 10;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

-(NSMutableArray *)discountsArray {
    if (_discountsArray == nil) {
        self.discountsArray = [NSMutableArray new];
    }
    return _discountsArray;
}

-(NSDictionary *)headerDic {
    if (_headerDic == nil) {
        self.headerDic = [NSDictionary dictionary];
    }
    return _headerDic;
}

- (UIView *)detailView{
    if (_detailView == nil) {
        self.detailView = [[UIView alloc] init];
        self.detailView.frame=CGRectMake(0, 10, kWidth, kWidth * 0.335 + 180 + kWidth / 4 + kWidth / 4 - 15);
    }
    return _detailView;
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
