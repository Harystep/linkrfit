//
//  ZCOrderComfireController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCOrderComfireController.h"
#import "ZCComfireOrderPayView.h"
#import "ZCComfireOrderDetailView.h"
#import "ZCComfireOrderAddressView.h"
#import "ZCArrivePlaceView.h"
#import "ZCPayTypeView.h"
#import "ZCShopGoodsModel.h"
#import "ZCShopAddressModel.h"
#import "ZCGoodsTypeModel.h"

@interface ZCOrderComfireController ()

@property (nonatomic,strong) ZCComfireOrderPayView *payView;
@property (nonatomic,strong) ZCComfireOrderDetailView *detailView;
@property (nonatomic,strong) ZCComfireOrderAddressView *addressView;
@property (nonatomic,strong) ZCArrivePlaceView *placeView;
@property (nonatomic,strong) ZCPayTypeView *payTypeView;
@property (nonatomic,strong) NSMutableArray *addressArr;
@property (nonatomic,strong) ZCShopAddressModel *addressModel;
@property (nonatomic,strong) ZCShopGoodsModel *goodsModel;
@property (nonatomic,strong) ZCGoodsTypeModel *typeModel;
@property (nonatomic,assign) NSInteger goodsNum;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy)  NSString *order;
@property (nonatomic,assign) BOOL signSuc;

@end

@implementation ZCOrderComfireController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    [self setupSubviews];
    [self setupSubViewsContrains];
    [self getShopAddressListInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentSuccess:)
                                                 name:kAlipayResultNotification
                                               object:nil];
}

- (void)paymentSuccess:(NSNotification *)noti {
    
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName integerValue] == 1) {
        [self showAddressView];
    } else if ([eventName integerValue] == 2) {
        [self showPayTypeView];
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName integerValue] == 1) {
        self.payView.type = PayTypeWeChat;
    } else {
        self.payView.type = PayTypeAlipay;
    }
    [self maskBtnClick];
}

- (void)showPayTypeView {
    [self.view addSubview:self.maskBtn];
    [self.view addSubview:self.payTypeView];
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.payTypeView.frame = CGRectMake(0, SCREEN_H - self.payTypeView.height, SCREEN_W, self.payTypeView.height);
    }];
}

- (void)showAddressView {
    [self.view addSubview:self.maskBtn];
    [self.view addSubview:self.placeView];
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.placeView.frame = CGRectMake(0, SCREEN_H - self.placeView.height, SCREEN_W, self.placeView.height);
        self.placeView.dataArr = self.addressArr;
    }];
    kweakself(self);
    self.placeView.sureAddressOperate = ^(id  _Nonnull value) {
        weakself.addressModel = value;
        weakself.addressView.model = weakself.addressModel;
        [weakself maskBtnClick];
    };
}

- (void)maskBtnClick {
    self.maskBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.placeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.placeView.height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.payTypeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.payTypeView.height);
    }];
}
- (void)setupSubviews {
    self.addressView = [[ZCComfireOrderAddressView alloc] init];
    self.addressView.model = self.params[@"data"];
    self.detailView = [[ZCComfireOrderDetailView alloc] init];
    self.detailView.model = self.goodsModel;
    self.detailView.typeModel = self.typeModel;
    self.detailView.num = [self.params[@"num"] integerValue];
    self.payView = [[ZCComfireOrderPayView alloc] init];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [self setupBottomViews:bottomView];
    
}

- (void)setupBottomViews:(UIView *)bottomView {
    
    NSString *price = @"";
    if (self.typeModel != nil) {
        price = [ZCDataTool reviseString:[NSString stringWithFormat:@"%f", [self.typeModel.sellPriceDou doubleValue] * self.goodsNum]];
    }
    UILabel *titleL = [self.view createSimpleLabelWithTitle:[NSString stringWithFormat:@"¥%@ %@", price, NSLocalizedString(@"立即支付", nil)] font:15 bold:NO color:[ZCConfigColor whiteColor]];
    [bottomView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(bottomView.mas_top).offset(AUTO_MARGIN(30));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payOperate)];
    [bottomView addGestureRecognizer:tap];
}

- (void)payOperate {
    if (self.addressModel == nil) {
        [self.view makeToast:NSLocalizedString(@"请选择地址", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSString *payType = @"";
    if (self.payView.type == PayTypeWeChat) {
        payType = @"2";
    } else {
        payType = @"11";
    }
    
    NSDictionary *dic = @{@"productSkuId":self.typeModel.ID,
                          @"count":@(self.goodsNum),
                          @"addressId":self.addressModel.ID,
                          @"payType":payType
    };
    NSLog(@"%@", dic);
    [ZCShopManage payShopGoodsOperateInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        NSDictionary *codeDic = responseObj[@"data"];
        NSLog(@"aliCode--->%@", codeDic);
        if (self.payView.type == PayTypeWeChat) {
            self.order = checkSafeContent(codeDic[@"outTradeNo"]);//订单号
            PayReq *request  = [[PayReq alloc] init];
            request.partnerId= codeDic[@"partnerid"];
            request.prepayId = codeDic[@"prepayid"];
            request.package  = codeDic[@"package"];
            request.nonceStr = codeDic[@"noncestr"];
            request.timeStamp= [codeDic[@"timestamp"] intValue];
            request.sign     = codeDic[@"sign"];
            [WXApi sendReq:request completion:^(BOOL success) {
                
            }];
            [self addQueryTimer];
        } else {
            self.order = checkSafeContent(codeDic[@"outTradeNo"]);//订单号
            [[AlipaySDK defaultService] payOrder:codeDic[@"body"]
                                      fromScheme:@"com.procircle.PowerDance"
                                        callback:^(NSDictionary *resultDic) {
                
                NSLog(@"reslut = %@",resultDic);
            }];
            
            [self addQueryTimer];
        }
    }];
}

- (void)addQueryTimer {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)queryOrderInfo {
    [ZCShopManage queryOrderStatusInfo:@{@"order":checkSafeContent(self.order)} completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.signSuc) {
                } else {
                    self.signSuc = YES;
                    [self.timer invalidate];
                    self.timer = nil;
                    [HCRouter router:@"OrderSuccess" params:@{} viewController:self animated:YES];
                }
            });
        }
    }];
}

- (void)setupSubViewsContrains {
    [self.view addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    [self.view addSubview:self.payView];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.detailView.mas_bottom).offset(AUTO_MARGIN(15));
    }];
}

- (void)getShopAddressListInfo {
    [ZCShopManage queryShopArriveAddressListInfo:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *addressList = responseObj[@"data"];
        self.addressArr = [ZCShopAddressModel mj_objectArrayWithKeyValuesArray:addressList];
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.signSuc = NO;
    self.goodsModel = self.params[@"goods"];
    self.addressModel = self.params[@"data"];
    self.goodsNum = [self.params[@"num"] integerValue];
    self.typeModel = self.params[@"type"];
    self.titleStr = NSLocalizedString(@"确认订单", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (ZCArrivePlaceView *)placeView {
    if (!_placeView) {
        _placeView = [[ZCArrivePlaceView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(400))];
    }
    return _placeView;
}

- (ZCPayTypeView *)payTypeView {
    if (!_payTypeView) {
        _payTypeView = [[ZCPayTypeView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(300))];
    }
    return _payTypeView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(queryOrderInfo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
