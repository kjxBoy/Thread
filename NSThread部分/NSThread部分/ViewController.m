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

@property (nonatomic,assign)NSInteger ticketCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.ticketCount = 100;
   
    [self testSaleTicket];
}


/**
 线程安全
 */
- (void)testSaleTicket{
    
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    threadA.name = @"售票员A";
    [threadA start];
    
    
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    threadB.name = @"售票员B";
    [threadB start];
    
    
    NSThread *threadC = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    threadC.name = @"售票员C";
    [threadC start];
}


/**
 生命周期
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
 线程优先级
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

#pragma mark - 其他

- (void)run:(NSString *)runName
{
    for (NSInteger i = 0; i < 5; i++) {
        NSLog(@"%zd -- %@",i , [NSThread currentThread].name);
    }
}



- (void)saleTicket
{
    while (1) {
        
        
        /**
         锁：必须是全局唯一的
         * 1.注意加锁的位置
         * 2.注意加锁的前提条件，多线程共享同一块资源
         * 3.注意加锁是需要代价的，需要耗费性能的
         * 4.加锁的结果：线程同步
         */
       
        @synchronized (self) { //如果把互斥锁去掉可以看到重复卖票的情况
            
            NSInteger count = self.ticketCount;
            if (count >0) {
                //卖票
                self.ticketCount = count - 1;
                for (int i = 0; i < 10000000; ++i) {
                    
                }
                NSLog(@"%@卖出去了一张票,还剩下%zd张票",[NSThread currentThread].name,self.ticketCount);
            }else
            {
                //提示用户票已经卖完
                NSLog(@"%@发现票已经卖完啦",[NSThread currentThread].name);
                break;
            }
            
        }
        
    }
    
}


@end
