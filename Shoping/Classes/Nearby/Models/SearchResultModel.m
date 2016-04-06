//
//  SearchResultModel.m
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
- (instancetype)initWithDictionaryAq:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.mallOrStoreName = dic[@"mallOrStoreName"];
        self.mallOrStoreAddress = dic[@"mallOrStoreAddress"];
        self.distance = dic[@"distance"];
        //拼接图片的URl
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        NSString *imageUrl = dic[@"mallOrStorePicUrl"];
        self.mallOrStorePicUrl = [NSString stringWithFormat:@"%@%@",str, imageUrl];
        self.mallId = dic[@"mallOrStoreId"];
        self.brandId = dic[@"brandId"];
        self.storeId = dic[@"mallOrStoreId"];
        
    }
    return self;
    
}



@end
