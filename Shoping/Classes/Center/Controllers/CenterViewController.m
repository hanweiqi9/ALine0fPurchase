//
//  CenterViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kCenter @"http://api.liwushuo.com/v2/items?limit=20&gender=2&generation=2"
//"http://api.liwushuo.com/v2/channels/116/items?limit=20&gender=2&generation=2"

//http://api.liwushuo.com/v2/items?limit=20&offset=0&gender=2&generation=2

#import "CenterViewController.h"
#import "CenterTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebCenterViewController.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"



static NSString *itemIdentifier = @"itemIdentifier";
@interface CenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _offset;
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *allArray;
@property(nonatomic,strong) NSMutableArray *allCount;
@property(nonatomic,assign) BOOL refreshing;

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *priceLabel;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"逛吧";
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"CenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIndertifier"];
    
    _offset = 0;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshing = YES;
        [self.collectionView.mj_header beginRefreshing];
        [self requestLoad];
        
    }];
    
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer beginRefreshing];
        self.refreshing = NO;
        _offset += 20;
        [self requestLoad];
       
    }];
    [self requestLoad];
    [self.view addSubview:self.collectionView];


    
    
}



-(void)requestLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld", kCenter,_offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dict = dic[@"data"];
        self.allCount = dict[@"items"];
        if (self.refreshing) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }
        }
        for (NSDictionary *dict1 in self.allCount) {
            [self.allArray addObject:dict1[@"data"]];
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
         [self.collectionView.mj_footer endRefreshing];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark --------- 懒加载

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidth/2-15, kHeight/3+30);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        _offset = 0;

        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"itemIdentifier"];

        
    }
    return _collectionView;
}

-(NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}

-(NSMutableArray *)allCount{
    if (_allCount == nil) {
        self.allCount = [NSMutableArray new];
    }
    return _allCount;
}

#pragma mark-----------代理方法

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemIdentifier" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth/2-15, kWidth/2-20)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.allArray[indexPath.row][@"cover_image_url"]] placeholderImage:nil];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/2-15+2, kWidth/2-15-20, 40)];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.allArray[indexPath.row][@"name"];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/2+30, (kWidth/2-15)/2, 20)];
    self.priceLabel.text = self.allArray[indexPath.row][@"price"];
    self.priceLabel.textColor = [UIColor redColor];
    
    [cell.contentView addSubview:self.priceLabel];
    [cell.contentView addSubview:self.titleLabel];
    [cell.contentView addSubview:self.imageView];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WebCenterViewController *web = [[WebCenterViewController alloc] init];
    web.urlString = self.allArray[indexPath.row][@"url"];
    [self.navigationController pushViewController:web animated:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"购买请登录淘宝账号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

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
