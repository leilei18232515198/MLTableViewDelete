//
//  ViewController.m
//  MLTableView+DeleteData
//
//  Created by 268Edu on 2018/11/21.
//  Copyright © 2018年 QRScan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *indexPathArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.array = @[@"詹姆斯",@"史蒂芬库里",@"追蛋格林",@"保罗",@"夜店登"].mutableCopy;
    
   CGFloat width = [UIScreen mainScreen].bounds.size.width;
   CGFloat height = [UIScreen mainScreen].bounds.size.height;
   UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, width, height-100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.indexPathArray = [NSMutableArray array];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, 100, 50);
    button.tag = 0;
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 1;
    button1.frame = CGRectMake(CGRectGetMaxX(button.frame)+10, 10, 100, 50);
    [button1 setTitle:@"批量编辑" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 2;
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame)+10, 10, 100, 50);
    [button2 setTitle:@"删除" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

}

- (void)clickAction:(UIButton *)button{
    if (button.tag == 0) {
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        button.selected = !button.selected;
        [self setEditing:button.selected animated:YES];
    }else if (button.tag == 1){
        //    批量删除的时候调用
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        button.selected = !button.selected;
        [self setEditing:button.selected animated:YES];
    }else if (button.tag == 2){
        for (NSString *string in self.indexPathArray) {
            for (NSString *string1 in self.array) {
                if ([string isEqualToString:string1]) {
                    [self.array removeObject:string];
                    break;
                }
            }
        }
        [self.tableView reloadData];
    }

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//方法一
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"你被下放到发展联盟";
}

//方法二
//左滑出现更多按钮（上面方法失效）
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了关注");

        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.array removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

    return @[action1, action0];
}

#pragma mark - 设置删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    方法一会调用，方法二不会调用
    [self.array removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    批量删除调用的方法
    NSString *string = self.array[indexPath.row];
    [self.indexPathArray addObject:string];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = self.array[indexPath.row];
    [self.indexPathArray removeObject:string];
}
@end
