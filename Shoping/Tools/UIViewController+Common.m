//
//  UIViewController+Common.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

- (void)showBackButtonWithImage:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(backButtonActton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;

}


-(void)backButtonActton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
