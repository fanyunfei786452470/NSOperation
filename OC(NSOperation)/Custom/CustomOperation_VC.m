//
//  CustomOperation_VC.m
//  OC(NSOperation)
//
//  Created by 范云飞 on 2017/9/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "CustomOperation_VC.h"

/* ConcurrentOperation */
#import "ConcurrentOperation.h"
/* tool */
#import "NetWorkingTool.h"
/* model */
#import "User.h"
/* vendor */
#import "MJExtension.h"

@interface CustomOperation_VC ()
<UITableViewDelegate,
UITableViewDataSource,
ConcurrentOperationDelegate
>
@property (strong, nonatomic) NSMutableArray <User *>* dataSource;
@property (strong, nonatomic) NSOperationQueue * Queue;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableDictionary * operations;
@property (strong, nonatomic) NSMutableDictionary * images;
@end

static int page = 1;
static NSString * cellID = @"UITableViewCell";
@implementation CustomOperation_VC

#pragma mark Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)setUI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark  Request
- (void)loadData
{
    NSString * url = [NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld",(unsigned long)page];
    NetWorkingTool * tool = [NetWorkingTool shareNetWorking];
    __weak typeof(self) weakself = self;
    [tool GETWithURL:url parameters:nil sucess:^(id reponseBody) {
        NSArray * array = reponseBody[@"data"][@"list"];
        /* 将字典数组转成模型数组 */
        NSArray * arrayM = [User objectArrayWithKeyValuesArray:array];
        if (arrayM.count > 0) {
            [weakself.dataSource addObjectsFromArray:arrayM];
            [weakself.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"数据加载失败");
    }];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.dataSource.count > 0)
    {
        User * user = self.dataSource[indexPath.row];
        
        /* 保证一个url对应一个image对象 */
        UIImage * image = self.images[user.photo];
        
        /* 检查缓存中是否有图片 */
        if (image)
        {
            cell.imageView.image = image;
        }
        /* 没有图片，进行下载 */
        else
        {
            /* 设置占位图 */
            cell.imageView.image = [UIImage imageNamed:@"reflesh1_60x55"];
            ConcurrentOperation * operation = self.operations[user.photo];
            /* 检查是否正在下载 */
            if (operation) {
                /* 什么都不做 */
            }
            /* 没有下载，就要创建操作 */
            else
            {
                operation = [[ConcurrentOperation alloc]init];
                operation.urlStr = user.photo;
                operation.indexPath = indexPath;
                operation.delegate = self;
                /* 异步下载 */
                [self.Queue addOperation:operation];
                self.operations[user.photo] = operation;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)downLoadOperation:(ConcurrentOperation *)operation didFinishedDownload:(UIImage *)image
{
    /* 1.移除执行完毕的操作 */
    [self.operations removeObjectForKey:operation.urlStr];
    
    /* 2.将图片放到缓存中 */
    self.images[operation.urlStr] = image;
    
    /* 3.刷新表格(只刷新下载的那一行) */
    [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Lazy
- (NSOperationQueue *)Queue
{
    if (!_Queue) {
        _Queue = [[NSOperationQueue alloc]init];
        _Queue.maxConcurrentOperationCount = 3;
    }
    return _Queue;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableDictionary *)operations
{
    if (!_operations) {
        _operations = [[NSMutableDictionary alloc]init];
    }
    return _operations;
}

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [[NSMutableDictionary alloc]init];
    }
    return _images;
}

@end

