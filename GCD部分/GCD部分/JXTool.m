//
//  JXTool.m
//  GCD部分
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXTool.h"

@implementation JXTool


//01 提供一个全局的静态变量(对外界隐藏)
static JXTool *_instance;

//02 重写alloc方法,保证永远只分配一次存储空间
// alloc - > allocWithZone(分配存储空间)

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    /*
     @synchronized(self) {
     if (_instance == nil) {
     _instance = [super allocWithZone:zone];
     }
     }
     */
    
    //只执行一次+线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

//03 提供类方法
+(instancetype)shareTool
{
    return [[self alloc]init];
}

//04 重写copy
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
