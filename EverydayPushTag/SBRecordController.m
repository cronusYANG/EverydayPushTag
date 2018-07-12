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
    self.title = @"Record";
    self.view.backgroundColor = [UIColor yellowColor];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.left.right.bottom.offset(0);
    }];
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
    SBModel *mode = [[SBModel alloc] init];
    mode = _dataArray[indexPath.row];
    cell.textLabel.text = mode.record;
    cell.imageView.image = [UIImage imageNamed:@"devil"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
