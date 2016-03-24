
//
//  BrandViewController.m
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "BrandViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "BrandTableViewCell.h"
#import "BrandModel.h"
#import "Masonry.h"
#import "ZLDropDownMenuUICalc.h"
#import "ZLDropDownMenu.h"
#import "ZLDropDownMenuCollectionViewCell.h"
#import "NSString+ZLStringSize.h"
#import "SearchViewController.h"
#import "ShopBrandDetailViewController.h"
#import "ProgressHUD.h"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kShopBrand @"http://api.gjla.com/app_admin_v400/api/mall/storeList?pageSize=10&mallId=99df3f47f14948a0b8c6aa142a25e967"


@interface BrandViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate, ZLDropDownMenuDataSource, ZLDropDownMenuDelegate, UISearchBarDelegate>


@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *lishtArray;
@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSMutableArray *brandNameArray;
@property (nonatomic, strong) NSDictionary *dictNameId;
@property (nonatomic, strong) ZLDropDownMenu *menu;
@property (nonatomic, strong) UISearchBar *mySearchBar;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 4, kWidth - 100, 40)];
    self.mySearchBar.placeholder = @"搜索品牌、商场、门店";
    self.mySearchBar.backgroundColor = [UIColor clearColor];
    self.mySearchBar.delegate = self;
    self.mySearchBar.keyboardType = UIKeyboardAppearanceDefault;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.layer.masksToBounds = YES;
    self.mySearchBar.layer.cornerRadius = 25.0f;
    
    [self.navigationController.navigationBar addSubview:self.mySearchBar];

    
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    categoryId = self.catId;
    //添加主标题选项
    _mainTitleArray = @[@"全部楼层",@"全部类型",@"智能排序"];
    _subTitleArray = @[@[@"全部楼层",],@[@"全部类型",@"女士服装",@"女士鞋包",@"美容美妆",@"钟表配饰",@"母婴亲子",@"男士服装",@"男士鞋包",@"生活家居"],@[@"智能排序",@"人气最高",@"评价最好",@"独家券",@"所有折扣"]];
    
    self.menu = [[ZLDropDownMenu alloc] initWithFrame:CGRectMake(0, 60, kWidth, 50)];
    //设置代理
    self.menu.delegate = self;
    self.menu.dataSource = self;
    [self.view addSubview:self.menu];
    _pageNum = 1;
    //添加到view上
    [self.view addSubview:self.tableView];
    //网络请求
    [self requestdata];
    [self.tableView launchRefreshing];
}

//网络请求
- (void)requestdata {
    [ProgressHUD show:@"正在加载中"];
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&pageNum=%ld&categoryId=%@",kShopBrand,(long)_pageNum,categoryId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDic = responseObject;
        NSMutableArray *array = responseDic[@"datas"];
        //如果是刷新，移除数组中的元素
        if (self.refreshing) {
            if (self.lishtArray.count > 0) {
                [self.lishtArray removeAllObjects];
            }
        }
//        if (self.lishtArray.count > 0) {
//            [self.lishtArray removeAllObjects];
//        }
            for (NSDictionary *dic in array) {
                BrandModel *braModel = [[BrandModel alloc] initWithDictionary:dic];
                [self.lishtArray addObject:braModel];
                
            }
        [ProgressHUD showSuccess:@"数据加载完成"];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];



}

#pragma mark ------------------------------ 协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.lishtArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    BrandTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BrandTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    self.tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.brandModel = self.lishtArray[indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopBrandDetailViewController *shopBrandVC = [[ShopBrandDetailViewController alloc] init];
    BrandModel *model = self.lishtArray[indexPath.row];
    shopBrandVC.brandId = model.brandId;
    shopBrandVC.storeId = model.storeId;
    [self.navigationController pushViewController:shopBrandVC animated:YES];
    self.mySearchBar.hidden = YES;

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    NSLog(@"123");
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _pageNum = 1;
    self.refreshing = YES;
    [self performSelector:@selector(requestdata) withObject:nil afterDelay:1.0];
}


//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageNum += 1;
    self.refreshing = NO;
        [self performSelector:@selector(requestdata) withObject:nil afterDelay:1.0];
  
    
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ------------------------- 懒加载
-(PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 110, kWidth, kHeight) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = kWidth / 4 + 20;
    }
    return _tableView;

}

-(NSMutableArray *)lishtArray {
    if (_lishtArray == nil) {
        self.lishtArray = [NSMutableArray new];
    }
    return _lishtArray;

}

-(NSMutableArray *)brandNameArray {
    if (_brandNameArray == nil) {
        self.brandNameArray = [NSMutableArray new];
    }
    return _brandNameArray;

}
-(NSDictionary *)dictNameId {
    if (_dictNameId == nil) {
        self.dictNameId = [NSDictionary dictionary];
    }
    return _dictNameId;
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
    NSArray *array = self.subTitleArray[indexPath.column];
    NSString *nameStr = array[indexPath.row];
    //通过属性传值传过来的数组，遍历数组
    for (NSDictionary *dic in self.tranlArray) {
        NSArray *arrayValues = [dic allValues];
      //取出数组中对应的每一个字典的value值
        for (NSString *name in arrayValues) {
            //判断当前选中字符串是否存储在字典中
            if ([nameStr isEqualToString:name]) {
                categoryId = dic[@"categoryId"];
            }
        }

    }
    
    [self requestdata];
    [self.tableView reloadData];
    
}


- (void)backAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    self.mySearchBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mySearchBar.hidden = NO;
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
