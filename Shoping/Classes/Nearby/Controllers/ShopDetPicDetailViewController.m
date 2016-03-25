//
//  ShopDetPicDetailViewController.m
//  Shoping
//  商场详情cell图片点击详情
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopDetPicDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProgressHUD.h"
#define kPicUrl @"http://api.gjla.com/app_admin_v400/"
#define kPicDetail @"http://api.gjla.com/app_admin_v400/api/subject/detail?userId=2ff0ab3508b24d20a87092b06f056c1e&type=1&audit="

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ShopDetPicDetailViewController ()<UIWebViewDelegate>
{
    NSInteger clickCount;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIBarButtonItem *shareBtn;
@property (nonatomic, strong) UIBarButtonItem *rightLikeBtn;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSDictionary *dic;


@end

@implementation ShopDetPicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门详情";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView.scrollView addSubview:self.headView];
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    //自定义导航栏右侧按钮
    //喜爱
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.frame = CGRectMake(kWidth * 0.75 + 35, 0, 30, 30);
    self.likeButton.tag = 1;
    [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.likeButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightLikeBtn = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kWidth * 0.75, 0, 30, 30);
    [shareButton setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    shareButton.tag = 2;
    [shareButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[self.shareBtn, self.rightLikeBtn];

    
    //网络请求
    [self requestData];
    
}

//网络请求
- (void)requestData {
    [ProgressHUD show:@"数据加载中..."];
     AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    NSLog(@"%@&objId=%@",kPicDetail,self.twoModel.subjectId);
    [sessionManger GET:[NSString stringWithFormat:@"%@&objId=%@",kPicDetail,self.twoModel.subjectId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responsDic = responseObject;
        self.dic = responsDic[@"datas"];
        //将字典中取出的字符串进行查找替换
        NSString *conStr = self.dic[@"content"];
        NSString *urlStr = [conStr stringByReplacingOccurrencesOfString:@"ueditorUpload" withString:@"http://api.gjla.com/app_admin_v400/ueditorUpload"];
        //加载html-content
        [self.webView loadHTMLString:urlStr baseURL:nil];
        //初始化一个ImageView
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headView.frame.size.width, self.headView.frame.size.height)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kPicUrl, self.twoModel.mainPicUrl];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        [self.headView addSubview:imageView1];
        [ProgressHUD showSuccess:@"数据加载完成"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

//改变webView字体大小
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'";
    [_webView stringByEvaluatingJavaScriptFromString:str];
   

}

#pragma mark ----------------------- 懒加载
-(UIView *)headView {
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, -kHeight*1/2, kWidth, kHeight*1/2)];
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(kHeight*1/2, 0, 0, 0);
    }
    return _headView;

}

-(NSMutableArray *)keyArray {
    if (_keyArray == nil) {
        self.keyArray = [NSMutableArray new];
    }
    return _keyArray;
}

-(NSDictionary *)dic {
    if (_dic == nil) {
        self.dic = [NSDictionary dictionary];
    }
    return _dic;
}

//导航栏右侧按钮点击方法
- (void)rightBtnAction:(UIButton *)btn {
    //点击喜爱
    if (btn.tag == 1) {
        clickCount += 1;
        if (clickCount % 2 != 0) {
            [self.likeButton setImage:[UIImage imageNamed:@"favoryes"] forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
        }
    }
    //点击分享
    
    
    
}

- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

//在页面将要消失的时候去掉所有的圈圈
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];
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
