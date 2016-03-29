//
//  SearchBeij.h
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchBeij : NSObject
@property (nonatomic, strong) NSString *brandLogoUrl;
@property (nonatomic, strong) NSString *brandNameEn;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
