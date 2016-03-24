//
//  DetailModel.h
//  Shoping
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailModel : NSObject
@property (nonatomic, strong) NSString *brandLogoUrl; //图片
@property (nonatomic, strong) NSString *name;    //标题
@property (nonatomic, strong) NSString *beginDate;  //有效时间（起）
@property (nonatomic, strong) NSString *endDate;  //有效时间（止）
@property (nonatomic, strong) NSString *type;    //类型
@property (nonatomic, strong) NSString *discountsId;   //折扣Id
@property (nonatomic, strong) NSString *costPrice;   //优惠价
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@end
