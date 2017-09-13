//
//  ConcurrentOperation.h
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//


/**
 自定并发的NSOperation 需要以下步骤
 1.start方法：该方法必须实现
 2.main：该方法可选，如果你在start方法中定义了你的任务，则这个放就可以不实现，但通常为了代码逻辑清晰，通常会在该方法中定义自己的任务
 3.isExecuting isFinished 主要作用是在线程状态改变时，产生适当的KVO通知
 4.isConcurrent ：必须覆盖并且返回YES
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ConcurrentOperation;
@protocol ConcurrentOperationDelegate <NSObject>
- (void)downLoadOperation:(ConcurrentOperation * )operation didFinishedDownload:(UIImage *)image;
@end

@interface ConcurrentOperation : NSOperation
{
    BOOL executing;
    BOOL finished;
}

@property (copy, nonatomic) NSString * urlStr;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (assign, nonatomic) id<ConcurrentOperationDelegate>delegate;
@end
