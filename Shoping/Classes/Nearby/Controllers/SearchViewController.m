//
//  SearchViewController.m
//  Shoping
//  搜素页面
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "SearchViewController.h"
#import "JCTagListView.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ShopDetailViewController.h"

#define khotSearch @"http://api.gjla.com/app_admin_v400/api/searchkeywords/keywords?pageSize=6&cityId=391db7b8fdd211e3b2bf00163e000dce&searchType=2&pageNum=1"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JCTagListView *tagListView;
@property (nonatomic, strong) JCTagListView *hotListView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) VOSegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.segmentControl];
    self.view.backgroundColor = [UIColor whiteColor];
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;

    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 4, kWidth - 100, 40)];
    self.mySearchBar.placeholder = @"搜索品牌、商场、门店";
    
    self.mySearchBar.backgroundColor = [UIColor clearColor];
    self.mySearchBar.delegate = self;
    self.mySearchBar.keyboardType = UIKeyboardAppearanceDefault;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.layer.masksToBounds = YES;
    self.mySearchBar.layer.cornerRadius = 25.0f;
    
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    [self.view addSubview:self.tagListView];
    [self.view addSubview:self.hotListView];
    
    UILabel *hotSearLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, kWidth - 40, 30)];
    hotSearLabel.textColor = [UIColor grayColor];
    hotSearLabel.text = @"热门搜索";
    [self.view addSubview:hotSearLabel];
    UILabel *searHosLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.tagListView.frame.size.height + 160, kWidth - 40, 30)];
    searHosLabel.textColor = [UIColor grayColor];
    searHosLabel.text = @"搜索历史";
    [self.view addSubview:searHosLabel];
    
    //网络请求
    [self requestData];
    
    UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyAction:)];
    tapGer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGer];
    
  
}

- (void)returnKeyAction:(UITapGestureRecognizer *)tap {
    [self.mySearchBar resignFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestData {
    AFHTTPSessionManager *manger1 = [AFHTTPSessionManager manager];
    [manger1 GET:khotSearch parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSMutableArray *dataArray = dict[@"datas"];
        for (NSDictionary *dic in dataArray) {
            [self.listArray addObject:dic[@"keywordName"]];
        }
        NSArray *arra1 = [NSArray arrayWithArray:self.listArray];
        [self.tagListView.tags addObjectsFromArray:arra1];
        [self.tagListView.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

#pragma mark ------------------- 协议方法

#pragma mark -------------------------- 懒加载
- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    self.mySearchBar.hidden = YES;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"123");
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"结束编辑");
    return YES;
}

//编辑完成
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //把输入内容添加到数组中
    [self.dataArray addObject:searchText];
    
}

//点击按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.hotListView.canSelectTags = YES;
    [self.hotListView.tags addObject:searchBar.text];
    [self.hotListView.collectionView reloadData];
    
}

-(JCTagListView *)tagListView {
    if (_tagListView == nil) {
        self.tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(20, 150, kWidth - 40, kHeight / 3)];
        self.tagListView.canSelectTags = YES;
//        //点击热门搜索
//            __block SearchViewController *weakself = self;
//            //点击搜索历史
//            [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
//                if (index == 0) {
//                    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] init];
//                    [weakself.navigationController pushViewController:shopDetailVC animated:YES];
//                }
//            }];
//
    }
    return _tagListView;
}

-(JCTagListView *)hotListView {
    if (_hotListView == nil) {
        self.hotListView = [[JCTagListView alloc] initWithFrame:CGRectMake(20, kHeight / 3 + 200, kWidth - 40, kHeight / 3 - 70)];
        
    }
    return _hotListView;
}

-(NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;

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
        self.segmentControl.indicatorThickness = 2;
        [self.segmentControl addTarget:self action:@selector(segeMentrolAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentControl;
    
}

- (void)segeMentrolAction:(VOSegmentedControl *)seg {

    if (seg.selectedSegmentIndex == 0) {
        //当数组元素个数 > 0时，清除元素，重新赋值
        if (self.tagListView.tags.count > 0 || self.listArray.count > 0) {
            [self.tagListView.tags removeAllObjects];
            [self.listArray removeAllObjects];
        }
         [self requestData];
        
    } else if (seg.selectedSegmentIndex == 1) {
        [self.tagListView.tags removeAllObjects];
        self.tagListView.tags = [NSMutableArray arrayWithObjects:@"女士鞋包",@"钟表配饰",@"生活家居", nil];
        [self.tagListView.collectionView reloadData];
    
    }else if (seg.selectedSegmentIndex == 2) {
        //当数组元素个数 > 0时，清除元素，重新赋值
        if (self.tagListView.tags.count > 0 || self.listArray.count > 0) {
            [self.tagListView.tags removeAllObjects];
            [self.listArray removeAllObjects];
        }
        [self requestData];
    
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
