//
//  GuanModel.m
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "GuanModel.h"

@implementation GuanModel


-(instancetype) initWithDictionary:(NSMutableDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.titImage = dic[@"mainPicUrl"];
        self.subTitle = dic[@"shareContent"];
        self.selectId = dic[@"id"];
    }
    return self;
}

@end
