//
//  ZCGoodsDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCGoodsDetailController.h"
#import "ZCGoodsTopView.h"
#import "ZCGoodsDetailInfoView.h"
#import "ZCArrivePlaceView.h"
#import "ZCShopAddressModel.h"
#import "ZCShopGoodsModel.h"
#import "ZCSelectShopTypeView.h"
#import "ZCGoodsTypeModel.h"

@interface ZCGoodsDetailController ()

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) ZCGoodsTopView *topView;

@property (nonatomic,strong) ZCGoodsDetailInfoView *infoView;

@property (nonatomic,strong) ZCArrivePlaceView *placeView;

@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSMutableArray *addressArr;

@property (nonatomic,strong) NSMutableArray *goodTypeArr;

@property (nonatomic,strong) ZCShopGoodsModel *goodsModel;

@property (nonatomic,strong) ZCShopAddressModel *addressModel;

@property (nonatomic,strong) ZCSelectShopTypeView *goodsTypeView;

@property (nonatomic,strong) ZCGoodsTypeModel *selectTypeModel;

@property (nonatomic,assign) NSInteger showType;

@property (nonatomic,assign) NSInteger goodNum;

@end

@implementation ZCGoodsDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMessageUnReadInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self configureBaseInfo];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self getGoodsDetailInfo];
        
        [self getUserDefaultAddressInfo];
        
        [self getShopAddressListInfo];
    });
}

- (void)setupSubViews {
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.bounces = NO;
    [self.view addSubview:self.scView];
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    self.topView = [[ZCGoodsTopView alloc] init];    
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
    }];
    
    self.infoView = [[ZCGoodsDetailInfoView alloc] init];
    [self.contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    
    [self createBottomBlurView];
    
    UIButton *submitBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"立即购买", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(25));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    submitBtn.backgroundColor = [ZCConfigColor txtColor];
    [submitBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [submitBtn addTarget:self action:@selector(submitOperate) forControlEvents:UIControlEventTouchUpInside];
        
}

- (void)createBottomBlurView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, SCREEN_H - AUTO_MARGIN(98), SCREEN_W, AUTO_MARGIN(98));
//    view.alpha = 0.5;
    [view setViewColorAlpha:0.1 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:view];

    // blur
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(98));
    [view addSubview:visualView];
}

- (void)submitOperate {
    //GoodsCommentOperate   OrderComfire
    [ZCDataTool judgeUserMode];
    if (self.goodTypeArr.count > 0) {
        [self showGoodsTypeView];
    } else {
        [self.view makeToast:NSLocalizedString(@"暂无库存，请联系客服", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.goodNum = 1;
    [self.backBtn setViewCornerRadiu:15];
    self.backBtn.backgroundColor = rgba(0, 0, 0, 0.6);
    self.backStyle = UINavBackButtonColorStyleWhite;
    
    UIButton *message = [[UIButton alloc] init];
    message.backgroundColor = rgba(43, 42, 51, 0.5);
    [self.naviView addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.naviView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(105));
        make.height.mas_equalTo(AUTO_MARGIN(34));
    }];
    message.titleLabel.font = FONT_SYSTEM(14);
    [message setViewCornerRadiu:AUTO_MARGIN(17)];
    [message setImage:kIMAGE(@"shop_message_white") forState:UIControlStateNormal];
    [message setTitle:NSLocalizedString(@"联系客服", nil) forState:UIControlStateNormal];
    [message dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    [message addTarget:self action:@selector(contactService) forControlEvents:UIControlEventTouchUpInside];
    message.hidden = YES;
    
    self.alertView = [[UIView alloc] init];
    self.alertView.hidden = YES;
    self.alertView.backgroundColor = rgba(246, 48, 93, 1);
    [message addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(message).inset(AUTO_MARGIN(3));
        make.height.width.mas_equalTo(10);
    }];
    [self.alertView setViewCornerRadiu:5];
}

- (void)routerWithEventName:(NSString *)eventName {
    self.showType = [eventName integerValue];
    [self.view addSubview:self.maskBtn];
    self.maskBtn.hidden = NO;
    kweakself(self);
    if (self.showType == 1) {
        [ZCDataTool judgeUserMode];
        [self.view addSubview:self.placeView];
        self.placeView.sureAddressOperate = ^(id  _Nonnull value) {
            ZCShopAddressModel *model = value;
            weakself.addressModel = model;
            weakself.topView.centerView.model = model;
            [weakself maskBtnClick];
            [weakself getShopAddressListInfo];
        };
        [UIView animateWithDuration:0.25 animations:^{
            weakself.placeView.frame = CGRectMake(0, SCREEN_H - AUTO_MARGIN(400), SCREEN_W, AUTO_MARGIN(400));
            if (weakself.placeView.dataArr.count == 0) {                
                weakself.placeView.dataArr = self.addressArr;
            }
        }];
    } else {
        
        [self showGoodsTypeView];
    }
}

- (void)showGoodsTypeView {
    kweakself(self);
    [self.view addSubview:self.goodsTypeView];
    self.goodsTypeView.goodsModel = self.goodsModel;
    self.goodsTypeView.typeArr = self.goodTypeArr;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.goodsTypeView.frame = CGRectMake(0, SCREEN_H - AUTO_MARGIN(600), SCREEN_W, AUTO_MARGIN(600));
    }];
    self.goodsTypeView.selectGoodsNumOperate = ^(NSString * _Nonnull value) {
        weakself.goodNum = [value integerValue];
    };
    self.goodsTypeView.exitSelectOperate = ^{
        weakself.maskBtn.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.goodsTypeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(600));
        }];
    };
    
    self.goodsTypeView.payGoodsOpereate = ^(id value) {
        weakself.maskBtn.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.goodsTypeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(600));
        }];
        weakself.selectTypeModel = value;
        NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:@{@"goods":weakself.goodsModel, @"num":@(weakself.goodNum)}];
        if (weakself.addressModel != nil) {
            [parms setValue:weakself.addressModel forKey:@"data"];
        }
        if (weakself.selectTypeModel != nil) {
            [parms setValue:weakself.selectTypeModel forKey:@"type"];
            [HCRouter router:@"OrderComfire" params:parms viewController:weakself animated:YES];
        }
    };
}

- (void)contactService {
    [HCRouter router:@"ContactService" params:@{} viewController:self animated:YES];
}
#pragma -- mark 获取商品详情
- (void)getGoodsDetailInfo {
    [ZCShopManage queryShopGoodsDetailInfo:@{@"id":self.params[@"data"]} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.goodsModel = [ZCShopGoodsModel mj_objectWithKeyValues:responseObj[@"data"]];
            NSString *content = responseObj[@"data"][@"desc"];
            self.infoView.content = content;
            self.topView.model = self.goodsModel;
            self.goodTypeArr = [ZCGoodsTypeModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"productskuList"]];           
        });
    }];
}
#pragma -- mark 获取地址列表
- (void)getShopAddressListInfo {
    [ZCShopManage queryShopArriveAddressListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *addressList = responseObj[@"data"];
        NSMutableArray *temArr = [NSMutableArray array];
        for (NSDictionary *dic in addressList) {
            NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [temDic setValue:@"0" forKey:@"status"];
            ZCShopAddressModel *model = [ZCShopAddressModel mj_objectWithKeyValues:temDic];
            [temArr addObject:model];            
        }
        self.addressArr = temArr;
    }];
}
#pragma -- mark 获取默认地址
- (void)getUserDefaultAddressInfo {
    [ZCShopManage getDefaultArriveAddressInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dic = responseObj[@"data"];
        if (![dic isKindOfClass:[NSNull class]]) {
            ZCShopAddressModel *model = [ZCShopAddressModel mj_objectWithKeyValues:dic];
            self.addressModel = model;
            self.topView.centerView.model = model;
        }
    }];
}

- (void)getMessageUnReadInfo {
    [ZCShopManage getChatRoomUnReadListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSArray *listArr = responseObj[@"data"];
        if ([ZCDataTool judgeContentValue:listArr]) {
            if (listArr.count > 0) {
                self.alertView.hidden = NO;
            } else {
                self.alertView.hidden = YES;
            }
        }
    }];
}

- (void)maskBtnClick {   
    if (self.showType == 1) {
        self.maskBtn.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.placeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.placeView.height);
        }];
    }
}

- (ZCArrivePlaceView *)placeView {
    if (!_placeView) {
        _placeView = [[ZCArrivePlaceView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(400))];
    }
    return _placeView;
}

- (ZCSelectShopTypeView *)goodsTypeView {
    if (!_goodsTypeView) {
        _goodsTypeView = [[ZCSelectShopTypeView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(660))];
    }
    return _goodsTypeView;
}

@end
