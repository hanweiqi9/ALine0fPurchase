//
//  SelectCityViewController.m
//  Shoping
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "SelectCityViewController.h"
#import "JCTagListView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "NearbyViewController.h"
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kCityList @"http://api.gjla.com/app_admin_v400/api/city/cityDistrictList?cityId=391db7b8fdd211e3b2bf00163e000dce"

@interface SelectCityViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JCTagListView *tagListView;
@property (nonatomic, strong) NSMutableArray *idArray;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagListView];
    //网络请求
    [self requestData];
}

- (void)requestData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:kCityList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resDic = responseObject;
        NSMutableArray *listArray = resDic[@"datas"];
        for (NSDictionary *dic in listArray) {
            NSString *districtId = dic[@"districtId"];
            NSString *districtName = dic[@"districtName"];
            [self.idArray addObject:districtId];
            [self.dataArray addObject:districtName];
        }
        //把可变数组转换成不可变数组
        NSArray *array = [NSArray arrayWithArray:self.dataArray];
        //然后添加到tagView上
        [self.tagListView.tags addObjectsFromArray:array];
        //刷新collectionView
        [self.tagListView.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];



}

#pragma mark -------------------- 懒加载
-(JCTagListView *)tagListView {
    if (_tagListView == nil) {
        self.tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 20, kWidth, kHeight / 3)];
        self.tagListView.canSelectTags = YES;
//        self.tagListView.backgroundColor = [UIColor redColor];
        //点击方法
        __block SelectCityViewController *weakself = self;
        [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
            NearbyViewController *nearVC = [[NearbyViewController alloc] init];
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(getCityName:cityId:)]) {
                [weakself.delegate getCityName:weakself.dataArray[index] cityId:weakself.idArray[index]];
                NSLog(@"%@ %@",weakself.dataArray[index], weakself.idArray[index]);
                
            }
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }];
        
    }
    return _tagListView;

}

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)idArray {
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;

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
