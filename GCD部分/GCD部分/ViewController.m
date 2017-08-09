//
//  ViewController.m
//  GCD部分
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self group];
}

#pragma mark - 同步、异步函数与各种队列组合

//异步函数 + 并发队列:会开启多条子线程,所有的任务并发执行
//注意:开几条线程并不是由任务的数量决定的,是有GCD内部自动决定的
-(void)asyncConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 10; i++) {
    
        dispatch_async(queue, ^{
            NSLog(@"%zd --- %@",i , [NSThread currentThread]);
        });
    }
}

//异步函数 + 串行队列:会开启一条子线程,所有的任务在该子线程中串行执行
- (void)asyncSerial
{
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(queue, ^{
            NSLog(@"%zd --- %@",i , [NSThread currentThread]);
        });
    }
}

//异步函数 + 主队列:不会开线程,所有的任务都在主线程中串行执行
- (void)asyncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(queue, ^{
            NSLog(@"%zd --- %@",i , [NSThread currentThread]);
        });
    }
}

//同步函数 + 并发队列:不会开启子线程,所有的任务在当前线程中串行执行
-(void)syncConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_sync(queue, ^{
            NSLog(@"%zd --- %@",i , [NSThread currentThread]);
        });
    }
    
    
}



//同步函数 + 串行队列:不会开启子线程,所有的任务在当前线程中串行执行
- (void)syncSerial
{
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_sync(queue, ^{
            NSLog(@"%zd --- %@",i , [NSThread currentThread]);
        });
        
    }
}

//同步函数 + 主队列(在主线程死锁，死锁是因为主线程等待主队列，主队列等待主线程)



/**
 线程间通信
 */
- (void)toMainThread
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        //处理耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
           //回到主线程处理
            
        });
        
    });
}

/**
 异步函数
 * 如果我没有执行完成，那么后面的也可以执行
 */
- (void)syncFunction
{
    for (NSInteger i = 0;i < 10 ; i++) {
        
        if (i == 4) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%zd",i);
            });
        }else{
            NSLog(@"%zd",i);
        }
    }
}




#pragma mark - GCD常用函数

//一次性代码:整个程序运行过程中只会执行一次 + 本身是线程安全
//应用:单例模式
-(void)once
{
    static dispatch_once_t onceToken;
    NSLog(@"++++++%zd",onceToken);
    
    //内部实现原理:判断onceToken的值 == 0 来决定是否执行block中的任务
    dispatch_once(&onceToken, ^{
        NSLog(@"once------");
    });
    
}

//延迟执行
-(void)delay
{
    NSLog(@"--delay-");
    //延迟执行
    //[self performSelector:@selector(run) withObject:nil afterDelay:2.0];
    
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:NO];
    
    //GCD中的延迟执行
    /* 参数说明
     *
     * 第一个参数:设置时间(GCD中的时间单位是纳秒)
     * 第二个参数:队列(决定block中的任务在哪个线程中执行,如果是主队列就是主线程,否在就在子线程)
     * 第三个参数:设置任务
     * 原理:(哪个简单)
     * A 先把任务提交到队列,然后等两秒再执行 错误
     * B 先等两秒,再把任务提交到队列        正确
     */
    
    //异步方式，不阻塞线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"-----GCD------%@",[NSThread currentThread]);
    });
    
    NSLog(@"--end--");
}

//栅栏函数
-(void)barrier
{
    //需求:有4个任务,要求开启多条线程来执行这些任务
    //增加需求:新的任务++++++,要求在12执行之后执行,要保证该任务执行完之后才能执行后面的34任务
    
    //栅栏函数:前面的任务并发执行,后面的任务也是并发执行
    //当前面的任务执行完毕之后执行栅栏函数中的任务,等该任务执行完毕后再执行后面的任务
    //⚠️ 不能使用全局并发队列
    
    //01 获得队列
    dispatch_queue_t queue = dispatch_queue_create("Test", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //02 封装任务,并且添加到队列
    dispatch_async(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    
    //栅栏函数
    dispatch_barrier_async(queue, ^{
        NSLog(@"+++++++++++");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    
    dispatch_async(queue, ^{
        NSLog(@"4-----%@",[NSThread currentThread]);
    });
    
    
}


//快速迭代(遍历)
-(void)apply
{
    //在当前线程中串行执行(提高效率)
    //1000  1   ==>10天
    //1000  10  ==>1天
    for (int i = 0; i < 10; ++i) {
        NSLog(@"%zd----%@",i,[NSThread currentThread]);
    }
    
    NSLog(@"____________");
    
    dispatch_queue_t queue = dispatch_queue_create("DownloadQueue", DISPATCH_QUEUE_SERIAL);
    
    /* 参数说明
     *
     * 第一个参数:遍历的次数
     * 第二个参数:队列
     */
    //并发队列:会开启多条子线程和主线程一起并发的执行任务
    //主队列:死锁
    //普通的串行的队列:和for循环一样
    dispatch_apply(10, queue, ^(size_t i) {
        
        NSLog(@"%zd----%@",i,[NSThread currentThread]);
    });
    
}


//队列组的使用
-(void)group
{
    //00 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //01 获得并发队列
    dispatch_queue_t queue = dispatch_queue_create("Test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("Test2", DISPATCH_QUEUE_CONCURRENT);
    
    //02 封装任务,添加到队列并监听任务的执行情况
    /*
     //01 封装任务
     //02 把任务添加到队列
     //03 监听任务的执行情况
     dispatch_group_async(group, queue, ^{
     
     });
     
     //01 封装任务
     //02 把任务添加到队列
     dispatch_async(queue, ^{
     NSLog(@"1---%@",[NSThread currentThread]);
     });
     */
    dispatch_group_async(group, queue, ^{
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@"5---%@",[NSThread currentThread]);
    });
    
    //03 拦截通知,当所有的任务都执行完毕后,执行++++操作
    //dispatch_group_notify 内部执行取决于第二个参数所使用的队列类型，如果是全局队列就是子线程，如果是主队列就是主线程
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"++++++++%@",[NSThread currentThread]);
    });
    
    NSLog(@"---end----");
    
}


//单例

@end
