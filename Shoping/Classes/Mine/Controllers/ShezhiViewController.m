//
//  ShezhiViewController.m
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#import "ShezhiViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "QuanchnegViewController.h"
#import "TuiJianView.h"

@interface ShezhiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *titArray;
@property(nonatomic,strong) UIView *mainView;

@end

@implementation ShezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
     self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"清除缓存", nil];
    self.titArray = [[NSMutableArray alloc] initWithObjects:@"关于时尚逛吧",@"推荐时尚逛吧给好友", nil];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}
-(void)backBtnActivity{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize =[cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存（%.02fM)",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndertifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndertifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndertifier ];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titleArray[indexPath.row];
    }else{
        cell.textLabel.text = self.titArray[indexPath.row];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count;
    }else{
        return self.titArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache cleanDisk];
        [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIStoryboard *quanStory = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            QuanchnegViewController *quanView = [quanStory instantiateViewControllerWithIdentifier:@"story"];
            [self.navigationController pushViewController:quanView animated:YES];
            
        }else{
            TuiJianView *tuiView = [[TuiJianView alloc] init];
            [self.view addSubview:tuiView];
        }
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