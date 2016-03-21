//
//  UserViewController.m
//  Shoping
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"用户协议";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;

    
    self.webView =[[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    NSString *str = @"http://115.28.144.229:8080/app_web/xieyi?datetime=1458443351087";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
}

-(void)backBtnActivity{
    [self.navigationController popViewControllerAnimated:YES];
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
