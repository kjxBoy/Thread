//
//  ViewController.m
//  网络部分
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 Kang. All rights reserved.
//



/** iOS 中发送HTTP请求的方案
 
 * NSURLConnection iOS9之后已经不推荐使用，基本废弃了
 
 * NSURLSession iOS7 开始出的技术，比NSURLConnection更加强大
 
 * CFNetWork NSURL * 的底层，纯C语言<基本不用>
 
 */


/** 常用类
 * NSURL：请求地址
 * NSURLRequest ： 一个NSURLRequest对象就代表一个请求，它包含的信息有：
        * 一个NSURL对象
        * 请求方法、请求头、请求体
        * 请求超时
        * ……
 * NSMutableURLRequest : NSURLRequest的子类
 */

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData *resultData;

@end

@implementation ViewController

-(NSMutableData *)resultData
{
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self delegate];
}


#pragma mark - 中文转码
- (void)encodeChinese
{
    NSString *zhStr = @"http://www.康大侠.com";
    //百分号转义
    NSString *enStr = [zhStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSLog(@"%@",enStr);
}

#pragma mark - NSURLSession

//代理
-(void)delegate
{
    //(1)确定请求路径(URL)
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //(2)创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //(3)自定义会话对象session,设置代理
    /* 参数说明
     *
     * 第一个参数:配置信息(设置请求的,功能类似于NSURLRequest) defaultSessionConfiguration默认
     * 第二个参数:设置代理
     * 第三个参数:代理队列(线程)-决定代理方法在哪个线程中调用
     * [NSOperationQueue mainQueue]  主线程中执行
     * [[NSOperationQueue alloc]init] 子线程
     * nil  默认在子线程中执行
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    //(4)根据会话对象来创建请求任务(Task)
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    //(5)执行Task(发送请求)
    [dataTask resume];
    
}

#pragma mark -----------------------
#pragma mark NSURLSessionDataDelegate
//01 接收到服务器响应的时候会调用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    //需要通过调用completionHandler,告诉系统应该如何处理服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);   //告诉服务器接收返回的数据
}

//02 接收到服务器返回数据的时候调用  该方法可能会被调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    //拼接服务器返回的数据
    [self.resultData appendData:data];
}

//03 请求完成或者是失败的时候调用   通过判断error是否有值来判断是否请求失败
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
    
    //解析数据
    NSLog(@"--- %@ --- ",[[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding]);
}


//block
- (void)sessionGetWithRequest{
    
    NSURL *url = [NSURL URLWithString:@""];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    /**
     * data 响应体
     * response 响应头
     * error 错误
     */
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        //解析服务器返回的数据(data-字符串)
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        //子线程
        NSLog(@"%@",[NSThread currentThread]);
        
    }];
    
    //重新开始
    [task resume];
    
}

- (void)sessionGetWithUrl{
    
    NSURL *url = [NSURL URLWithString:@""];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    /**
     * data 响应体
     * response 响应头
     * error 错误
     */
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //子线程
        NSLog(@"%@",[NSThread currentThread]);
        
    }];
    
    //重新开始
    [task resume];
    
}

- (void)sessionPost{
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     * data 响应体
     * response 响应头
     * error 错误
     */
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //解析服务器返回的数据(data-字符串)
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        //子线程
        NSLog(@"%@",[NSThread currentThread]);
        
    }];
    
    //重新开始
    [task resume];
}

#pragma mark - NSURLConnection <放弃>




@end
