//
//  ViewController.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "ViewController.h"

/* subclass */
#import "NSBlockOperation_VC.h"
#import "NSInvocationOperation_VC.h"
#import "NSOperationQueue_VC.h"

/* custom */
#import "CustomOperation_VC.h"

@interface ViewController ()
<UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray <NSString *>* titleArr;
@property (strong, nonatomic) NSArray <NSArray<NSString *> *>* dataArr;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_UI];
    [self Create_DATA];
}

- (void)Create_UI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)Create_DATA
{
    self.titleArr = @[@"NSOperation的子类",
                      @"CustomOperation(自定义)",
                      ];
    self.dataArr = @[@[@"NSBlockOperation",
                       @"NSInvocatioinOperation",
                       @"NSOperationQueue"
                       ],
                     @[@"CustomOperation"
                       ]
                     ];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame
                                                 style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArr[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSBlockOperation_VC * blockOperation_VC = [[NSBlockOperation_VC alloc]init];
            [self.navigationController pushViewController:blockOperation_VC animated:YES];
        }
        if (indexPath.row == 1)
        {
            NSInvocationOperation_VC * invocationOperation_VC = [[NSInvocationOperation_VC alloc]init];
            [self.navigationController pushViewController:invocationOperation_VC animated:YES];
        }
        if (indexPath.row == 2)
        {
            NSOperationQueue_VC * operationQueue_VC = [[NSOperationQueue_VC alloc]init];
            [self.navigationController pushViewController:operationQueue_VC animated:YES];
        }
        
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            CustomOperation_VC * customOperation_VC = [[CustomOperation_VC alloc]init];
            [self.navigationController pushViewController:customOperation_VC animated:YES];
        }
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
