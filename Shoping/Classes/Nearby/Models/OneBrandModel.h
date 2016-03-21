//
//  OneBrandModel.h
//  Shoping
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneBrandModel : NSObject
@property (nonatomic, strong) NSString *brandLogoUrl;
@property (nonatomic, strong) NSString *brandNameZh;
@property (nonatomic, strong) NSMutableArray *categoryName;
@property (nonatomic, strong) NSString *brandNameEn;
@property (nonatomic, strong) NSString *brandId;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
