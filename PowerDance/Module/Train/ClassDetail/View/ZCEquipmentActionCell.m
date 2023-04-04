//
//  ZCEquipmentActionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import "ZCEquipmentActionCell.h"
#import "ZCEquipmentAssociateClassCell.h"
#import "ZCTrainClassCardItemCell.h"

@interface ZCEquipmentActionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *courseList;

@property (nonatomic,strong) UIView *noneView;

@property (nonatomic,strong) UIButton *moreBtn;

@end

@implementation ZCEquipmentActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)equipmentActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCEquipmentActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCEquipmentActionCell" forIndexPath:indexPath];
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
    UIButton *moreBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"更多", nil) font:12 color:[ZCConfigColor txtColor]];
    self.moreBtn = moreBtn;
    self.moreBtn.hidden = YES;
    [self.contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(70));
        make.height.mas_equalTo(AUTO_MARGIN(32));
    }];
    [moreBtn setViewCornerRadiu:AUTO_MARGIN(16)];
    moreBtn.backgroundColor = rgba(246, 246, 246, 1);
    [moreBtn setImage:kIMAGE(@"base_arrow") forState:UIControlStateNormal];
    [moreBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:1];
    [moreBtn addTarget:self action:@selector(moreClassOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"与此器械相关的课程", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(moreBtn.mas_centerY);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(moreBtn.mas_bottom).offset(6);
        make.height.mas_equalTo(AUTO_MARGIN(105));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    
    [self.contentView addSubview:self.noneView];
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.collectionView);
        make.centerY.mas_equalTo(self.collectionView);
    }];
    
}

- (void)moreClassOperate {    
    [HCRouter router:@"TrainClassAllIn" params:@{@"type":@"action", @"id":checkSafeContent(self.dataDic[@"id"]), @"name":checkSafeContent(self.dataDic[@"title"])} viewController:self.superViewController animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.courseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentAssociateClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEquipmentAssociateClassCell" forIndexPath:indexPath];
    cell.dataDic = self.courseList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.courseList[indexPath.row];
    [HCRouter router:@"ClassDetail" params:dic viewController:self.superViewController animated:YES];
}

-  (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.courseList = [ZCDataTool convertEffectiveData:dataDic[@"courseList"]];
    if (self.courseList.count > 0) {
        self.noneView.hidden = YES;
        if (self.courseList.count > 3) {
            self.moreBtn.hidden = NO;
        }
    } else {
        self.moreBtn.hidden = YES;
        self.noneView.hidden = NO;
    }
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(120), AUTO_MARGIN(105));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(20), AUTO_MARGIN(20), AUTO_MARGIN(20), AUTO_MARGIN(20));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [ZCConfigColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEquipmentAssociateClassCell class] forCellWithReuseIdentifier:@"ZCEquipmentAssociateClassCell"];
    }
    return _collectionView;
}

- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"base_none_data")];
        [_noneView addSubview:iconIv];
        _noneView.userInteractionEnabled = NO;
        _noneView.hidden = YES;
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY);
            make.centerX.mas_equalTo(_noneView.mas_centerX);
            make.height.width.mas_equalTo(AUTO_MARGIN(90));
        }];
        UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"暂无数据", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
        [lb setContentLineFeedStyle];
        lb.textAlignment = NSTextAlignmentCenter;
        [_noneView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_noneView).inset(AUTO_MARGIN(15));
            make.top.mas_equalTo(iconIv.mas_bottom);
        }];
    }
    return _noneView;
}

@end
