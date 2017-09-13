//
//  NetWorkingTool.h
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

/*网络请求工具类，封装成单例**/
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void (^sucess)(id reponseBody);
typedef void (^failure)(NSError *error);


@interface NetWorkingTool : NSObject
//单列方法
+(instancetype)shareNetWorking;

//封装一个GET请求
- (void)GETWithURL:(NSString *)url parameters:(id)parameters sucess:(sucess)sucess failure:(failure)failure;
@end
