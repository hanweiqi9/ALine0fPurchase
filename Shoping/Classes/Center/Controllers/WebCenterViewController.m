//
//  WebCenterViewController.m
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "WebCenterViewController.h"

@interface WebCenterViewController ()
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation WebCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"详情攻略";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -50, kWidth, kHeight+44)];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    [self loadString:self.urlString];
    
    
}

-(void)backBtnActivity{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadString:(NSString *)str{
    NSURL *urlStr = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    [self.webView loadRequest:request];
    
    
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
