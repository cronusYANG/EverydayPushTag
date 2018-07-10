//
//  SBRecordController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBRecordController.h"
#import "SBDataManager.h"

static NSString *cellID = @"cell";
@interface SBRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSArray *dataArray;
@end

@implementation SBRecordController

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    
    
}

-(void)loadData{
    id data = [SBDataManager loadDataWithPath:@"TIMEDATA"];
    if (data) {
        self.dataArray = data;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
