//
//  ActivityViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


#define kActivity @"http://api.gjla.com/app_admin_v400/api/subject/detail?&audit="
#define k @"http://api.gjla.com/app_admin_v400/api/subject/detail?&audit="

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MineViewController.h"
#import "ShareView.h"
#import "GuanCang.h"
#import "TabViewController.h"
#import "ProgressHUD.h"

@interface ActivityViewController ()<UIWebViewDelegate>{
    NSInteger clickCount;
}
@property(nonatomic,strong) NSDictionary *dict;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) NSString *str;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) UIButton *zanBtn;
@property(nonatomic,strong) NSString *subTit;
@property(nonatomic,strong) NSString *support;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titles];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.tag = 1;
    self.zanBtn.frame = CGRectMake(kWidth*3/4, 0, kWidth/9, 20);
    [self.zanBtn setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
    
    [self.zanBtn setTintColor:[UIColor clearColor]];
//    [self.zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [self.zanBtn addTarget:self action:@selector(zanActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *oneBtn = [[UIBarButtonItem alloc] initWithCustomView:self.zanBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kWidth*5/6, 0, kWidth/9, 20);
    [shareBtn setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
//    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *twoBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    NSArray *rightBtns = @[twoBtn,oneBtn];
    self.navigationItem.rightBarButtonItems = rightBtns;
    
    [self requestLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.opaque = NO;//不设置这个，背景颜色默认为黑
    self.webView.scrollView.bounces = NO;//禁止滑动
    self.webView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView addSubview:self.headView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
}

-(void)titles{
    if ([self.userId isEqualToString:@"c649ac4bf87f43fea924f52a2639e533"]) {
        self.navigationItem.title = @"热门详情";
    }else if ([self.userId isEqualToString:@"fe8d0970f7d4469bb6a8d5fbb1a2bb6f"]){
        self.navigationItem.title = @"搭配详情";
    }
    
}

#pragma mark-----------Lazy
-(NSDictionary *)dict{
    if (_dict == nil) {
        self.dict = [NSDictionary new];
    }
    return _dict;
}

-(UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, -kHeight*1/2, kWidth, kHeight*1/2)];
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(kHeight*1/2, 0, 0, 0);
        self.webView.scrollView.backgroundColor = [UIColor whiteColor];
        self.headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

-(void)requestLoad{
    AFHTTPSessionManager *message = [AFHTTPSessionManager manager];
    message.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [message GET:[NSString stringWithFormat:@"%@&objId=%@&type=%ld&userId=%@",kActivity,self.selectId,self.type,self.userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.dict = dic[@"datas"];
        self.titleStr = self.dict[@"title"];
        NSString *conStr = self.dict[@"content"];
        self.str = [conStr stringByReplacingOccurrencesOfString:@"ueditorUpload" withString:@"http://api.gjla.com/app_admin_v400/ueditorUpload"];
        self.subTit = self.dict[@"shareContent"];
        self.support = self.dict[@"id"];
        NSString *imStr = @"http://api.gjla.com/app_admin_v400/";
        self.image = [NSString stringWithFormat:@"%@%@",imStr,self.dict[@"mainPicUrl"]];
        
        [self.webView loadHTMLString:self.str baseURL:nil];
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headView.frame.size.width, self.headView.frame.size.height)];
        [image1 sd_setImageWithURL:[NSURL URLWithString:self.image]placeholderImage:nil];
        [self.headView addSubview:image1];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(void)backBtnActivity{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)zanActivity{
    clickCount += 1;
    if (clickCount % 2 != 0) {
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"favor_yes"];
        [self.zanBtn setImage:image.image forState:UIControlStateNormal];
        GuanCang *manager =[GuanCang sharedInstance];
        manager.btnTag = self.zanBtn.tag;
        GuanModel *model = [[GuanModel alloc] init];
        model.title = self.titleStr;
        model.subTitle = self.subTit;
        model.titImage = self.image;
        [manager insertIntoCang:model];
        [ProgressHUD showSuccess:@"收藏成功"];
        
    }else{
        [self.zanBtn setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
        GuanCang *manager =[GuanCang sharedInstance];
        manager.btnTag = self.zanBtn.tag;
        GuanModel *model = [[GuanModel alloc] init];
        model.title = self.titleStr;
        [manager deleteCangTitle:model.title];
        [ProgressHUD showSuccess:@"收藏已删除"];
        
    }
    
    
    
   
    
    
    
    
}
-(void)shareBtn{
    
    ShareView *shareVC = [[ShareView alloc] init];
    shareVC.titStr = self.titleStr;
    shareVC.urlStr = self.image;
    
    [self.view addSubview:shareVC];
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
