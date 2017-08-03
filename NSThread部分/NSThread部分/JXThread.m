//
//  JXThread.m
//  NSThread部分
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXThread.h"

@implementation JXThread

- (void)dealloc
{
    NSLog(@"%@",[NSThread currentThread]);
}

@end
