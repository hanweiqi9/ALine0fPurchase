//
//  CangDetailViewController.m
//  Shoping
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "CangDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CangDetailViewController ()
@property(nonatomic,strong) UIImageView *HeadView;
@property(nonatomic,strong) UIImageView *titView;
@property(nonatomic,strong) UILabel *titleText;
@property(nonatomic,strong) UILabel *subText;

@end

@implementation CangDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.HeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight/4)];
    [self.HeadView sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:nil];
    [self.view addSubview:self.HeadView];
    
    self.titView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHeight/4+20+64, kWidth/4, kWidth/4)];
    self.titView.layer.cornerRadius = kWidth/15;
    self.titView.layer.masksToBounds = YES;
    [self.titView sd_setImageWithURL:[NSURL URLWithString:self.titImage] placeholderImage:nil];
    [self.view addSubview:self.titView];
    

    self.titleText = [[UILabel alloc] initWithFrame:CGRectMake(10+kWidth/4+10, kHeight/4+20+kWidth/4, kWidth-30-kWidth/4, kWidth/7)];
    self.titleText.numberOfLines = 0;
    self.titleText.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleText.text = self.titleLabel;
    [self.view addSubview:self.titleText];
    
    self.subText = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight/4+20+kWidth/4+10+64, kWidth-20, 200)];
    self.subText.text = self.subLabel;
    self.subText.numberOfLines = 0;
    CGFloat height = [[self class] getTextHeightWithText:self.subText.text];
    CGRect frame = self.subText.frame;
    frame.size.height = height+100;
    self.subText.frame = frame;
    [self.view addSubview:self.subText];
    
    
}

-(void)backBtnActivity{
    [self.navigationController popViewControllerAnimated:YES];
}


+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kWidth - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
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
