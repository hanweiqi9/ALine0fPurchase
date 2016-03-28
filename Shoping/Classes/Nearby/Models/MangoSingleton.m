//
//  MangoSingleton.m
//  UILessonTwelve -- Singltongiten
//
//  Created by scjy on 15/12/3.
//  Copyright (c) 2015年 WangXueJuan. All rights reserved.
//

#import "MangoSingleton.h"

@implementation MangoSingleton

//2.静态单例类的实例 ，并初始化设置为nil
static MangoSingleton *mango = nil;

//3.实力构造检查静态实例对象是否为空实现单例方法
+ (MangoSingleton *)sharInstance{
    if (mango == nil) {
        //4.如果mango这个对象为空的话，就去创建一个新对象
        mango = [[MangoSingleton alloc] init];
    }
    return mango;
}

-(NSMutableArray *)idArray {
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;

}


@end
