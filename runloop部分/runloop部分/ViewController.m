//
//  ViewController.m
//  runloop部分
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)dispatch_source_t timer;

@property (strong, nonatomic)NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**
     * 每条线程都有唯一的一个与之对应的RunLoop对象
     
     * 主线程的RunLoop已经自动创建好了，子线程的RunLoop需要主动创建
     
     * RunLoop在第一次获取时创建，在线程结束时销毁
     
     */
    
    
    /**
     * 子线程开启线程
     * [NSRunLoop currentRunLoop];
     */
    
    
    //这里是mode(模式)部分
    /**
     * 在runLoop中有多个运行模式，但是runLoop只能选择一种模式运行
     * 模式(mode)里面至少要有一种timer或者Source
     * 系统默认注册了5个Mode<常用的前两种，第五种是前两种的集合>:
     kCFRunLoopDefaultMode：App的默认Mode，通常主线程是在这个Mode下运行
     
     UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
     
     UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用
     
     GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到
     
     kCFRunLoopCommonModes: 这是一个占位用的Mode，不是一种真正的Mode <效果等同于 kCFRunLoopDefaultMode + UITrackingRunLoopMode
     >

     */
    
    //这里是timer部分
    /**
     * 定时器，GCD的定时器
     * 1.更加精准
     * 2.不受runLoop的影响
     */
    
    
    //监听部分
    
    /**
    
     @param rl 要监听那个runLoop
     @param observer 观察者
     @param mode 运行模式
     
     CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode)
     */
    
    
    //runLoop 常驻线程<子线程有效>
    
}

#pragma mark - 常驻线程<让线程执行任务后不结束，使用runLoop,既可以让任务循环，又不影响线程执行接下来的任务>

//创建
- (IBAction)createThread:(id)sender {
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    [self.thread start];
    
}

//继续执行任务
- (IBAction)threadGoOnTask:(id)sender {
    
    [self performSelector:@selector(task2) onThread:self.thread withObject:nil waitUntilDone:NO];
    
}

- (void)task1{
    
    NSLog(@"task1 - start - %@",[NSThread currentThread]);
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    //添加一个timer
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(task3) userInfo:nil repeats:YES];
//    
//    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //添加一个source
    [runLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    
    [runLoop run];
    
    NSLog(@"task1 - end - %@",[NSThread currentThread]);
    
}

- (void)task2{
    
     NSLog(@"task2 -  %@",[NSThread currentThread]);
    
}

- (void)task3
{
    NSLog(@"task3 -  %@",[NSThread currentThread]);
}

#pragma mark -  GCD的定时器
- (void)GCDTimer{
    //NSTimer中的定时器工作会受到runloop运行模式的影响
    //GCD中的定时器是精准的,不受影响
    //01 创建定时器对象
    /* 参数说明
     *
     * 第一个参数:soure的类型 DISPATCH_SOURCE_TYPE_TIMER 定时器
     * 第二个参数:对第一个参数的描述
     * 第三个参数:更详细的描述
     * 第四个参数:队列(GCD-4) 决定代码块(event_handler)在哪个线程中执行(主队列-主线程|非主队列-子线程)
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    
    //02 设置定时器(开始时间|调用间隔|精准度)
    /* 参数说明
     *
     * 第一个参数:定时器对象
     * 第二个参数:开始计时的时间  DISPATCH_TIME_NOW 现在开始
     * 第三个参数:间隔时间
     * 第四个参数:精准度(允许的误差)
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    //03 事件回调(定时器执行的任务)
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD---%@",[NSThread currentThread]);
    });
    
    //04 启动定时器
    dispatch_resume(timer);
    
    //05 添加一个引用
    self.timer = timer;
}


@end
