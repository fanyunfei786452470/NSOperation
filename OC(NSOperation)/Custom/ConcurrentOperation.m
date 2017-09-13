//
//  ConcurrentOperation.m
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "ConcurrentOperation.h"

@implementation ConcurrentOperation
- (instancetype)init
{
    if (self = [super init])
    {
        executing = NO;
        finished = NO;
    }
    return  self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (void)start
{
    /* 第一步就要检测是否被取消了，如果取消了，要实现相应的KVO */
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    /* 若果没有被取消，开始执行任务 */
    [self willChangeValueForKey:@"isExecuting"];
    
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
    @try {
        @autoreleasepool {
            /* 在这里定义自己的并发任务 */
            NSLog(@"自定义并发操作NSOperation");
            NSURL * url = [NSURL URLWithString:self.urlStr];
            NSData * data = [NSData dataWithContentsOfURL:url];
            UIImage * image = [UIImage imageWithData:data];
            
            /* 图片下载完毕后，通知代理 */
            if ([self.delegate respondsToSelector:@selector(downLoadOperation:didFinishedDownload:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate downLoadOperation:self didFinishedDownload:image];
                });
            }
            
            NSLog(@"thread-----------%@",[NSThread currentThread]);
            
            
            /* 任务执行完后要实现相应的KVO */
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];
            
            executing = NO;
            finished = YES;
            
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
