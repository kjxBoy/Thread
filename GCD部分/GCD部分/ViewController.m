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




@end
