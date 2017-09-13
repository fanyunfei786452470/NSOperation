//
//  NSBlockOperation_VC.m
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "NSBlockOperation_VC.h"

@interface NSBlockOperation_VC ()

@end

@implementation NSBlockOperation_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/* 多个请求，依次请求 */
- (void)request
{
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self request1];
    }];
    operation1.completionBlock = ^{
        NSLog(@"请求1完成");
    };
    
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self request2];
    }];
    operation2.completionBlock = ^{
        NSLog(@"请求2完成");
    };
    
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self request3];
    }];
    operation3.completionBlock = ^{
        NSLog(@"请求3完成");
    };
    
    /* 设置依赖 */
    [operation2 addDependency:operation1];/* 请求2依赖请求1 */
    [operation3 addDependency:operation2];/* 请求3依赖请求1 */
    
    /* 创建队列并加入任务 */
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 2;
    [queue addOperations:@[operation3,operation2,operation1] waitUntilFinished:NO];
    
    /* 在主线程里刷新 */
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"***********%@*********",@"完事");
    }];
}

/* 请求1 */
- (void)request1
{
    NSLog(@"***********%@*********",@"请求1");
}

/* 请求2 */
- (void)request2
{
    NSLog(@"***********%@*********",@"请求2");
}

/* 请求3 */
- (void)request3
{
    NSLog(@"***********%@*********",@"请求3");
}



@end
