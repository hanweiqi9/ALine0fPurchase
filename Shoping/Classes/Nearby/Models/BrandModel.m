//
//  BrandModel.m
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "BrandModel.h"

@implementation BrandModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.brandId = dic[@"brandId"];
        self.storeId = dic[@"storeId"];
        self.brandNameEn = dic[@"brandNameEn"];
        self.brandNameZh = dic[@"brandNameZh"];
        self.floor = dic[@"floor"];
        //拼接图片的URl
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        NSString *storePicURL = dic[@"storeThumbUrl"];
        self.storePicUrl = [NSString stringWithFormat:@"%@%@",str, storePicURL];
         self.categoryName = dic[@"categorys"];
        
        
        
    }

    return self;
}


@end
