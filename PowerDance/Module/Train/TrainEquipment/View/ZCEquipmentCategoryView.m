//
//  ZCEquipmentCategoryView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentCategoryView.h"
#import "ZCEquipmentCategoryCell.h"

@interface ZCEquipmentCategoryView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,assign) NSInteger signChangeFlag;

@end

@implementation ZCEquipmentCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentCategoryCell *cell = [ZCEquipmentCategoryCell equipmentCategoryCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.contentArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:self.contentArr];
    NSMutableDictionary *oldDic = [NSMutableDictionary dictionaryWithDictionary:self.contentArr[self.selectIndex]];
    [oldDic setValue:@"0" forKey:@"status"];
    [temArr replaceObjectAtIndex:self.selectIndex withObject:oldDic];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:self.contentArr[index]];
    [newDic setValue:@"1" forKey:@"status"];
    [temArr replaceObjectAtIndex:index withObject:newDic];
    self.selectIndex = index;
    self.signChangeFlag = YES;
    self.contentArr = temArr;
    
    [self routerWithEventName:@"" userInfo:newDic];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [ZCConfigColor bgColor];
        [_tableView registerClass:[ZCEquipmentCategoryCell class] forCellReuseIdentifier:@"ZCEquipmentCategoryCell"];
        
    }
    return _tableView;
}

- (void)setContentArr:(NSArray *)contentArr {
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 0; i < contentArr.count; i ++) {
        NSDictionary *dic = contentArr[i];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (self.signChangeFlag) {
        } else {
            if (i == 0) {
                [temDic setValue:@"1" forKey:@"status"];
                self.selectIndex = 0;
            } else {
                [temDic setValue:@"0" forKey:@"status"];
            }
        }
        [temArr addObject:temDic];
    }
    _contentArr = temArr;
    [self.tableView reloadData];
}

@end
