//
//  GuanCang.h
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuanModel.h"

@interface GuanCang : NSObject
//用单例创建数据库对象
+(GuanCang *)sharedInstance;

#pragma mark-------------数据库基本操作
//创建数据库表
-(void)createDataBase;
//创建数据库表
- (void)createDataBaseTable;
//打开数据库表
- (void)openDataBase;
//关闭数据库表
- (void)closeDataBase;

#pragma mark------数据库常用操作
//插入一个新的联系人
-(void)insertIntoNewModel:(GuanModel *)model;

//查询 所有联系人
- (NSMutableArray *)select;

//删除
-(void)deleteModelTitle:(NSString *)title;





@end
