//
//  ResetViewController.m
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "ResetViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobSMS.h>

@interface ResetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *getNum;

@property (weak, nonatomic) IBOutlet UITextField *passLabel;


@end

@implementation ResetViewController

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
    self.passLabel.secureTextEntry = YES;
}

-(void)backBtnActivity{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//获取验证码
- (IBAction)getWordAction:(id)sender {
    if (![self checkout]) {
        return;
    }
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andTemplate:@"message" resultBlock:^(int number, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


//重置密码完成
- (IBAction)OverBtnAction:(id)sender {
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.getNum.text andNewPassword:self.passLabel.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            NSLog(@"重置密码失败");
        }
    }];
    
}


-(BOOL)checkout{
    //手机号码
    if (self.phoneNum.text.length <= 0&&[self.phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号码不能为空，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    //移动
    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //联通
    NSString *cm = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //电信
    NSString *cu = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //小灵通
    NSString *ct = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regexter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    NSPredicate *cmtext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cm];
    NSPredicate *cutext =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",cu];
    NSPredicate *cttext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ct];
    
    if (!([regexter evaluateWithObject:self.phoneNum.text]==YES||[cmtext evaluateWithObject:self.phoneNum.text]==YES||[cutext evaluateWithObject:self.phoneNum.text]==YES||[cttext evaluateWithObject:self.phoneNum.text]==YES)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式不正确，请检查" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    NSString *pass = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pass];
    if (![pred evaluateWithObject:self.passLabel.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码格式错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}


//回收键盘
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
