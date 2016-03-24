//
//  MineViewController.m
//  GlobalShoping
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "MineViewController.h"
#import <BmobSDK/Bmob.h>
#import "LoginViewController.h"


@interface MineViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userPhoneText;
@property (weak, nonatomic) IBOutlet UITextField *userPassText;



@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    self.userPassText.secureTextEntry = YES;

}

#pragma mark-------------登陆后界面
//登陆
- (IBAction)loginBtnAction:(id)sender {
   [BmobUser loginWithUsernameInBackground:self.userPhoneText.text password:self.userPassText.text block:^(BmobUser *user, NSError *error) {
       if (user) {
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //登陆后
               LoginViewController *login = [[LoginViewController alloc] init];
               login.userStr = self.userPhoneText.text;
               [self.navigationController pushViewController:login animated:YES];
               
           }];
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           [alert addAction:action];
           [alert addAction:cancelAction];
           [self presentViewController:alert animated:YES completion:nil];
           
           NSLog(@"%@",user);
       }else{
           NSLog(@"登陆失败");
       }
   }];
}



-(void)backBtnActivity{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
