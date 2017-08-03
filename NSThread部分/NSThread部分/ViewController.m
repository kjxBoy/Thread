//
//  ViewController.m
//  NSThread部分
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"
#import "JXThread.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testThreadLifecycle];
   
}

/**
 测试生命周期
 * 线程的生命周期：当线程中的任务执行完毕之后被释放掉
 */
- (void)testThreadLifecycle
{
    JXThread *threadA = [[JXThread alloc] initWithTarget:self selector:@selector(run:) object:@"threadA"];
    threadA.name = @"threadA";
    threadA.threadPriority = 1.0;
    [threadA start];
}




/**
 测试线程优先级
 * 可以看成执行次数threadA > threadB > threadC
 */
- (void)testThreadPriority
{
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"threadA"];
    threadA.name = @"threadA";
    threadA.threadPriority = 1.0;
    [threadA start];
    
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"threadB"];
    threadB.name = @"threadB";
    [threadB start];
    
    NSThread *threadC = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"threadC"];
    threadC.name = @"threadC";
    threadC.threadPriority = 0.1;
    [threadC start];
}

- (void)run:(NSString *)runName
{
    for (NSInteger i = 0; i < 5; i++) {
        
        NSLog(@"%zd -- %@",i , [NSThread currentThread].name);
        
    }
}



@end
