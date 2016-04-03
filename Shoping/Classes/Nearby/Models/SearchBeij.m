//
//  SearchBeij.m
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "SearchBeij.h"

@implementation SearchBeij
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.brandNameEn = dic[@"brandNameEn"];
        self.brandNameZn = dic[@"brandNameZn"];
        //        //拼接图片的URl
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        NSString *imageUrl = dic[@"brandLogoUrl"];
        self.brandLogoUrl = [NSString stringWithFormat:@"%@%@",str, imageUrl];
        self.brandId = dic[@"brandId"];
    }
    return self;
    
}


@end
