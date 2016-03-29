//
//  SearchResultModel.h
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, strong) NSString *mallOrStorePicUrl;  //图片
@property (nonatomic, strong) NSString *mallOrStoreName;
@property (nonatomic, strong) NSString *mallOrStoreAddress;
@property (nonatomic, strong) NSString *distance;


- (instancetype)initWithDictionaryAq:(NSDictionary *)dic;
@end
