//
//  ViewController.m
//  NSOperation部分
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"
#import "JXOperation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //操作队列:自定义队列|主队列
    /*
     自定义队列:[[NSOperationQueue alloc]init]
     特点:默认并发队列,但是可以控制让它变成一个串行队列
     主队列:[NSOperationQueue mainQueue]
     特点:串行队列,和主线程相关(凡是放在主队列中的任务的都在主线程中执行)
     */

    [self reOperation];
}

#pragma mark - 自定义operation(重新里面的main方法)
- (void)reOperation
{
    //自定义operation
    JXOperation *reOperation = [[JXOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:reOperation];
    
}

#pragma mark - 任务加入队列(自定义队列:[[NSOperationQueue alloc]init]),自定义队列默认是并发队列
- (void)operationQueue
{
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"thread:%@ -- 1",[NSThread currentThread]);
    }];

    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"thread:%@ -- 2",[NSThread currentThread]);
    }];

    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"thread:%@ -- 3",[NSThread currentThread]);
    }];
    
    //添加任务
    [operation3 addExecutionBlock:^{
         NSLog(@"thread:%@ -- 3-1",[NSThread currentThread]);
    }];
    
    //自定义operation
    JXOperation *reOperation = [[JXOperation alloc] init];
    
    //NSInvocationOperation
    NSInvocationOperation *operation4 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoad) object:nil];;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    

    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    [queue addOperation:reOperation];
    
    [queue addOperationWithBlock:^{
       
        NSLog(@"thread:%@ -- 5",[NSThread currentThread]);
        
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"thread:%@ -- 6",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"thread:%@ -- 7",[NSThread currentThread]);
    }];
}

- (void)downLoad
{
    NSLog(@"thread:%@ -- 4",[NSThread currentThread]);
}

#pragma mark - 如果一个操作(NSOperation)中的任务数大于一，那么会开启子线程，并发执行任务(任务不一定在子线程，也有可能在主线程执行任务<混淆调用>)
- (void)testOne
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"thread:%@ -- 1",[NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"thread:%@ -- 2",[NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        
        NSLog(@"thread:%@ -- 3",[NSThread currentThread]);
    }];
    
    
    [operation start];
}

#pragma mark - 常用方法
//最大并发数（maxConcurrentOperationCount）

//开始、暂停、继续、取消(在串行队列中使用<最大并发数为1>)
/*
 * 自定义的Operation实现上面的操作会有问题(在main中的方法是一个任务，任务开始了无法暂停)
 */

//操作依赖(不能循环依赖、可以跨队列依赖)和监听完成
- (void)depence
{
    //01 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc]init];
    
    //02 封装操作对象
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5----%@",[NSThread currentThread]);
    }];
    
    //监听任务执行完毕
    op4.completionBlock = ^{
        
        NSLog(@"主人,你的电影已经下载好了,快点来看我吧");
    };
    
    
    //03 设置操作依赖:4->3->2->1->5
    //⚠️ 不能设置循环依赖,结果就是两个任务都不会执行
    [op5 addDependency:op1];
    [op1 addDependency:op2];
    //[op2 addDependency:op1];
    [op2 addDependency:op3];
    [op3 addDependency:op4];
    
    //04 把操作添加到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue2 addOperation:op5];
    

}


#pragma mark - 线程间通信
- (void)threadCommunicate
{
    //01 创建队列
    NSOperationQueue *queue  =[[NSOperationQueue alloc]init];
    
    //02 封装下载图片的操作
    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
        
        //001 url
        NSURL *url = [NSURL URLWithString:@"http://v1.qzone.cc/pic/201412/24/15/00/549a64a564f44476.jpg!600x600.jpg"];
        //002 data
        NSData *data = [NSData dataWithContentsOfURL:url];
        //003 转换
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"Download----%@",[NSThread currentThread]);
        
        //004 在主线程中显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.imageView.image = image;
            NSLog(@"UI----%@",[NSThread currentThread]);
        }];
    }];
    
    //KVO
    //[download addObserver:self forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];
    
    //03 把操作添加到队列
    [queue addOperation:download];
}


@end
