//
//  ViewController.m
//  位移、枚举简单介绍
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"

//第一种枚举
typedef enum
{
    JXDemoTypeTop,
    JXDemoTypeBottom,

}JXDemoType;

//第二种枚举，定义类型
typedef NS_ENUM(NSInteger ,JXType)
{
    JXTypeTop,
    JXTypeBottom,
} ;

//第三种枚举，位移枚举<如果没有0选项，传入0效率最高>
typedef NS_OPTIONS(NSInteger, JXActionType)
{
    //2进制的平移
    JXActionTypeTop = 1 << 0,  // 1 * 2的0次方 0001
    JXActionTypeBottom = 1 << 1, // 1 * 2的1次方 0010
    JXActionTypeLeft = 1 << 2, // 1 * 2的2次方 0100
    JXActionTypeRight = 1 << 3, // 1 * 2的3次方 1000

};


@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self demoType:JXActionTypeTop];
}

- (void)demoType:(JXActionType)actionType
{
    /*
    0001
    0001
   &
    0001
     */
    if (actionType & JXActionTypeTop) {
        NSLog(@"向上");
    }
    
    if (actionType & JXActionTypeBottom) {
        NSLog(@"向下");
    }
    
    if (actionType & JXActionTypeLeft) {
        NSLog(@"向左");
    }
    
    if (actionType & JXActionTypeRight) {
        NSLog(@"向右");
    }
    
}

@end
