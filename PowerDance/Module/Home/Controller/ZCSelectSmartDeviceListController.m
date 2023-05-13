//
//  ZCSelectSmartDeviceListController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCSelectSmartDeviceListController.h"
#import "ZCEfficientDeviceItemCell.h"
#import "ZCDeviceDescView.h"
#import "ZCDeviceConnectAlertView.h"
#import "CFFChangeNickView.h"

@interface ZCSelectSmartDeviceListController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCSelectSmartDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavStatus = YES;
    
    [self createSubviews];
}

- (void)createSubviews {
    
    UIImageView *secondIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_home_efficient")];
    [self.view addSubview:secondIv];
    [secondIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT+AUTO_MARGIN(5));
        make.leading.trailing.bottom.mas_equalTo(self.view).inset(AUTO_MARGIN(5));
    }];
    kweakself(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getSmartDeviceListInfo];
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    [self getSmartDeviceListInfo];
    
//    for (int i = 0; i < 2; i ++) {
//        UIButton *btn = [self.view createSimpleButtonWithTitle:[NSString stringWithFormat:@"mode%d", i] font:15 color:[ZCConfigColor txtColor]];
//        [self.view addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(65);
//            make.height.mas_equalTo(35);
//            make.bottom.mas_equalTo(self.view.mas_bottom).inset(40);
//            make.leading.mas_equalTo(self.view.mas_leading).inset(20+75*i);
//        }];
//        [btn setViewBorderWithColor:1 color:[ZCConfigColor point8TxtColor]];
//        [btn setViewCornerRadiu:5];
//        btn.tag = i;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

//- (void)btnClick:(UIButton *)sender {
//    if(sender.tag == 1) {
//        [HCRouter router:@"PowerPlatform" params:@{} viewController:self];
//    } else {
//        [HCRouter router:@"PowerSingleType" params:@{} viewController:self];
//    }
//}

#pragma -- mark 获取设备列表信息
- (void)getSmartDeviceListInfo {
    [ZCTrainManage querySmartDeviceListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        self.dataArr = responseObj[@"data"];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEfficientDeviceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEfficientDeviceItemCell" forIndexPath:indexPath]; cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *jumpCode = dic[@"code"];
    if([jumpCode isEqualToString:@"pp2"]) {
        [HCRouter router:@"PowerPlatform" params:@{} viewController:self];
    } else if ([jumpCode isEqualToString:@"pp1"]) {
        [HCRouter router:@"PowerSingleType" params:@{} viewController:self];
    } else if ([ZCDataTool getSignKnowSmartDeviceStatusWithCode:jumpCode]) {
        [self jumpDeviceInterfaceWithCode:dic];
    } else {
        ZCDeviceDescView *descView = [[ZCDeviceDescView alloc] init];
        [MAINWINDOW addSubview:descView];
        descView.dataDic = dic;
        [descView showContentView];
        kweakself(self);
        descView.bindDeviceOperate = ^{
            [weakself jumpDeviceInterfaceWithCode:dic];
            [weakself bindDeviceInfoOperate:checkSafeContent(dic[@"id"])];
        };
        descView.knowDeviceInfoOperate = ^{
            
        };
    }
}
#pragma -- mark 绑定设备
- (void)bindDeviceInfoOperate:(NSString *)deviceId {
    [ZCClassSportManage bindSmartDeviceInfoOperateURL:@{@"apparatusId":checkSafeContent(deviceId)} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
    }];
}

- (void)jumpDeviceInterfaceWithCode:(NSDictionary *)dic {
    NSString *jumpCode = dic[@"code"];
    if ([jumpCode isEqualToString:@"ruler"]) {//腰围尺2.0
        [HCRouter router:@"SmartTypeRuler" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"ruler1"]) {//腰围尺1.0 使用SDK款
        [HCRouter router:@"SmartRuler" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"timer"]) {
        [HCRouter router:@"SmartTimer" params:dic viewController:self animated:YES];
    } else if ([jumpCode isEqualToString:@"suit"]) {
        [HCRouter router:@"FamilySuit" params:dic viewController:self animated:YES];
        NSDictionary *dataDic = kUserStore.userData;
        if ([checkSafeContent(dataDic[@"weight"]) doubleValue] > 0.0) {
            [HCRouter router:@"FamilySuit" params:dic viewController:self animated:YES];
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
            [HCRouter router:@"SmartCloud" params:dic viewController:self animated:YES];
        } else {
            [HCRouter router:@"SmartCloudBase" params:@{} viewController:self animated:YES];
        }
    }
}

#pragma -- mark 查询个人信息
- (void)saveUserInfoWithData:(NSDictionary *)parm {
        
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
        [self queryUserBaseInfo];
    }];
}
#pragma -- mark 查询个人信息
- (void)queryUserBaseInfo {
    [ZCProfileManage getUserBaseInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
    }];
}

- (void)showFamilySuitAlertView:(NSDictionary *)dic {
    ZCDeviceConnectAlertView *alert = [[ZCDeviceConnectAlertView alloc] init];
    [alert showAlertView];
    [alert.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dic[@"imgUrl"])] placeholderImage:nil];
    alert.titleStr = NSLocalizedString(@"家庭智能健身套装链接中···", nil);
    alert.alertL.text = checkSafeContent(dic[@"briefDesc"]);
    alert.BlueConnectAttempt = ^{
        
    };
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(15)*3 - AUTO_MARGIN(10))/2.0, AUTO_MARGIN(187));
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(0, AUTO_MARGIN(15), 0, AUTO_MARGIN(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEfficientDeviceItemCell class] forCellWithReuseIdentifier:@"ZCEfficientDeviceItemCell"];
    }
    return _collectionView;
}

@end
