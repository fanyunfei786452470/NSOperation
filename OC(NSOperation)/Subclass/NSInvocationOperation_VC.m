//
//  NSInvocationOperation_VC.m
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "NSInvocationOperation_VC.h"

@interface NSInvocationOperation_VC ()

@end

@implementation NSInvocationOperation_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self request];
}

- (void)request
{
    /* 创建队列 */
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    
    /* 创建NSInvocationOperation */
    NSInvocationOperation * operation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    
    /* 创建NSBlockOperation */
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0 ; i < 10 ; i++) {
            NSLog(@"1---------%@",[NSThread currentThread]);
        }
    }];
    
    /* 添加额外的任务 */
    [operation2 addExecutionBlock:^{
        for (int i = 0 ; i < 10 ; i++) {
            NSLog(@"1.1--------%@",[NSThread currentThread]);
        }
    }];
    
    /* 添加操作到队列中 */
    [queue addOperation:operation1];/* <==> [operation1 start] */
    [queue addOperation:operation2];/* <==> [operation2 start] */
    
    /* 主线程刷新 */
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"main---------%@",[NSThread currentThread]);
    }];
}

- (void)run
{
    for (int i = 0 ; i < 10 ; i++) {
        NSLog(@"2----------%@",[NSThread currentThread]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
