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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.ticketCount = 100;
   
    //[self testSaleTicket];
}

- (void)testSocket
{
    
}



/**
 线程间通信
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //创建子线程(3种方法)
    [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];
}

#pragma mark -----------------------
#pragma mark Methods

-(void)download
{
    NSLog(@"download----%@",[NSThread currentThread]);
    
    //01 确定URL地址
    NSURL *url = [NSURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2015/083/30/VVJ04M7P71W2.jpg"];
    
    //02 把图片的二进制数据下载到本地
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    //03 把图片的二进制格式转换为UIimage
    UIImage *image = [UIImage imageWithData:imageData];
    
    //报错:把和UI相关的操作放在后台线程中处理
    
    //04 回到主线程显示图片
    //子线程切换回主线程
    /* 参数说明
     *
     * 第一个参数:方法选择器  回到主线程要做什么(方法)
     * 第二个参数:调用函数需要传递的参数
     * 第三个参数:是否等待该方法执行完毕才继续往下执行 YES:等待
     */
    //第一种方法
    //[self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
    
    //第二种方法
    [self performSelector:@selector(showImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
    
    //简便方法
    //[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    NSLog(@"_____end______");
}

-(void)showImage:(UIImage *)image
{
    self.imageView.image = image;
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
    
    //绝对时间
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    //耗时操作
    
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"%f",end - start);
    

    
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
