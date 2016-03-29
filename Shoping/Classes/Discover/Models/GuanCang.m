//
//  GuanCang.m
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "GuanCang.h"
#import <sqlite3.h>

@interface GuanCang ()
{
    NSString *path;
}

@end

@implementation GuanCang

static GuanCang *dataBase = nil;
+(GuanCang *)sharedInstance{
    if (dataBase == nil) {
        dataBase = [[GuanCang alloc] init];
    }
    return dataBase;
}

static sqlite3 *database = nil;

-(void)createDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [documentPath stringByAppendingPathComponent:@"guanCang.sqlite"];
    NSLog(@"%@",path);
}

//打开数据库
-(void)openDataBase{
    if (database != nil) {
        return;
    }else{
        [self createDataBase];//创建数据库
    }
    sqlite3_open([path UTF8String], &database);
    int result = sqlite3_open([path UTF8String], &database);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        [self createDataBaseTable];
    }else{
        NSLog(@"数据库打开失败");
    }
}



//创建数据库表
-(void)createDataBaseTable{
    if (self.btnTag==1) {
        NSString *sql1 = @"create table guan(title text,subTitle text,titImage text)";
        char *error = nil;
        sqlite3_exec(database, [sql1 UTF8String], NULL, NULL, &error);

    }else{
    NSString *sql = @"create table zhu(title text,subTitle text,titImage text,selectId text)";
    char *error = nil;
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error);
    }
}

//-(void)createCangTable{
//    NSString *sql = @"create table guan(title text,subTitle text,titImage text)";
//    char *error = nil;
//    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error);
//}

//关闭数据库表
-(void)closeDataBase{
    int result = sqlite3_close(database);
    if (result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
        database = nil;
    }else{
        NSLog(@"数据库关闭失败");
    }
}

-(void)insertIntoNewModel:(GuanModel *)model1{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"insert into zhu(title,subTitle,titImage,selectId) values(?,?,?,?)";
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSString *title = [NSString stringWithFormat:@"%@",model1.title];
        NSString *subTit = [NSString stringWithFormat:@"%@",model1.subTitle];
        NSString *titImage = [NSString stringWithFormat:@"%@",model1.titImage];
        NSString *selectId = [NSString stringWithFormat:@"%@",model1.selectId];
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [subTit UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [titImage UTF8String],-1 , NULL);
        sqlite3_bind_text(stmt, 4, [selectId UTF8String], -1, NULL);
        sqlite3_step(stmt);
        NSLog(@"语句没有问题");
    }else{
        NSLog(@"语句有问题");
    }
    //释放
    sqlite3_finalize(stmt);
}

-(void)insertIntoCang:(GuanModel *)model{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"insert into guan(title,subTitle,titImage) values(?,?,?)";
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSString *tit = [NSString stringWithFormat:@"%@",model.title];
        NSString *subtit =[NSString stringWithFormat:@"%@",model.subTitle];
        NSString *ima = [NSString stringWithFormat:@"%@",model.titImage];
        sqlite3_bind_text(stmt, 1, [tit UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [subtit UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [ima UTF8String],-1 , NULL);
        sqlite3_step(stmt);
        NSLog(@"语句没有问题");
    }else{
        NSLog(@"语句有问题");
    }
    //释放
    sqlite3_finalize(stmt);
}

//删除
-(void)deleteModelTitle:(NSString *)title1{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"delete from zhu where title = ?";
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
        sqlite3_bind_text(stmt, 1, [title1 UTF8String], -1, NULL);
        sqlite3_step(stmt);
    }else{
        NSLog(@"删除失败");
    }
    sqlite3_finalize(stmt);
}

-(void)deleteCangTitle:(NSString *)title{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"delete from guan where title = ?";
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, NULL);
        sqlite3_step(stmt);
    }else{
        NSLog(@"删除失败");
    }
    sqlite3_finalize(stmt);
}

//查询
-(NSMutableArray *)select{
    [self openDataBase];
    NSString *sql = @"select *from zhu";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *arr = [NSMutableArray new];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt)== SQLITE_ROW) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *modelTit = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 0)];
             NSString *modelsubtit = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 1)];
             NSString *modelimage = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 2)];
             NSString *modelhead = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 3)];
            GuanModel *model = [[GuanModel alloc] init];
            model.title = modelTit;
            model.subTitle = modelsubtit;
            model.titImage = modelimage;
            model.selectId = modelhead;
            [dic setObject:model.title forKey:@"title"];
            [dic setObject:model.subTitle forKey:@"shareContent"];
            [dic setObject:model.titImage forKey:@"mainPicUrl"];
            [dic setObject:model.selectId forKey:@"id"];
            [arr addObject:dic];
        }
    }else{
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    return arr;
    
}

-(NSMutableArray *)selectCang{
    [self openDataBase];
    NSString *sql = @"select *from guan";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *arr = [NSMutableArray new];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt)== SQLITE_ROW) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *modelTit = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 0)];
            NSString *modelsubtit = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 1)];
            NSString *modelimage = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(stmt, 2)];
            GuanModel *model = [[GuanModel alloc] init];
            model.title = modelTit;
            model.subTitle = modelsubtit;
            model.titImage = modelimage;
            [dic setObject:model.title forKey:@"title"];
            [dic setObject:model.subTitle forKey:@"shareContent"];
            [dic setObject:model.titImage forKey:@"mainPicUrl"];
            [arr addObject:dic];
        }
    }else{
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    return arr;

}

@end
