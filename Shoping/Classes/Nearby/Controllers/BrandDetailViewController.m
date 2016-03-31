//
//  BrandDetailViewController.m
//  Shoping
//   品牌详情
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "BrandDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "JXBAdPageView.h"
#import "OneDetailTableViewCell.h"
#import "DetailModel.h"
#import "MapViewController.h"
#import "MangoSingleton.h"
#import "ProgressHUD.h"

#import "GuanCang.h"
#import "GuanModel.h"
#import "ShareView.h"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


#define kBrandDetail @"http://api.gjla.com/app_admin_v400/api/brand/detail?cityId=391db7b8fdd211e3b2bf00163e000dce&userId=2ff0ab3508b24d20a87092b06f056c1e&longitude=112.426948&latitude=34.61868&audit="

@interface BrandDetailViewController ()<UITableViewDataSource, UITableViewDelegate, JXBAdPageViewDelegate>
{
    NSInteger clickCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSDictionary *datasDic;
@property (nonatomic, strong) JXBAdPageView *adView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIBarButtonItem *shareBtn;
@property (nonatomic, strong) UIBarButtonItem *rightLikeBtn;
@property(nonatomic,strong) NSString *headImage1;
@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    //自定义导航栏标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4, 0, kWidth / 4, 44)];
    label.text =  self.titleId;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    [self.view addSubview:self.tableView];
    //上下滑动tableView时不让导航栏遮盖
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //创建按钮
    [self initButton];
    //网络请求
    [self requestDataFromNet];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

//创建导航栏按钮
- (void)initButton {
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
    self.rightLikeBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kWidth * 0.75, 0, 30, 30);
    [shareButton setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];



}

//网络请求
- (void)requestDataFromNet {
    [ProgressHUD show:@"正在加载中"];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&brandId=%@", kBrandDetail, _brandId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        self.datasDic = dict[@"datas"];
        NSMutableArray *discountArray = self.datasDic[@"couponOrDiscount"];
        for (NSDictionary *dic in discountArray) {
            DetailModel *model = [[DetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [ProgressHUD showSuccess:@"数据加载完成"];
        [self configheaderTableView];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    


}

#pragma mark ----------------------- 协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellI = @"cellId";
    OneDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellI];
    if (cell == nil) {
        cell = [[OneDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellI];
    }
    
    cell.detailModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItems = @[self.shareBtn, self.rightLikeBtn];
}

//tableView头部视图
- (void)configheaderTableView {
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 0.335)];
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    if ([self.datasDic[@"brandPicUrl"] isEqual:[NSNull null]]) {
        [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.datasDic[@"brandLogoUrl"]]] placeholderImage:nil];
    }else{
        NSString *string = self.datasDic[@"brandPicUrl"];
        NSArray *array = [string componentsSeparatedByString:@","];
        NSString *imageStinf = array[0];
        NSArray *arrays = [imageStinf componentsSeparatedByString:@"|"];
        NSString *images = [NSString stringWithFormat:@"%@%@",str,arrays[0]];
        [headImage sd_setImageWithURL:[NSURL URLWithString:images] placeholderImage:nil];
    }
    [self.headerView addSubview:headImage];
    //logo图标
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(5 , kWidth * 0.4, kWidth / 4, kWidth / 4)];
    NSString *logoUrl = self.datasDic[@"brandLogoUrl"];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, logoUrl]] placeholderImage:nil];
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 10, kWidth * 0.35, kWidth - kWidth / 4 - 20, kWidth / 4 / 3)];
    //取出英文名字
    NSString *enName = self.datasDic[@"brandNameEn"];
    //取出中文名字进行拼接
    NSString *znName = self.datasDic[@"brandNameZh"];
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",enName, znName];
    //descripLab
    UILabel *decripLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 10, kWidth * 0.35 + kWidth / 12 + 5, kWidth - kWidth / 4 - 20 , kWidth * 0.35 - kWidth / 12)];
    decripLabel.numberOfLines = 0;
    if (![self.datasDic[@"brandDesc"] isEqual:[NSNull null]]) {
         decripLabel.text = [NSString stringWithFormat:@"%@",self.datasDic[@"brandDesc"]];
    } else {
       decripLabel.text = @"亲，暂时没有预告哦，请稍后...";
    
    }
   
    //附近门店
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, kWidth * 0.7 + 26, kWidth / 3 - 30, 2)];
    label1.alpha = 0.1;
    
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 30, kWidth * 0.7 + 15, kWidth / 3, 30)];
    label2.text = @"附近门店";
    label2.textColor = [UIColor grayColor];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 + 5 , kWidth * 0.7 + 26, kWidth / 3 - 30, 2)];
    label3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label3.alpha = 0.1;
    //门店label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth / 3 + kWidth / 3 + 60, kWidth - 20, 30)];
    if (![self.datasDic[@"storeName"] isEqual:[NSNull null]]) {
        nameLabel.text = [NSString stringWithFormat:@"%@",self.datasDic[@"storeName"]];
    } else {
    nameLabel.text = @"每个地方都有分店哦";;
    }
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //距离
    UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn.frame = CGRectMake(100, kWidth / 3 + kWidth / 3 + 95, kWidth - 200, 30);
    if (![self.datasDic[@"distance"] isEqual:[NSNull null]]) {
        CGFloat distan = [self.datasDic[@"distance"] floatValue] / 1000;
        [distanceBtn setTitle:[NSString stringWithFormat:@"%.2fkm",distan] forState:UIControlStateNormal];
    } else {
        [distanceBtn setTitle:@"768.80km" forState:UIControlStateNormal];
    
    }
    
    //设置图片和内容的间距
    [distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [distanceBtn setImage:[UIImage imageNamed:@"address_icon"] forState:UIControlStateNormal];
    [distanceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //地址导航
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(20, kWidth / 3 + kWidth / 3 + 130, kWidth - 40, 30);
    //设置图片和内容的间距
    [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [addressBtn setImage:[UIImage imageNamed:@"address22"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (![self.datasDic[@"storeAddress"] isEqual:[NSNull null]]) {
        [addressBtn setTitle:[NSString stringWithFormat:@"%@",self.datasDic[@"storeAddress"]] forState:UIControlStateNormal];
    } else {
    [addressBtn setTitle:@"点击此处查看地图" forState:UIControlStateNormal];
    }
    
    [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.headerView addSubview:addressBtn];
    [self.headerView addSubview:distanceBtn];
    [self.headerView addSubview:nameLabel];
    [self.headerView addSubview:label1];
    [self.headerView addSubview:label2];
    [self.headerView addSubview:label3];
    [self.headerView addSubview:decripLabel];
    [self.headerView addSubview:titleLabel];
    [self.headerView addSubview:logoImage];
    
    self.tableView.tableHeaderView = self.headerView;
    
 NSLog(@"是否是主线程：%d 当前线程：%@",[NSThread isMainThread],[NSThread mainThread]);
}

//_adView的代理方法
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl {
    if (![imgUrl isEqual:[NSNull null]]) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
}


//返回区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

//取消tableview 区头的粘性
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 50.0;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
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
    label.text = @"品牌优惠";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [headerView addSubview:label1];
    [headerView addSubview:label];
    [headerView addSubview:label2];
    return headerView;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.adView removeFromSuperview];
}

//导航栏右侧按钮点击方法
- (void)rightBtnAction:(UIButton *)btn {
    //点击喜爱
    if (btn.tag == 1) {
        clickCount += 1;
        if (clickCount % 2 != 0) {
            [self.likeButton setImage:[UIImage imageNamed:@"favoryes"] forState:UIControlStateNormal];
            
            GuanCang *manager = [GuanCang sharedInstance];
            manager.btnTag = btn.tag;
            GuanModel *model = [[GuanModel alloc] init];
            model.title = [NSString stringWithFormat:@"%@%@",self.datasDic[@"brandNameEn"],self.datasDic[@"brandNameZh"]];
            model.titImage = self.headImage1;
            model.subTitle = self.datasDic[@"brandDesc"];
            [manager insertIntoCang:model];
            [ProgressHUD showSuccess:@"收藏成功"];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
            
            GuanCang *manager = [GuanCang sharedInstance];
            manager.btnTag = btn.tag;
            GuanModel *model = [[GuanModel alloc] init];
            model.title = [NSString stringWithFormat:@"%@%@",self.datasDic[@"brandNameEn"],self.datasDic[@"brandNameZh"]];
            [manager deleteCangTitle:model.title];
            [ProgressHUD showSuccess:@"取消收藏"];
            
            
        }
    }
    //点击分享
    else if(btn.tag == 2){
        ShareView *views = [[ShareView alloc] init];
        views.titStr = [NSString stringWithFormat:@"%@%@",self.datasDic[@"brandNameEn"],self.datasDic[@"brandNameZh"]];
        views.urlStr = self.headImage1;
        [self.view addSubview:views];
    }
    
    
    
}


//地址导航
- (void)addressBtnAction:(UIButton *)btn {
    MapViewController *mapVC = [[MapViewController alloc] init];
    NSString *latitude = self.datasDic[@"latitude"];
    NSString *longitude = self.datasDic[@"longitude"];
    MangoSingleton *mango = [MangoSingleton sharInstance];
    if ([latitude isEqual:[NSNull null]] || [longitude isEqual:[NSNull null]]) {
        mapVC.lat = mango.latValue;
        mapVC.lng = mango.lngValue;
        mango.title = @"每个地方都有分店哦";
        mango.inputText = @"当前位置";
    } else {
        mapVC.lat = [latitude floatValue];
        mapVC.lng = [longitude floatValue];
        NSString *name = self.datasDic[@"storeName"];
        NSString *address = self.datasDic[@"storeAddress"];
        //使用单例传值
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 65) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.rowHeight = kHeight * 0.1 + 10;
        self.tableView.separatorColor = [UIColor clearColor];

        
    }
    return _tableView;
}


-(UIView *)headerView {
    if (_headerView == nil) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth / 3 + kWidth / 3 + 170)];
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
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
