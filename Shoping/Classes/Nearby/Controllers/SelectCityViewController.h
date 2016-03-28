//
//  SelectCityViewController.h
//  Shoping
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectCityDelegate <NSObject>

- (void)getCityName:(NSString *)name cityId:(NSString *)cityId;

@end

@interface SelectCityViewController : UIViewController
@property (nonatomic, assign) id<SelectCityDelegate>delegate;


@end
