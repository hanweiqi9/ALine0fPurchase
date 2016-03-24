//
//  DiscoverViewController.m
//  GlobalShoping
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


//发现 热门
#define kHot @"http://api.gjla.com/app_admin_v400/api/subject/list?pageSize=8&cityId=391db7b8fdd211e3b2bf00163e000dce"

#define kMatch @"http://api.gjla.com/app_admin_v400/api/collocation/list?styleId=&pageSize=8&cityId=bd21203d001c11e4b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f"

#import "DiscoverViewController.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HotTableViewCell.h"
#import "MatchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullingRefreshTableView.h"
#import "ActivityViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageNum;
}
@property(nonatomic,strong) VOSegmentedControl *segmentedController;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *allArray;
@property(nonatomic,strong) NSMutableArray *matchArray;
@property(nonatomic,strong) NSMutableArray *newsArray;
@property(nonatomic,strong) UISwipeGestureRecognizer *leftSwipe;
@property(nonatomic,strong) UISwipeGestureRecognizer *rightSwipe;


@property(nonatomic,assign) BOOL refreshing;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar.topItem setTitleView:self.segmentedController ];
    _pageNum = 1;
    [self.view addSubview:self.tableView];
    
    [self.tableView launchRefreshing];
   
    [self selectChange];

}


-(void)requestLoad{
    AFHTTPSessionManager *sessageManager = [AFHTTPSessionManager manager];
    sessageManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessageManager GET:[NSString stringWithFormat:@"%@&pageNum=%ld",kHot,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSMutableArray *array = dic[@"datas"];
        if (self.refreshing) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in array) {
            [self.allArray addObject:dict];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)matchRequest{
    AFHTTPSessionManager *message = [AFHTTPSessionManager manager];
    message.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [message GET:[NSString stringWithFormat:@"%@&pageNum=%ld",kMatch,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSMutableArray *array = dic[@"datas"];
        if (self.refreshing) {
            if (self.matchArray.count > 0) {
                [self.matchArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in array) {
            [self.matchArray addObject:dict];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark-------------Lazy

-(NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
-(NSMutableArray *)matchArray{
    if (_matchArray == nil) {
        self.matchArray = [NSMutableArray new];
    }
    
    return _matchArray;
    
}

-(NSMutableArray *)newsArray{
    if (_newsArray == nil) {
        self.newsArray = [NSMutableArray new];
    }
    return _newsArray;
}


-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.pullingDelegate = self;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
       
        self.leftSwipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handSwipes:)];
        self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handSwipes:)];
        
        self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.tableView addGestureRecognizer:self.leftSwipe];
        [self.tableView addGestureRecognizer:self.rightSwipe];
        
    }
    return _tableView;
}

-(VOSegmentedControl *)segmentedController{
    if (_segmentedController == nil) {
        self.segmentedController = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"热门"},@{VOSegmentText:@"搭配"}]];
        self.segmentedController.contentStyle = VOContentStyleTextAlone;
        self.segmentedController.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentedController.frame = CGRectMake(kWidth/4, 0, kWidth/2, 44);
        self.segmentedController.indicatorThickness = 2;
        self.segmentedController.selectedSegmentIndex = 0;
        [self.segmentedController addTarget:self action:@selector(selectChange) forControlEvents:UIControlEventValueChanged];
      
    }
    return _segmentedController;
}


-(void)selectChange{
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self requestLoad];
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        [self matchRequest];
    }
}

-(void)handSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.segmentedController.selectedSegmentIndex = 1;
        [self matchRequest];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        self.segmentedController.selectedSegmentIndex = 0;
        [self requestLoad];
    }
}


#pragma mark----------UITableViewDelegate/DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSString *str = @"http://api.gjla.com/app_admin_v400/";
    if (self.segmentedController.selectedSegmentIndex == 0) {
        //重用标示
        [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIden"];
        HotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIden" forIndexPath:indexPath];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.allArray[indexPath.row][@"subjectMainPicUrl"]]] placeholderImage:nil];
         self.tableView.rowHeight = kHeight*1/3+40;
         return cell;
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        [self.tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        MatchTableViewCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.title.text = self.matchArray[indexPath.row][@"title"];
        [cell.imageTop sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.matchArray[indexPath.row][@"mainPicUrl"]]] placeholderImage:nil];
        self.tableView.rowHeight = kHeight *1/2+30;
        return cell;

    }
    static NSString *cell1 = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentedController.selectedSegmentIndex == 0) {
        return self.allArray.count;
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        return self.matchArray.count;
    }
        return self.allArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityViewController *avtivity = [[ActivityViewController alloc] init];
    if (self.segmentedController.selectedSegmentIndex == 0) {
        avtivity.selectId = self.allArray[indexPath.row][@"subjectId"];
        avtivity.userId = @"c649ac4bf87f43fea924f52a2639e533";
        avtivity.type = 1;
    }else if (self.segmentedController.selectedSegmentIndex == 1){
    avtivity.selectId = self.matchArray[indexPath.row][@"collocationId"];
    avtivity.userId= @"fe8d0970f7d4469bb6a8d5fbb1a2bb6f";
    avtivity.type = 2;
    }
    [self.navigationController pushViewController:avtivity animated:YES];
    
}

//#pragma mark -------------pullingDelegate

//下拉
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageNum = 1;
    [self performSelector:@selector(selectChange) withObject:nil afterDelay:1.0];
   }
//上拉
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageNum += 1;
    [self performSelector:@selector(selectChange) withObject:nil afterDelay:1.0];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
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
