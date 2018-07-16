//
//  SBRecordController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBRecordController.h"
#import "SBDataManager.h"
#import <Masonry.h>
#import "SBModel.h"

#define VERSION [UIDevice currentDevice].systemVersion

static NSString *cellID = @"cell";
@interface SBRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation SBRecordController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    self.title = @"Record";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    CGFloat top = 64;
    if (VERSION.doubleValue < 11.0) {
        top = 0;
    }
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(top);
        make.left.right.bottom.offset(0);
    }];
}

-(void)loadData{
    id data = [SBDataManager loadDataWithPath:@"TIMEDATA"];
    if (data) {
        self.dataArray = data;
        self.dataArray = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    SBModel *mode = [[SBModel alloc] init];
    mode = _dataArray[indexPath.row];
    cell.textLabel.text = mode.record;
    NSString *imageName;
    if ([mode.week isEqualToString:@"星期一"]) {
        imageName = @"Monday";
    }else if ([mode.week isEqualToString:@"星期二"]){
        imageName = @"Tuesday";
    }else if ([mode.week isEqualToString:@"星期三"]){
        imageName = @"Wednesday";
    }else if ([mode.week isEqualToString:@"星期四"]){
        imageName = @"Thursday";
    }else if ([mode.week isEqualToString:@"星期五"]){
        imageName = @"Friday";
    }else{
        imageName = @"overtime";
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataArray removeObjectAtIndex:indexPath.row];
    [SBDataManager saveData:_dataArray withFileName:@"TIMEDATA"];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
