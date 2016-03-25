//
//  LoginViewController.h
//  Shoping
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic ,strong) NSString *userStr;
@property(nonatomic,strong) UIImage *image1;

@end
