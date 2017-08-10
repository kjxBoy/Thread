//
//  JXOperation.m
//  NSOperation部分
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXOperation.h"

@implementation JXOperation

- (void)main
{
    NSLog(@"\n自定义的队列,在%@.m中重写main函数 \n所在线程 ：%@",self,[NSThread currentThread]);
}

@end
