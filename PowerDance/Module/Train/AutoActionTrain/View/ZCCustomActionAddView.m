//
//  ZCCustomActionAddView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import "ZCCustomActionAddView.h"
#import "ZCTrainActionItemCell.h"
#import "ZCClassDetailActionRestCell.h"
#import "ZCCustonActionEditCell.h"
#import "ZCCustomRestMouseView.h"
#import "ZCCustomCourseAddItemCell.h"
#import "ZCCustomDeleteTrainAlertView.h"

@interface ZCCustomActionAddView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *normalArr;

@property (nonatomic,strong) NSArray *typeArr;

@property (nonatomic,strong) NSArray *tagsArr;

@end

@implementation ZCCustomActionAddView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.normalArr = @[];
    self.typeArr = @[NSLocalizedString(@"全部", nil)];
    self.tagsArr = @[];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(180));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *actionDic = self.dataArr[indexPath.row];
    if ([actionDic[@"rest"] integerValue] == 1) {
        ZCClassDetailActionRestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCClassDetailActionRestCell" forIndexPath:indexPath];
        cell.dataDic = actionDic;
        cell.signDeleteFlag = YES;
        cell.index = indexPath.row;
        return cell;
    } else if ([actionDic[@"rest"] integerValue] == 2) {
        ZCCustonActionEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCCustonActionEditCell" forIndexPath:indexPath];
        return cell;
    } else {
        ZCCustomCourseAddItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCCustomCourseAddItemCell" forIndexPath:indexPath];
        cell.actionDic = actionDic;
        cell.signDeleteFlag = YES;
        cell.index = indexPath.row;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *courseDic = self.dataArr[indexPath.row];
    if ([courseDic[@"rest"] integerValue] == 1) {
        return CGSizeMake(AUTO_MARGIN(50), AUTO_MARGIN(146));
    } else {
        return CGSizeMake(AUTO_MARGIN(100), AUTO_MARGIN(146));
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"action"]) {
        NSLog(@"add action");
        kweakself(self);
        [HCRouter router:@"TrainAction" params:@{@"select":@"1", @"data":self.normalArr, @"type":self.typeArr, @"tags":self.tagsArr} viewController:self.superViewController animated:YES block:^(id  _Nonnull value) {
            NSDictionary *temDic = value[@"target"];
            weakself.normalArr = value[@"normal"];
            weakself.typeArr = value[@"type"];
            weakself.tagsArr = value[@"tags"];
            NSMutableDictionary *tem = [NSMutableDictionary dictionary];
            [tem setValue:checkSafeContent(temDic[@"actionId"]) forKey:@"actionId"];
            [tem setValue:@"0" forKey:@"rest"];
            [tem setValue:temDic[@"duration"] forKey:@"duration"];
            [tem setValue:checkSafeContent(temDic[@"name"]) forKey:@"name"];
            [tem setValue:checkSafeContent(temDic[@"cover"]) forKey:@"cover"];
            [weakself.dataArr insertObject:tem atIndex:weakself.dataArr.count - 1];
            [weakself.collectionView reloadData];
            [weakself scrollPositionBottom];
            [weakself routerWithEventName:@"changeAction"];
        }];
    } else if ([eventName isEqualToString:@"rest"]) {
        NSLog(@"add rest");
        ZCCustomRestMouseView *mouse = [[ZCCustomRestMouseView alloc] init];
        [self.superViewController.view addSubview:mouse];
        kweakself(self);
        mouse.sureRepeatOperate = ^(NSString * _Nonnull content) {
            [weakself reloadActionView:content];
            [weakself routerWithEventName:@"changeAction"];
        };
        [mouse showAlertView];
    } else if ([eventName isEqualToString:@"delete"]) {
        ZCCustomDeleteTrainAlertView *alert = [[ZCCustomDeleteTrainAlertView alloc] init];
        [self.superViewController.view addSubview:alert];
        NSDictionary *dic = self.dataArr[[userInfo[@"index"] integerValue]];
        if ([dic[@"rest"] integerValue] == 1) {
            alert.content = @"休息";
        } else {
            alert.content = dic[@"name"];
        }
        alert.time = dic[@"duration"];
        [alert showAlertView];
        kweakself(self);
        alert.sureEditOperate = ^(NSString * _Nonnull content) {
            NSInteger index = [userInfo[@"index"] integerValue];
            [weakself.dataArr removeObjectAtIndex:index];
            [weakself.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself reloadDataOperate];
            });
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakself reloadDataOperate];
//            });
            
            [weakself routerWithEventName:@"changeAction"];
        };
    }
}

- (void)reloadDataOperate {
    [self.collectionView reloadData];
}

#pragma mark  - 滑到最底部`
- (void)scrollPositionBottom {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];  //取最后一行数据
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];//滚动到最后一行
    });
}

- (void)reloadActionView:(NSString *)content {
    NSDictionary *dic = [self packageRestData:content];
    [self.dataArr insertObject:dic atIndex:self.dataArr.count-1];
    [self.collectionView reloadData];
    [self scrollPositionBottom];
}

- (NSString *)convertContent:(NSString *)content {
    return [content substringWithRange:NSMakeRange(0, content.length - 1)];
}

- (NSDictionary *)packageRestData:(NSString *)data {
    return @{@"rest":@"1", @"duration":data};
}

- (NSDictionary *)packageActionData:(NSString *)data {
    return @{@"rest":@"0", @"name":data};
}

- (void)setEditDataArr:(NSMutableArray *)editDataArr {
    _editDataArr = editDataArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:editDataArr];
        NSDictionary *dic = @{@"rest":@"2"};
        [self.dataArr addObject:dic];
        [self.collectionView reloadData];
    });
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSDictionary *dic = @{@"rest":@"2"};
        [_dataArr addObject:dic];
    }
    return _dataArr;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake(AUTO_MARGIN(100), AUTO_MARGIN(146));
        layout.minimumInteritemSpacing = AUTO_MARGIN(15);
//        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(0, AUTO_MARGIN(20), 0, AUTO_MARGIN(20));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCCustomCourseAddItemCell class] forCellWithReuseIdentifier:@"ZCCustomCourseAddItemCell"];
        [_collectionView registerClass:[ZCClassDetailActionRestCell class] forCellWithReuseIdentifier:@"ZCClassDetailActionRestCell"];
        [_collectionView registerClass:[ZCCustonActionEditCell class] forCellWithReuseIdentifier:@"ZCCustonActionEditCell"];
    }
    return _collectionView;
}

@end
