//
//  ViewController.m
//  ShowViewCountry
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)UITableView*showTabelView;


@property (retain, nonatomic)NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
 self.showTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    // 要先创建tableview在执行代理
    self.showTabelView.delegate = self;
    self.showTabelView.dataSource = self;
    
   
    [self.showTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    NSArray *array1 = [NSArray arrayWithObjects:@"中国", @"日本", @"朝鲜", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"德国", @"英国", @"瑞士", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"美国", @"加拿大", @"墨西哥", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:array1, array2, array3, nil];
    
    [self.view addSubview:_showTabelView];
    
//    UIBarButtonItem *edit = [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector()];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UILabel *textLabel1 = [[UILabel alloc] init];
    UILabel *textLabel2 = [[UILabel alloc] init];
    UILabel *textLabel3 = [[UILabel alloc] init];
    textLabel1.text = @"亚洲";
    textLabel2.text = @"欧洲";
    textLabel3.text = @"美洲";
    if (section == 0) {
        return textLabel1.text;
    }else if (section == 1) {
        return textLabel2.text;
    }else {
        return textLabel3.text;
    }
}

//询问是否进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    //NSLog(@"editing = %@", editing?@"yes":@"no");
    [_showTabelView setEditing:editing animated:animated];
}

//判断执行什么操作
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [_dataArray count] - 1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

//进行操作处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在执行删除前，要先对数据进行操作，获取当前的某一行数据
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_dataArray objectAtIndex:indexPath.section]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([array count] > 1) {

        //删除制定行数据
        [array removeObjectAtIndex:indexPath.row];
        //将当前数据替换
        [_dataArray replaceObjectAtIndex:indexPath.section withObject:array];
        
        //删除某一行
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationLeft)];
        }else {
            [_dataArray removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation: UITableViewRowAnimationRight];
        }
     
        
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSString *string = @"一个逗比爱去的地方";
        
        NSIndexPath *insert = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        
        [array insertObject:string atIndex:insert.row];
        
        [_dataArray replaceObjectAtIndex:indexPath.section withObject:array];
        
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:insert, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

//是否移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

//决定cell移动到想去的位置
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
    
    //允许移动
//    return proposedDestinationIndexPath;
    
    //不允许移动
//    return sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //取出数据
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_dataArray objectAtIndex:sourceIndexPath.section]];
    NSString *name = [array objectAtIndex:sourceIndexPath.row];
    //添加
    [array insertObject:name atIndex:destinationIndexPath.row];
    
    //删除
    [array removeObjectAtIndex:sourceIndexPath.row];
    
    [_dataArray replaceObjectAtIndex:sourceIndexPath.section withObject:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
