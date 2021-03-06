//
//  NearbyViewController.m
//  Shoping
//  主页面
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "NearbyViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "ShopModel.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"
#import "VOSegmentedControl.h"
#import "OneBrandTableViewCell.h"
#import "OneBrandModel.h"
#import "Masonry.h"
#import "ZLDropDownMenuUICalc.h"
#import "ZLDropDownMenu.h"
#import "ZLDropDownMenuCollectionViewCell.h"
#import "NSString+ZLStringSize.h"
#import "BrandDetailViewController.h"
#import "SearchViewController.h"
#import "MangoSingleton.h"
#import "MapViewController.h"
#import "ProgressHUD.h"

#import "GuanCang.h"
#import "GuanModel.h"

#import "JCTagListView.h"
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kCityList @"http://api.gjla.com/app_admin_v400/api/city/cityDistrictList"
#define kBrand @"http://api.gjla.com/app_admin_v400/api/brand/screening?categoryIds=&userId=2ff0ab3508b24d20a87092b06f056c1e&styleIds=&pageSize=20&sortType=1&longitude=112.426851&latitude=34.618758"
#define kBrandClassfiy @"http://api.gjla.com/app_admin_v400/api/brand/screening?&userId=2ff0ab3508b24d20a87092b06f056c1e&styleIds=&pageSize=20&sortType=1&longitude=112.426781&latitude=34.618738"

#define kShop @"http://api.gjla.com/app_admin_v400/api/mall/list?pageSize=10&longitude=112.426904&latitude=34.618939"

#define kShopCity @"http://api.gjla.com/app_admin_v400/api/mall/list?pageSize=10&longitude=112.426774&latitude=34.618731"

//获取品牌分类的八个id
#define kCategoryld @"http://api.gjla.com/app_admin_v400/api/mall/mallDetail?userId=2ff0ab3508b24d20a87092b06f056c1e&mallId=e744ef6b518711e5860600163e000dce&longitude=112.426808&latitude=34.618725&audit="

@interface NearbyViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, ZLDropDownMenuDataSource, ZLDropDownMenuDelegate>

{
    //定义请求的页面
    NSInteger _pageCount;
    NSInteger clickCount; //按钮点击次数
    NSString *categoryIds;
    NSString *categoryIds1;
    NSInteger _pageNum;
    NSInteger _pageNum1;
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) PullingRefreshTableView *rightTableView;
@property (nonatomic, assign) BOOL refreshing;  //是否刷新
@property (nonatomic, strong) NSMutableArray *dataArray; //存放数据
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) VOSegmentedControl *segMentControl;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSDictionary *nameIdDic;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) JCTagListView *tagListView;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *distituId;
@property (nonatomic, strong) NSMutableArray *categoryIdArray;
@property (nonatomic, assign) BOOL selectMenu;//判断选择的是商场or品牌
@end

@implementation NearbyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _pageCount = 1;
    _pageNum1 = 1;
    self.selectMenu = YES;
    self.distituId = @"";
    [self.view addSubview:self.tableView];

    //添加导航栏按钮
    //将自定义segMentControl作为导航栏的title
    self.navigationItem.titleView = self.segMentControl;
    //添加主标题选项
    _mainTitleArray = @[@"全部",@"类型",@"离我最近"];
    _subTitleArray = @[@[@"全部"],@[@"全部",@"女士服装",@"女士鞋包",@"美容美妆",@"钟表配饰",@"母婴亲子",@"男士服装",@"男士鞋包",@"生活家居"],@[@"离我最近"]];
    //网络请求
    [self.tableView launchRefreshing];
    [self requestCategotyIdData];
    //    [self requesCityName];
    
}

//添加导航栏按钮
- (void)initButton {
    //自定义导航栏左侧选择城市按钮
    self.cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cityButton.frame = CGRectMake(0, 0, 60, 44);
    [self.cityButton setImage:[UIImage imageNamed:@"sanjiao_up"] forState:UIControlStateNormal];
    [self.cityButton setTitle:self.cityName forState:UIControlStateNormal];
    [self.cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.cityButton.frame.size.width - 10, 0, 0)];
    [self.cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 10)];
    [self.cityButton addTarget:self action:@selector(selectCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cityBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButton];
    self.navigationItem.leftBarButtonItem = cityBtnItem;
    
    //自定义导航栏右侧搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(kWidth * 0.75, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"search_icon1"] forState:UIControlStateNormal];
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [searchButton addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchBtn;
}

//添加向右滑动的轻扫手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recoginer {
    if (recoginer.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.segMentControl.selectedSegmentIndex = 1;
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self.view addSubview:self.rightTableView];
        
    }
}

#pragma mark -------------------------------- 网络请求

//商场-开始网络请求
- (void)requestData {
    [ProgressHUD show:@"正在加载..."];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *string = [NSString stringWithFormat:@"%@&cityId=%@&pageNum=%ld&districtId=%@",kShop,self.cityId, (long)_pageCount,_distituId];
    [manger GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responDic = responseObject;
        NSArray *datasArray = responDic[@"datas"];
        if(datasArray.count == 0){
            //            if (_pageCount == 1) {
            [ProgressHUD dismiss];
            UIAlertController *aletVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本区域暂无相关内容,请返回重新选择" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [aletVC addAction:action];
            [self.navigationController presentViewController:aletVC animated:YES completion:nil];
            //            }
        }
        else{
            if (self.refreshing) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
            }
            
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datasArray) {
                ShopModel *model = [[ShopModel alloc] initWithDistionary:dic];
                [self.dataArray addObject:model];
            }
            [ProgressHUD showSuccess:@"数据加载完成"];
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

//根据城市获取城市区域id和name
- (void)requesCityName {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    NSString *string = [NSString stringWithFormat:@"%@?cityId=%@",kCityList,self.cityId];
    [sessionManger GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resDic = responseObject;
        NSMutableArray *listArray = resDic[@"datas"];
        if (self.idArray.count > 0 || self.cityArray.count > 0) {
            [self.idArray removeAllObjects];
            [self.cityArray removeAllObjects];
        }
        for (NSDictionary *dic in listArray) {
            NSString *districtId = dic[@"districtId"];
            NSString *districtName = dic[@"districtName"];
            [self.idArray addObject:districtId];
            [self.cityArray addObject:districtName];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

//获取品牌分类的八个id
- (void)requestCategotyIdData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:kCategoryld parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSDictionary *datasDic = dict[@"datas"];
        self.categoryIdArray = datasDic[@"category"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

//品牌菜单栏选择网络请求
- (void)requestMenueData{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    //    NSString *string = [NSString stringWithFormat:@"%@&cityId=%@&categoryIds=%@&pageNum=%ld",kBrandClassfiy,self.cityId,categoryIds1,(long)_pageNum1];
    
    [sessionManger GET:[NSString stringWithFormat:@"%@&cityId=%@&categoryIds=%@&pageNum=%ld",kBrandClassfiy,self.cityId,categoryIds1,(long)_pageNum1] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.nameIdDic = responseObject;
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        NSMutableArray *array = self.nameIdDic[@"datas"];
        //判断取出的数组是否为空
        if (![array isEqual:[NSNull null]]) {
            for (NSDictionary *dic in array) {
                OneBrandModel *model = [[OneBrandModel alloc] initWithDictionary:dic];
                [self.listArray addObject:model];
                
            }
            
        }
        //rightTableView加载完成
        [self.rightTableView tableViewDidFinishedLoading];
        self.rightTableView.reachedTheEnd = NO;
        [self.rightTableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


//第二种tableView
//网路请求
- (void)requestBrandData{
    [ProgressHUD show:@"正在加载中"];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&cityId=%@&pageNum=%ld",kBrand,self.cityId,(long)_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.nameIdDic = responseObject;
        //如果是下拉刷新，则清除数组中所有数据
        if (self.refreshing) {
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }
        }
        NSMutableArray *array = self.nameIdDic[@"datas"];
        //判断取出的数组是否为空
        if (![array isEqual:[NSNull null]]) {
            for (NSDictionary *dic in array) {
                OneBrandModel *model = [[OneBrandModel alloc] initWithDictionary:dic];
                [self.listArray addObject:model];
            }
        }
        //rightTableView加载完成
        [self.rightTableView tableViewDidFinishedLoading];
        self.rightTableView.reachedTheEnd = NO;
        [self.rightTableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

#pragma mark -------------------------- 协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        ShopTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCell"];
        }
        cell.shopModel = self.dataArray[indexPath.row];
        return cell;
    }
    if ([tableView isEqual:self.rightTableView]) {
        //第二种tableView
        static NSString *cellId = @"cellId";
        OneBrandTableViewCell *cell = [self.rightTableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OneBrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.oneModel = self.listArray[indexPath.row];
        cell.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.btn.frame = CGRectMake(kWidth *0.75 +40, kWidth/8+24, kWidth*0.1-13, kWidth*0.1-13);
        [cell.btn setImage:[UIImage imageNamed:@"brand_favor_no"] forState:UIControlStateNormal];
        cell.btn.tag = indexPath.row;
        [cell.btn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.btn];
        
        return cell;
        
    }
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.dataArray.count;
    } else if ([tableView isEqual:self.rightTableView]) {
        return self.listArray.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
        ShopModel *model = self.dataArray[indexPath.row];
        shopDetailVC.detailId = model.mallId;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    } else if ([tableView isEqual:self.rightTableView]){
        //点击按钮进入详情页面，把对应的id传过去
        BrandDetailViewController *vc = [[BrandDetailViewController alloc] init];
        OneBrandModel *model = self.listArray[indexPath.row];
        vc.brandId = model.brandId;
        if ([model.brandNameEn isEqualToString:@""]) {
            vc.titleId = model.brandNameZh;
        } else {
            vc.titleId = model.brandNameEn;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

//返回分区头部标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.rightTableView]) {
        return @">5km";
    }
    return nil;
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        _pageCount = 1;
        self.refreshing = YES;
        [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
    } else if ([tableView isEqual:self.rightTableView]) {
        _pageNum = 1;
        self.refreshing = YES;
        [self performSelector:@selector(requestBrandData) withObject:nil afterDelay:1.0];
        
    }
    
}


//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        _pageCount += 1;
        self.refreshing = NO;
        [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
    } else if ([tableView isEqual:self.rightTableView]) {
        _pageNum += 1;
        self.refreshing = NO;
        [self performSelector:@selector(requestBrandData) withObject:nil afterDelay:1.0];
        
    }
    
}


//取消tableview 区头的粘性
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 30.0;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if(scrollView.contentOffset.y >= sectionHeaderHeight){
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    [self.tableView tableViewDidScroll:scrollView];
    [self.rightTableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    [self.rightTableView tableViewDidEndDragging:scrollView];
}

- (void)hiddenSelectView{
    self.selectView.hidden = YES;
}
//选择城市按钮
- (void)selectCityBtnAction{
    [self.cityButton setImage:[UIImage imageNamed:@"sanjiao_down"] forState:UIControlStateNormal];
    self.selectView.hidden = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.selectView.frame.size.width, self.selectView.frame.size.height);
    [button addTarget:self action:@selector(hiddenSelectView) forControlEvents:UIControlEventTouchUpInside];
    [self.selectView addSubview:button];
    [self.view addSubview:self.selectView];
    self.tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 20, kWidth, kWidth- 30)];
    self.tagListView.canSelectTags = YES;
    self.tagListView.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:self.tagListView];
    [self requesCityName];
    NSArray *array;
    if (self.tagListView.tags > 0 || array.count > 0) {
        [self.tagListView.tags removeAllObjects];
        array = nil;
    }
    //把可变数组转换成不可变数组
    array = [NSArray arrayWithArray:self.cityArray];
    //然后添加到tagView上
    [self.tagListView.tags addObjectsFromArray:array];
    //刷新collectionView
    [self.tagListView.collectionView reloadData];
    __block NearbyViewController *weakSelf = self;
    //点击方法
    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
        _distituId = self.idArray[index];
        weakSelf.selectView.hidden = YES;
        _pageCount = 1;
        [weakSelf requestData];
        [weakSelf.cityButton setImage:[UIImage imageNamed:@"sanjiao_up"] forState:UIControlStateNormal];
        
    }];
}

//实现点击收藏的代理方法
-(void)likeAction:(UIButton *)btn {
    clickCount += 1;
    if (clickCount % 2 != 0) {
        [btn setImage:[UIImage imageNamed:@"brand_favor_yes"] forState:UIControlStateNormal];
        GuanCang *manager =[GuanCang sharedInstance];
        manager.btnTag = btn.tag;
        GuanModel *model = [[GuanModel alloc] init];
        OneBrandModel *model1 = self.listArray[btn.tag];
        if ([model1.brandNameZh isEqualToString:@""]) {
            model.title = model1.brandNameEn;
        }else{
            model.title = model1.brandNameZh;
        }
        for (NSDictionary *dic in model1.categoryName) {
            model.subTitle = dic[@"categoryName"];
            
        }
        model.titImage = model1.brandLogoUrl;
        model.selectId = model1.brandId;
        [manager insertIntoNewModel:model];
        [ProgressHUD showSuccess:@"收藏成功"];
    } else {
        [btn setImage:[UIImage imageNamed:@"brand_favor_no"] forState:UIControlStateNormal];
        GuanCang *manager =[GuanCang sharedInstance];
        manager.btnTag = btn.tag;
        GuanModel *model = [[GuanModel alloc] init];
        OneBrandModel *model1 = self.listArray[btn.tag];
        if ([model1.brandNameZh isEqualToString:@""]) {
            model.title = model1.brandNameEn;
            [manager deleteModelTitle:model.title];
        }else{
            model.title = model1.brandNameZh;
            [manager deleteModelTitle:model.title];
        }
        [ProgressHUD showSuccess:@"取消收藏"];
        
    }
    
}

//导航栏右侧搜索按钮
- (void)searchBtnAction:(UIButton *)btn {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
}

//segMent的点击选择方法
- (void)segeMentrolAction:(VOSegmentedControl *)segMent {
    switch (segMent.selectedSegmentIndex) {
        case 0:
            self.selectMenu = YES;
            if (self.rightTableView) {
                [self.rightTableView removeFromSuperview];
                self.rightTableView = nil;
            }
            self.cityButton.hidden = NO;
            [self.view addSubview:self.tableView];
            break;
        case 1: {
            self.selectMenu = NO;
            //第二种tableView
            if (self.tableView) {
                [self.tableView removeFromSuperview];
                self.tableView = nil;
            }
            [self.view addSubview:self.rightTableView];
            _pageNum = 1;
            //往右滑动
            UISwipeGestureRecognizer *recognizer1;
            recognizer1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromRight:)];
            [recognizer1 setDirection:UISwipeGestureRecognizerDirectionRight];
            [self.rightTableView addGestureRecognizer:recognizer1];
            //添加菜单栏选项卡
            ZLDropDownMenu *menu = [[ZLDropDownMenu alloc] initWithFrame:CGRectMake(0, 60, kWidth, 50)];
            menu.delegate = self;
            menu.dataSource = self;
            [self.view addSubview:menu];
            //隐藏城市选择按钮
            self.cityButton.hidden = YES;
            //网路请求
            [self requestBrandData];
            [self requestMenueData];
            [self.rightTableView launchRefreshing];
        }
        default:
            break;
    }
}


//向右的轻扫手势
- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)recognier {
    if (recognier.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.rightTableView removeFromSuperview];
        self.cityButton.hidden = NO;
        self.rightTableView = nil;
        self.segMentControl.selectedSegmentIndex = 0;
    }
}

#pragma mark ----------------------- 菜单栏代理方法

- (NSInteger)numberOfColumnsInMenu:(ZLDropDownMenu *)menu
{
    return self.mainTitleArray.count;
}

- (NSInteger)menu:(ZLDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column
{
    return [self.subTitleArray[column] count];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    return self.mainTitleArray[column];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForRowAtIndexPath:(ZLIndexPath *)indexPath
{
    NSArray *array = self.subTitleArray[indexPath.column];
    return array[indexPath.row];
}

//菜单选择方法
- (void)menu:(ZLDropDownMenu *)menu didSelectRowAtIndexPath:(ZLIndexPath *)indexPath
{
    //初始化数组，用来接收字典的所有 Values
    //    NSArray  *tranlArray = [NSArray array];
    NSArray *array = self.subTitleArray[indexPath.column];
    //当前选中的字符串
    NSString *nameStr = array[indexPath.row];
    for (NSDictionary *dic in self.categoryIdArray) {
        NSArray  *tranlArray = [dic allValues];
        //取出数组中对应的每一个values值
        for (NSString *name in tranlArray) {
            //判断当前选中字符串是否存储在字典中
            if ([nameStr isEqualToString:name]) {
                categoryIds1 = dic[@"categoryId"];
            }
        }
        
    }
    [self requestMenueData];
}


#pragma mark ---------------------- 懒加载
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
    
}

-(PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 60, kWidth , kHeight - 100) pullingDelegate:self];
        self.tableView.rowHeight = kHeight/3;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
        
        //注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"ShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopCell"];
        //添加轻扫手势
        //向左滑动
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.tableView addGestureRecognizer:recognizer];
        
    }
    return _tableView;
    
}

-(PullingRefreshTableView *)rightTableView {
    if (_rightTableView == nil) {
        self.rightTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 110, kWidth, kHeight - 140) pullingDelegate:self];
        self.rightTableView.dataSource = self;
        self.rightTableView.delegate = self;
        self.rightTableView.rowHeight = kWidth / 4 + 10;
        self.rightTableView.separatorColor = [UIColor clearColor];
    }
    return _rightTableView;
}

-(VOSegmentedControl *)segMentControl {
    if (!_segMentControl) {
        self.segMentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"商场"},@{VOSegmentText:@"品牌"}]];
        
        self.segMentControl.contentStyle = VOContentStyleTextAlone;
        self.segMentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segMentControl.backgroundColor = [UIColor clearColor];
        self.segMentControl.selectedBackgroundColor = self.segMentControl.backgroundColor;
        self.segMentControl.allowNoSelection = NO;
        self.segMentControl.frame = CGRectMake(100, 0, kWidth - 200, 44);
        self.segMentControl.indicatorThickness = 2;
        [self.segMentControl addTarget:self action:@selector(segeMentrolAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segMentControl;
    
}

-(NSMutableArray *)cateId {
    if (_cateId == nil) {
        self.cateId = [NSMutableArray new];
    }
    return _cateId;
}

-(NSDictionary *)nameIdDic {
    if (!_nameIdDic) {
        self.nameIdDic = [NSDictionary dictionary];
    }
    return _nameIdDic;
}

-(UIView *)selectView {
    if (_selectView == nil) {
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight)];
        self.selectView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:0.2];
    }
    return _selectView;
}

-(NSMutableArray *)cityArray {
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
-(NSMutableArray *)idArray {
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
    
}
-(NSMutableArray *)categoryIdArray {
    if (_categoryIdArray == nil) {
        self.categoryIdArray = [NSMutableArray new];
    }
    return _categoryIdArray;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"cityName"];
    if (name == nil) {
        self.cityId = @"391db7b8fdd211e3b2bf00163e000dce";
        self.cityName = @"上海";
    }
    else{
        self.cityId = [[NSUserDefaults standardUserDefaults] valueForKey:@"cityId"];
        self.cityName = [[NSUserDefaults standardUserDefaults] valueForKey:@"cityName"];
    }
    [self initButton];

    _pageCount = 1;
    _pageNum1 = 1;
    self.distituId = @"";
    if (self.selectMenu) {
        [self requestData];
    } else {
        [self requestBrandData];
    }
    [self requesCityName];
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
