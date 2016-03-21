//
//  LoginViewController.m
//  Shoping
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UIButton *headBtn;
@property(nonatomic,strong) UILabel *headerLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"我的关注",@"我的收藏",@"我的申领",@"我的评论",@"我的邀请",@"客服中心", nil];
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"my_attention_icon",@"my_favor_icon",@"my_apply_icon",@"my_comment_icon",@"my_invite_icon",@"my_kefuzhongxin", nil];
    
    [self tableViewHeadView];
}


-(void)tableViewHeadView{
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight *4/5)];
    [heardView addSubview:self.headBtn];
    [heardView addSubview:self.phoneLabel];
    self.tableView.tableHeaderView = heardView;
}

#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

-(UILabel *)headerLabel{
    if (_headerLabel == nil) {
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth*1/2)];
        self.headerLabel.backgroundColor = kColor;
    }
    return _headerLabel;
}

#pragma mark--------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewRowActionStyleDestructive;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
            
        default:
            break;
    }
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
