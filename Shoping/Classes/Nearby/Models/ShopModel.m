//
//  ShopModel.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
- (instancetype)initWithDistionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.distance = dic[@"distance"];
        self.mallId = dic[@"mallId"];
        self.mallName = dic[@"mallName"];
        NSString *str = @"http://api.gjla.com/app_admin_v400/";
        //拼接图片URL
        NSString *mallPic = dic[@"mallPicUrl"];
        self.mallPicUrl = [NSString stringWithFormat:@"%@%@",str,mallPic];
        
        NSString *mallThumb = dic[@"mallThumbUrl"];
        self.mallThumbUrl = [NSString stringWithFormat:@"%@%@",str,mallThumb];
    }
    return self;
    
}


@end
