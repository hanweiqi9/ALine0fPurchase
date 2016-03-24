//
//  BrandModel.h
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject
@property (nonatomic, strong) NSString *storePicUrl;  //图片
@property (nonatomic, strong) NSString *brandNameEn;  //英文名
@property (nonatomic, strong) NSString *brandNameZh;  //中文名
@property (nonatomic, strong) NSMutableArray *categoryName;  //类型标签
@property (nonatomic, strong) NSString *floor;  //楼层
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *storeId;
//初始化一个字典
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
