//
//  OneBrandModel.m
//  Shoping
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "OneBrandModel.h"

@implementation OneBrandModel
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.brandNameZh = dic[@"brandNameZh"];
        self.brandNameEn = dic[@"brandNameEn"];
        self.brandId = dic[@"brandId"];
        //拼接图片的URl
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        NSString *imageUrl = dic[@"brandLogoUrl"];
        self.brandLogoUrl = [NSString stringWithFormat:@"%@%@",str, imageUrl];
        self.categoryName = dic[@"categorys"];
        
    }
    return self;

}

@end
