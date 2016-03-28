//
//  CenterViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kCenter @"http://api.liwushuo.com/v2/channels/116/items?limit=20&gender=2&generation=2"

#import "CenterViewController.h"
#import "CenterTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullingRefreshTableView.h"
#import "HtmlViewController.h"

@interface CenterViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _offset;
}
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *allArray;
@property(nonatomic,assign) BOOL refreshing;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"饰品";

    _offset = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIndertifier"];
    [self.view addSubview:self.tableView];
    [self requestLoad];
    
}

-(void)requestLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld",kCenter,_offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSDictionary *dict = dic[@"data"];
        NSArray *arr = dict[@"items"];
        if (self.refreshing) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }
        }
        for (NSDictionary *dict1 in arr) {
            [self.allArray addObject:dict1];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CenterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIndertifier" forIndexPath:indexPath];
    
    [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:self.allArray[indexPath.row][@"cover_image_url"]] placeholderImage:nil];
    cell.titleLabel.text = self.allArray[indexPath.row][@"title"];
       return cell;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HtmlViewController *html = [[HtmlViewController alloc] init];
    html.type = @"2";
    html.urlString = self.allArray[indexPath.row][@"url"];
    [self.navigationController pushViewController:html animated:YES];
    
}


#pragma mark--------------加载刷新数据
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _offset = 0;
    [self performSelector:@selector(requestLoad) withObject:nil afterDelay:1.0];
    
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _offset += 20 ;
    [self performSelector:@selector(requestLoad) withObject:nil afterDelay:1.0];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark --------- 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.pullingDelegate = self;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 180;
    }
    return _tableView;
}

-(NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
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
