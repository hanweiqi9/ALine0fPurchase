//
//  ShopModel.h
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopModel : NSObject
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString *mallId;
@property (nonatomic, strong) NSString *mallName;
@property (nonatomic, strong) NSString *mallPicUrl;
@property (nonatomic, strong) NSString *mallThumbUrl;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

- (instancetype)initWithDistionary:(NSDictionary *)dic;



@end
