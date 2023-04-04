//
//  ZCClassDetailActionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/13.
//

#import "ZCClassDetailActionCell.h"
#import "ZCTrainActionItemCell.h"
#import "ZCClassDetailActionRestCell.h"

@interface ZCClassDetailActionCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCClassDetailActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)classDetailActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCClassDetailActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCClassDetailActionCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = rgba(246, 246, 246, 1);
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(180));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSDictionary *actionDic = dic[@"courseAction"];
    if ([actionDic[@"rest"] integerValue] == 1) {
        ZCClassDetailActionRestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCClassDetailActionRestCell" forIndexPath:indexPath];
        cell.dataDic = dic;
        return cell;
    } else {
        ZCTrainActionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCTrainActionItemCell" forIndexPath:indexPath];
        cell.actionDic = actionDic;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSDictionary *courseDic = dic[@"courseAction"];
    if ([courseDic[@"rest"] integerValue] == 1) {
        return CGSizeMake(AUTO_MARGIN(50), AUTO_MARGIN(146));
    } else {
        return CGSizeMake(AUTO_MARGIN(100), AUTO_MARGIN(146));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    if ([dic[@"courseAction"] isKindOfClass:[NSDictionary class]]) {
        if ([dic[@"courseAction"][@"rest"] integerValue] == 0) {
            [HCRouter router:@"ActionDetail" params:dic viewController:self.superViewController animated:YES];
        }
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
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
        [_collectionView registerClass:[ZCTrainActionItemCell class] forCellWithReuseIdentifier:@"ZCTrainActionItemCell"];
        [_collectionView registerClass:[ZCClassDetailActionRestCell class] forCellWithReuseIdentifier:@"ZCClassDetailActionRestCell"];
    }
    return _collectionView;
}

@end
