//
//  ZCPersonalDeviceCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCPersonalCenterDeviceCell.h"
#import "ZCPersonalCenterDeviceItemCell.h"
#import "ZCHomeBindDeviceView.h"
#import "CFFChangeNickView.h"

@interface ZCPersonalCenterDeviceCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCPersonalCenterDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)personalCenterDeviceCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCPersonalCenterDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCPersonalCenterDeviceCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ZCConfigColor bgColor];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"我的设备", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(bgView.mas_top).offset(15);
    }];
    
    UIButton *connectBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"连接设备", nil) font:AUTO_MARGIN(13) color:rgba(138, 205, 215, 1)];
    [bgView addSubview:connectBtn];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [connectBtn setImage:kIMAGE(@"my_device_connect") forState:UIControlStateNormal];
    [connectBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
    [connectBtn addTarget:self action:@selector(connectDeviceOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    [bgView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(titleL.mas_bottom).offset(15);
        make.height.mas_equalTo(AUTO_MARGIN(1));
    }];
     
    [bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(15);
        make.height.mas_equalTo(AUTO_MARGIN(85));
        make.bottom.mas_equalTo(bgView.mas_bottom).inset(15);
    }];
    
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCPersonalCenterDeviceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCPersonalCenterDeviceItemCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [self jumpDeviceInterfaceWithCode:dic];
}
#pragma -- mark 连接设备
- (void)connectDeviceOperate {
    [HCRouter router:@"SelectSmartDeviceList" params:@{} viewController:self.superViewController animated:YES];
}

- (void)jumpDeviceInterfaceWithCode:(NSDictionary *)dic {
    NSString *jumpCode = dic[@"code"];
    if ([jumpCode isEqualToString:@"ruler"]) {//腰围尺2.0
        [HCRouter router:@"SmartTypeRuler" params:dic viewController:self.superViewController animated:YES];
    } else if ([jumpCode isEqualToString:@"ruler1"]) {//腰围尺1.0 使用SDK款
        [HCRouter router:@"SmartRuler" params:dic viewController:self.superViewController animated:YES];
    } else if ([jumpCode isEqualToString:@"timer"]) {
        [HCRouter router:@"SmartTimer" params:dic viewController:self.superViewController animated:YES];
    } else if ([jumpCode isEqualToString:@"suit"]) {
//        [HCRouter router:@"FamilySuit" params:dic viewController:self.superViewController animated:YES];
        NSDictionary *dataDic = kUserStore.userData;
        if ([checkSafeContent(dataDic[@"weight"]) doubleValue] > 0.0) {
            [HCRouter router:@"FamilySuit" params:dic viewController:self.superViewController animated:YES];
        } else {
            CFFChangeNickView *change = [[CFFChangeNickView alloc] init];
            change.title = NSLocalizedString(@"体重", nil);
            change.placeholder = NSLocalizedString(@"请输入您的体重", nil);
            change.tf.keyboardType = UIKeyboardTypeDecimalPad;
            change.unitL.hidden = NO;
            change.descL.hidden = NO;
            [change showAlertView];
            kweakself(self);
            change.SaveNickOperate = ^(NSString * _Nonnull name) {
                NSString *weight = [NSString stringWithFormat:@"%.1f", [name doubleValue]];
                [weakself saveUserInfoWithData:@{@"weight":weight}];
            };
        }
    } else {
        //scale
        if ([ZCDataTool getSignHasInputUserInfo]) {
            [HCRouter router:@"SmartCloud" params:dic viewController:self.superViewController animated:YES];
        } else {
            [HCRouter router:@"SmartCloudBase" params:@{} viewController:self.superViewController animated:YES];
        }
    }
}

- (void)saveUserInfoWithData:(NSDictionary *)parm {
    [self routerWithEventName:@"weoght" userInfo:parm];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(85), AUTO_MARGIN(85));
        layout.sectionInset = UIEdgeInsetsMake(0, AUTO_MARGIN(15), 0, AUTO_MARGIN(15));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCPersonalCenterDeviceItemCell class] forCellWithReuseIdentifier:@"ZCPersonalCenterDeviceItemCell"];
    }
    return _collectionView;
}


@end
