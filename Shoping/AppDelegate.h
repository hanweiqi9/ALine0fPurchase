//
//  AppDelegate.h
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *appKey = @"c8bc55807272329cce2f71d0";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


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

