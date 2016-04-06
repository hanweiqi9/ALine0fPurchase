//
//  SearchResultViewController.m
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ResultTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SearchResultModel.h"
#import "VOSegmentedControl.h"
#import "SearchBeij.h"
#import "BrandDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ShopBrandDetailViewController.h"
#define kSearchShop @"http://api.gjla.com/app_admin_v400/api/searchkeywords/searchList?pageSize=10&longitude=112.426781&latitude=34.618738&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1"
#define kBeiJIng @"http://api.gjla.com/app_admin_v400/api/searchkeywords/searchList?pageSize=10&longitude=112.42679&latitude=34.618716&searchType=1&keywords=%E5%8C%97%E4%BA%AC&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1"
/*
 http://api.gjla.com/app_admin_v400/api/searchkeywords/searchList?pageSize=10&longitude=112.426774&latitude=34.618737&searchType=3&keywords=%E5%90%89%E7%9B%9B%E4%BC%9F%E9%82%A6%E8%99%B9%E6%A1%A5%E8%BF%9B%E5%8F%A3%E5%AE%B6%E4%BF%AC%E9%A6%86&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1
 */

@interface SearchResultViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger type;

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) VOSegmentedControl *segmentControl;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"搜索结果";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    type = 2;
    [self requestData];
    [self.view addSubview:self.segmentControl];
    [self initButton];

    
}

- (void)initButton {
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;



}

//网络请求
- (void)requestData {
        AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
        [sessionManger GET:[NSString stringWithFormat:@"%@&searchType=%ld&keywords=%@",kSearchShop, (long)type,self.result] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = responseObject;
            NSArray *array = responseDic[@"datas"];
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
           
            for (NSDictionary *dic in array) {
                if (type == 2) {
                    SearchResultModel *model = [[SearchResultModel alloc] initWithDictionaryAq:dic];
                    
                [self.dataArray addObject:model];
                } else if (type == 1) {
                    SearchBeij *beiModel = [[SearchBeij alloc] initWithDictionary:dic];
                    
                [self.dataArray addObject:beiModel];
                }
                else if (type == 3){
                    SearchResultModel *model = [[SearchResultModel alloc] initWithDictionaryAq:dic];
                    
                    [self.dataArray addObject:model];
                }
                
            }
            
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }

//协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    if (type == 2) {
        cell.searchModel = self.dataArray[indexPath.row];

    } else if (type == 1) {
        cell.beiModel = self.dataArray[indexPath.row];
    }
    else if (type == 3){
        cell.searchModel = self.dataArray[indexPath.row];

    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (type == 1) {
        //点击按钮进入品牌详情页面，把对应的id传过去
        BrandDetailViewController *vc = [[BrandDetailViewController alloc] init];
        SearchBeij *model = self.dataArray[indexPath.row];
        vc.brandId = model.brandId;
        if ([model.brandNameEn isEqualToString:@""]) {
            vc.titleId = model.brandNameZn;
        } else {
            vc.titleId = model.brandNameEn;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (type == 2) {
        //点击进入商场详情页面
        ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
        SearchResultModel *model = self.dataArray[indexPath.row];
        shopDetailVC.detailId = model.mallId;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
        
    } else if (type == 3) {
        //点击进入门店详情页面
        ShopBrandDetailViewController *shopBrandVC = [[ShopBrandDetailViewController alloc] init];
        SearchResultModel *model = self.dataArray[indexPath.row];
        shopBrandVC.brandId = model.brandId;
        shopBrandVC.storeId = model.storeId;
        [self.navigationController pushViewController:shopBrandVC animated:YES];
        
        
        
    }
    
}



- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-104) style:UITableViewStylePlain];
        self.tableView.rowHeight = 100;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

-(VOSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"商场"},@{VOSegmentText:@"品牌"},@{VOSegmentText:@"门店"}]];
        
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.selectedIndicatorColor = [UIColor clearColor];
        self.segmentControl.backgroundColor = [UIColor clearColor];
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(80, 60, kWidth - 160, 44);
        self.segmentControl.backgroundColor = [UIColor whiteColor];
        self.segmentControl.indicatorThickness = 2;
        [self.segmentControl addTarget:self action:@selector(segeMentrolAction:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _segmentControl;
}

- (void)segeMentrolAction:(VOSegmentedControl *)seg {
    
    if (seg.selectedSegmentIndex == 0) {
        type = 2;
        [self.dataArray removeAllObjects];
        [self requestData];
        
    } else if (seg.selectedSegmentIndex == 1) {
        type = 1;
        [self.dataArray removeAllObjects];
        [self requestData];

    }else if (seg.selectedSegmentIndex == 2) {
        type = 3;
        [self.dataArray removeAllObjects];
        [self requestData];
    }
    
}

- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;

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
