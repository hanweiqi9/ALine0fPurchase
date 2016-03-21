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

@interface NearPreferViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *pullTbaleView;
@end

@implementation NearPreferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [ self showBackButtonWithImage:@"arrow_left_pink"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pullTbaleView];
    
    //注册cell
    [self.pullTbaleView registerNib:[UINib nibWithNibName:@"NearTableViewCell" bundle:nil] forCellReuseIdentifier:@"nearCell"];
}


#pragma mark ------------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ------------- 刷新代理
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
}

#pragma mark ------------- 懒加载
-(PullingRefreshTableView *)pullTbaleView{
    if (_pullTbaleView == nil) {
        _pullTbaleView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) pullingDelegate:self];
        self.pullTbaleView.dataSource = self;
        self.pullTbaleView.delegate = self;
        self.pullTbaleView.rowHeight = 90;
        self.pullTbaleView.separatorColor = [UIColor clearColor];
    }
    return _pullTbaleView;
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
