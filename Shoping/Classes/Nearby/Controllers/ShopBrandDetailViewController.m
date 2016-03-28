//
//  ShopBrandDetailViewController.m
//  Shoping
//  商场-分类-品牌-详情页面
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopBrandDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "JXBAdPageView.h"
#import "MapViewController.h"
#import "MangoSingleton.h"
#import "ShBraDetaiTableViewCell.h"
#import "ProgressHUD.h"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kDetail @"http://api.gjla.com/app_admin_v400/api/mall/storeDetail?cityId=391db7b8fdd211e3b2bf00163e000dce&userId=2ff0ab3508b24d20a87092b06f056c1e&longitude=112.426779&latitude=34.618741&audit="


@interface ShopBrandDetailViewController ()<UITableViewDataSource, UITableViewDelegate, JXBAdPageViewDelegate>
{
    NSInteger clickCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSDictionary *datasDic;
@property (nonatomic,strong) JXBAdPageView *adView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIBarButtonItem *shareBtn;
@property (nonatomic, strong) UIBarButtonItem *rightLikeBtn;


@end

@implementation ShopBrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店详情";
    [self.view addSubview:self.tableView];
    //    [self configHeaderTableView];
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ShBraDetaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    //自定义导航栏右侧按钮
    //喜爱
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.frame = CGRectMake(kWidth * 0.75 + 35, 0, 30, 30);
    self.likeButton.tag = 1;
    [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.likeButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightLikeBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kWidth * 0.75, 0, 30, 30);
    [shareButton setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[self.shareBtn, self.rightLikeBtn];
    //网络请求
    [self requestDataFromNet];

}

//网络请求
- (void)requestDataFromNet {
    [ProgressHUD show:@"数据加载中..."];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&brandId=%@&storeId=%@", kDetail, _brandId, _storeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        self.datasDic = dict[@"datas"];
       self.dataArray = self.datasDic[@"sameBrandOtherStores"];
        [ProgressHUD showSuccess:@"数据加载完成"];
        [self.tableView reloadData];
        [self configHeaderTableView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

#pragma mark ----------------------- 协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShBraDetaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        NSString *urlStr = self.dataArray[indexPath.row][@"storePicUrl"];
        NSString *url = [NSString stringWithFormat:@"%@%@",str,urlStr];
        [cell.storeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        cell.titleName.text = self.dataArray[indexPath.row][@"storeName"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//tableView头部视图
- (void)configHeaderTableView {
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSString *brandUrl = self.datasDic[@"storePicUrl"];
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 0.335)];
        [self.headerView addSubview:headImage];
        NSString *brandUrl1 = [str stringByAppendingString:brandUrl];
        [headImage sd_setImageWithURL:[NSURL URLWithString:brandUrl1] placeholderImage:nil];
    
    //logo图标
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 3 + 35, kWidth * 0.35 + 5, kWidth / 8, kWidth / 8)];
    NSString *logoUrl = self.datasDic[@"brandLogoUrl"];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, logoUrl]] placeholderImage:nil];
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 , kWidth * 0.4 + kWidth / 8 - 10, kWidth -60, kWidth / 8 - 10)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@",self.datasDic[@"storeName"]];
    titleLabel.textColor = [UIColor grayColor];
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 8 + 20 , kWidth * 0.4 + kWidth / 8 + kWidth / 8 - 10, kWidth - kWidth / 4 - 40, kWidth / 8 - 20)];
    NSString *openTime = self.datasDic[@"storeOpenTime"];
    NSString *closeTime = self.datasDic[@"storeCloseTime"];
    if ([openTime isEqual:[NSNull null]] || [closeTime isEqual:[NSNull null]]) {
        timeLabel.text = @"24小时营业";
    } else {
    timeLabel.text = [NSString stringWithFormat:@"营业时间 : %@ - %@", openTime,closeTime];
    }
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor grayColor];
    //附近门店
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, kWidth * 0.7 + 28, kWidth / 3 - 30, 2)];
    label1.alpha = 0.1;
    
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 30, kWidth * 0.7 + 15, kWidth / 3, 30)];
    label2.text = @"门店地址";
    label2.textColor = [UIColor grayColor];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 , kWidth * 0.7 + 28, kWidth / 3 - 30, 2)];
    label3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label3.alpha = 0.1;
    //门店label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kWidth / 3 + kWidth / 3 + 60, kWidth - 30, 30)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.datasDic[@"storeName"]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //距离
    UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn.frame = CGRectMake(100, kWidth / 3 + kWidth / 3 + 95, kWidth - 200, 30);
    CGFloat distan = [self.datasDic[@"distance"] floatValue] / 1000;
    [distanceBtn setTitle:[NSString stringWithFormat:@"%.2fkm",distan] forState:UIControlStateNormal];
    //设置图片和内容的间距
    [distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [distanceBtn setImage:[UIImage imageNamed:@"address_icon"] forState:UIControlStateNormal];
    [distanceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //地址导航
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置图片和内容的间距
    [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [addressBtn setImage:[UIImage imageNamed:@"address22"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addressBtn.frame = CGRectMake(20, kWidth / 3 + kWidth / 3 + 130, kWidth - 40, 30);
    [addressBtn setTitle:[NSString stringWithFormat:@"%@",self.datasDic[@"address"]] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.headerView addSubview:addressBtn];
    [self.headerView addSubview:distanceBtn];
    [self.headerView addSubview:nameLabel];
    [self.headerView addSubview:label1];
    [self.headerView addSubview:label2];
    [self.headerView addSubview:label3];
    [self.headerView addSubview:titleLabel];
    [self.headerView addSubview:logoImage];
    [self.headerView addSubview:timeLabel];
    self.tableView.tableHeaderView = self.headerView;
    
    
}

//返回区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

//自定义分区头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 39, kWidth / 3 - 30, 2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 10 , 20, kWidth / 3 - 10, 30)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 , 39, kWidth / 3 - 30, 2)];
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label1.alpha = 0.1;
    label2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label2.alpha = 0.1;
    label.text = @"其他门店";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [headerView addSubview:label1];
    [headerView addSubview:label];
    [headerView addSubview:label2];
    return headerView;
    
}

- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl {
    if (imgUrl != nil) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
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


//地址导航
- (void)addressBtnAction:(UIButton *)btn {
    MapViewController *mapVC = [[MapViewController alloc] init];
    NSString *latitude = self.datasDic[@"latitude"];
    NSString *longitude = self.datasDic[@"longitude"];
    mapVC.lat = [latitude floatValue];
    mapVC.lng = [longitude floatValue];
    NSString *name = self.datasDic[@"storeName"];
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

- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ---------------------------- 懒加载
-(UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.rowHeight = 110;
        
        
    }
    return _tableView;
}


-(UIView *)headerView {
    if (_headerView == nil) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth / 3 + kWidth / 3 + 190)];
    }
    return _headerView;
    
}


-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSDictionary *)datasDic {
    if (_datasDic == nil) {
        self.datasDic = [NSDictionary dictionary];
    }
    return _datasDic;
}

//在页面将要消失的时候去掉所有的圈圈
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];
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
