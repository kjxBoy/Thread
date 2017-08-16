//
//  ViewController.m
//  HTTPS请求部分
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


@interface ViewController ()<NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AFNMethod];
}


- (void)AFNMethod
{
    //01 创建会话管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //修改对响应的序列化方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置AFN中的安全配置
    manager.securityPolicy.allowInvalidCertificates = YES;  //01 允许接收无效的证书
    manager.securityPolicy.validatesDomainName = NO;        //02 不做域名验证
    //03 修改info.plist文件ATS
    
    //02 发送请求
    [manager GET:@"https://kyfw.12306.cn/otn/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error---%@",error);
    }];

}


- (void)originalMethod
{
    /*
     HTTPS请求的时候:
     [1] 证书是受信任的,什么都不用做
     [2] 证书是不受信任的,是自签名的
     (1) 修改配置文件,禁用ATS特性
     (2) 信任并安装(数字证书)
     */
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];

}


#pragma mark -----------------------
#pragma mark NSURLSessionDataDelegate
/*
 challenge:挑战,质询
 当我们发送的是一个HTTPS请求的时候就会调用该方法,需要在该方法中处理证书
 NSURLAuthenticationMethodServerTrust:服务器信任
 HTTP:80
 HTTPS:443
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"%@",challenge.protectionSpace);
    //判断只有当时NSURLAuthenticationMethodServerTrust的时候才安装这个证书
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        return;
    }
    /*
     NSURLSessionAuthChallengeUseCredential = 0, 使用证书
     NSURLSessionAuthChallengePerformDefaultHandling = 1,  忽略证书
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 请求被取消,证书被忽略
     NSURLSessionAuthChallengeRejectProtectionSpace = 3, 拒绝
     */
    NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}


@end
