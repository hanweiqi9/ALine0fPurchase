//
//  NearPreferViewController.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
/*
 http://api.gjla.com/app_admin_v400/api/coupon/couponList?districtId=&cityId=391db7b8fdd211e3b2bf00163e000dce&categoryId=&sortType=&pageSize=20&longitude=112.426833&latitude=34.618754&pageNum=1
 
 */
#import "NearPreferViewController.h"
#import "PullingRefreshTableView.h"
#import "NearTableViewCell.h"
#import "UIViewController+Common.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PreferDetailViewController.h"
#import "ActivityMianViewController.h"
#import "ProgressHUD.h"
static NSString *collection = @"collectionView";
static NSString *cellString = @"cellsting";

@interface NearPreferViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSInteger _pageNum;
    NSString *_disId;
}

@property (nonatomic, strong) PullingRefreshTableView *pullTbaleView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityClassArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *leftButton;
@end

@implementation NearPreferViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ self showBackButtonWithImage:@"arrow_left_pink"];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNum = 1;
    self.distitucrd = @"";
    _disId = @"";
    //注册cell
    [self.pullTbaleView registerNib:[UINib nibWithNibName:@"NearTableViewCell" bundle:nil] forCellReuseIdentifier:@"nearCell"];
    [self getCityDownData];
    [self getNearbyData];
    [self.pullTbaleView launchRefreshing];
    
    [self.view addSubview:self.pullTbaleView];
    //黑背景
    self.blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.blankView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:29.0/255.0 blue:29.0/255.0 alpha:0.6];
    self.blankView.hidden = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.blankView.frame;
    [button addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.blankView addSubview:button];
    [self.view addSubview:self.blankView];
    //左导航栏
    //设置左导航栏
    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftButton.frame =CGRectMake(kWidth - 80, 30, 80, 30);
    [self.leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor redColor]];
    [self.leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)backView{
    self.blankView.hidden = YES;
}
- (void)leftBarButtonAction{
    self.blankView.hidden = NO;
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, (self.cityArray.count + 1)* kHeight/16/3+70)];
    white.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(0, 75, kWidth, (self.cityArray.count + 1)* kHeight/16/3);
    [white addSubview:self.collectionView];
    [self.blankView addSubview:white];
    
}
- (void)getCityDownData{
    //
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    /* [ NSString stringWithFormat:@"",self.cityID] */
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/city/cityDistrictList?cityId=%@",self.cityID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
        if (self.cityArray.count > 0) {
            [self.cityArray removeAllObjects];
        }
        for (NSDictionary *dic in data) {
            [self.cityArray addObject:dic];
        }
        [self.pullTbaleView reloadData];
        [self.pullTbaleView tableViewDidFinishedLoading];
        self.pullTbaleView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)getNearbyData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/api/coupon/couponList?districtId=%@&cityId=%@&categoryId=&sortType=&pageSize=20&longitude=112.426833&latitude=34.618754&pageNum=%ld",self.distitucrd,self.cityID,(long)_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.dataArray = dic[@"datas"];
        if(self.dataArray.count == 0 ){
            if (_pageNum != 1) {
                UIAlertController *aletVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"已是所有数据" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [aletVC addAction:action];
            [self.navigationController presentViewController:aletVC animated:YES completion:nil];
            }
            else{
            UIAlertController *aletVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本区域暂无相关内容,请返回重新选择" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [aletVC addAction:action];
            [self.navigationController presentViewController:aletVC animated:YES completion:nil];
            }
        }
        else{
            if (self.refreshing) {
                if (self.cellArray.count > 0) {
                    [self.cellArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in self.dataArray) {
                [self.cellArray addObject:dic];
            }
            [self.pullTbaleView reloadData];
            [self.pullTbaleView tableViewDidFinishedLoading];
            self.pullTbaleView.reachedTheEnd = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark ------------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        NSMutableArray *group = self.cellArray[indexPath.section][@"couponOrDiscounts"];
        NSString *typesting =group[indexPath.row][@"type"];
        if (group.count > 0) {
            if ([typesting compare:@"0"] == NSOrderedSame) {
                cell.imageView.image = [UIImage imageNamed:@"discount_bg.9"];
                //时间日期转换
                //开始日期
                NSTimeInterval start =[ group[indexPath.row][@"beginDate"] integerValue] /1000;
                NSDateFormatter *matter = [[NSDateFormatter alloc] init];
                [matter setDateFormat:@"YYYY/MM/dd"];
                NSDate *timeSter = [NSDate dateWithTimeIntervalSince1970:start ];
                NSString *timeSting = [matter stringFromDate:timeSter];
                //结束
                NSTimeInterval end = [group[indexPath.row][@"endDate"]integerValue] / 1000;
                
                NSDate *timeEnd = [NSDate dateWithTimeIntervalSince1970:end];
                NSDateFormatter *endmatter = [[NSDateFormatter alloc] init];
                [endmatter setDateFormat:@"YYYY/MM/dd"];
                NSString *timeEndSting = [endmatter stringFromDate:timeEnd];
                
                NSString *timeLabels = [NSString stringWithFormat:@"有效期 %@-%@",timeSting,timeEndSting];
                cell.timeLable.text = timeLabels;
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"coupon_bg.9"];
                cell.timeLable.text = @"免费";
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLable.text = group[indexPath.row][@"name"];
        }
        
    }
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *group = self.cellArray[section][@"couponOrDiscounts"];
    return group.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeight / 13+10 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight / 13)];
    headView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.7];
    UIImageView *iconview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kWidth /9, kWidth / 9)];
    [iconview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageString,self.cellArray[section][@"brandLogoUrl"]]] placeholderImage:nil];
    iconview.layer.cornerRadius = 2;
    iconview.layer.masksToBounds = YES;
    [headView addSubview:iconview];
    
    
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake( kWidth /8 + 15, 5, kWidth /3, kWidth /12)];
    lableTitle.text = self.cellArray[section][@"brandNameEn"];
    //    lableTitle.backgroundColor = [UIColor redColor];
    [headView addSubview:lableTitle];
    
    UILabel *diatance = [[UILabel alloc] initWithFrame:CGRectMake(kWidth /3*2, kHeight / 13/3 - 5, kWidth/4,kHeight /13/3 + 5)];
    CGFloat dis =[self.cellArray[section][@"distance"] floatValue];
    diatance.text = [NSString stringWithFormat:@"%.2fkm",dis/1000];
    diatance.textColor = [UIColor grayColor];
    //    diatance.backgroundColor = [UIColor redColor];
    [headView addSubview:diatance];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *group = self.cellArray[indexPath.section][@"couponOrDiscounts"];
    NSString *type = group[indexPath.row][@"type"];
    if ([type isEqual:@"1"]) {
        ActivityMianViewController *activityMianVC = [[ActivityMianViewController alloc] init];
        NSMutableArray *group = self.cellArray[indexPath.section][@"couponOrDiscounts"];
        activityMianVC.cityID = self.cityID;
        activityMianVC.trunId  = group[indexPath.row][@"id"];
        [self.navigationController pushViewController:activityMianVC animated:YES];
    }
    if ([type isEqual:@"0"]) {
        PreferDetailViewController *preferVC = [[PreferDetailViewController alloc] init];
        preferVC.nameId = self.cellArray[indexPath.section][@"brandId"];
        preferVC.cityID = self.cityID;
        NSMutableArray *group = self.cellArray[indexPath.section][@"couponOrDiscounts"];
        preferVC.preferId = group[indexPath.row][@"id"];
        preferVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preferVC animated:YES];
    }
}
#pragma mark ------------- 分类代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cellCollection = [collectionView dequeueReusableCellWithReuseIdentifier:collection forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, cellCollection.frame.size.width  -10, cellCollection.frame.size.height-10)];
        title.textAlignment = NSTextAlignmentCenter;
        title.adjustsFontSizeToFitWidth = YES;
        title.layer.cornerRadius = 5;
        title.backgroundColor = cellCollection.selected?[UIColor redColor]:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.9];
        title.textColor = cellCollection.selected?[UIColor whiteColor]:[UIColor blackColor];
        title.layer.masksToBounds = YES;
        title.text = @"全部";
        [cellCollection addSubview:title];
    }
    if (indexPath.row > 0 && indexPath.row<self.cityArray.count + 1) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, cellCollection.frame.size.width  -10, cellCollection.frame.size.height-10)];
        title.textAlignment = NSTextAlignmentCenter;
        title.adjustsFontSizeToFitWidth = YES;
        title.layer.cornerRadius = 5;
        title.backgroundColor = cellCollection.selected?[UIColor redColor]:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.9];
        title.textColor = cellCollection.selected?[UIColor whiteColor]:[UIColor blackColor];
        title.layer.masksToBounds = YES;
        title.text =  self.cityArray[indexPath.row-1][@"districtName"];
        [cellCollection addSubview:title];
    }
    return cellCollection;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityArray.count + 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.distitucrd = @"";
        _disId = self.distitucrd;
        [self getNearbyData];
        self.blankView.hidden = YES;
        [self.leftButton setTitle:@"全部地区" forState:UIControlStateNormal];
    }
    else{
        self.distitucrd = self.cityArray[indexPath.row - 1][@"districtId"];
        _disId = self.distitucrd;
        [self getNearbyData];
        self.blankView.hidden = YES;
        [self.leftButton setTitle:self.cityArray[indexPath.row - 1][@"districtName"] forState:UIControlStateNormal];
    }
    _pageNum = 1;
}

#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageNum = 1;
    self.distitucrd = _disId;
    [self performSelector:@selector(getNearbyData) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageNum +=1;
    [self performSelector:@selector(getNearbyData) withObject:nil afterDelay:1.0];
}
//手指开始拖动  //取消tableview 区头的粘性

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pullTbaleView tableViewDidScroll:scrollView];
    
    CGFloat sectionHeaderHeight = kHeight / 13+10;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pullTbaleView tableViewDidEndDragging:scrollView];
}

#pragma mark ------------- 懒加载
-(PullingRefreshTableView *)pullTbaleView{
    if (_pullTbaleView == nil) {
        _pullTbaleView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight) pullingDelegate:self];
        self.pullTbaleView.dataSource = self;
        self.pullTbaleView.delegate = self;
        self.pullTbaleView.rowHeight = 90;
        self.pullTbaleView.separatorColor = [UIColor clearColor];
        //隐藏滚动条
//        self.pullTbaleView.showsVerticalScrollIndicator =
        NO;
    }
    return _pullTbaleView;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.02;
        //每一行的间距
        layout.minimumLineSpacing = 5;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 2);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(kWidth/3-3 ,kHeight/20);
        //通过layout布局来创建一个collection
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-100) collectionViewLayout:layout];
        //注册item类型，与下item的设置要一致
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collection];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray new];
    }
    return _cellArray;
}

- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
- (NSMutableArray *)cityClassArray{
    if (_cityClassArray == nil) {
        self.cityClassArray = [NSMutableArray new];
    }
    return _cityClassArray;
}
- (NSMutableArray *)dataArray{
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
