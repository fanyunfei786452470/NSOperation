//
//  NSOperationQueue_VC.m
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "NSOperationQueue_VC.h"

@interface NSOperationQueue_VC ()

@end

@implementation NSOperationQueue_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self request];
    [self concurrent];
}

#pragma mark - 直接添加block任务
- (void)request
{
    /* 创建队列 */
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    
    /* 添加任务 */
    [queue addOperationWithBlock:^{
        for (int i = 0 ; i < 10 ; i++) {
            NSLog(@"1---------%@",[NSThread currentThread]);
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i = 0 ; i < 10 ; i++) {
            NSLog(@"2---------%@",[NSThread currentThread]);
        }
    }];
    
    /* 主线程刷新 */
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        NSLog(@"main -----------%@",[NSThread currentThread]);
    }];
}

#pragma mark - 控制并发数量
- (void)concurrent
{
    /* 创建队列 */
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    
    /* 设置最大并发数 */
//    queue.maxConcurrentOperationCount = 2;/* 并行队列 */
    queue.maxConcurrentOperationCount = 1;/* 串行队列 */
    
    /* 添加操作 */
    [queue addOperationWithBlock:^{
        NSLog(@"1------------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"2------------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"3------------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"4------------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"5------------%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    }];
    
    /* 主线程刷新 */
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        NSLog(@"main ------------%@",[NSThread currentThread]);
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
