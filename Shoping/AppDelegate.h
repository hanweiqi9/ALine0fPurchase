//
//  AppDelegate.h
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *wbtoken;
    NSString *wbCurrentUserID;
}
@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) UITabBarController *tablebarVC;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end

