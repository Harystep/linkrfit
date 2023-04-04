//
//  ZCShopOrderDetailCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCShopOrderDetailCell.h"

@interface ZCShopOrderDetailCell ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *shopNameL;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *totalPayL;

@property (nonatomic,strong) UILabel *payTypeL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *orderNoL;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) UIImageView *statusIv;
@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UIView *completeView;
@property (nonatomic,strong) UIButton *scoreBtn;

@end

@implementation ZCShopOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)shopOrderDetailCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCShopOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCShopOrderDetailCell" forIndexPath:indexPath];
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
    
    self.contentView.backgroundColor = rgba(246, 246, 246, 1);
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(234));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_order_bg")];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bgView);
    }];
    
    self.shopNameL = [self createSimpleLabelWithTitle:@"智能" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.shopNameL];
    
    self.priceL = self.totalPayL = [self setupContentViewWithPreView:self.shopNameL bold:YES title:@"¥99"];
    [self.shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(bgView).offset(AUTO_MARGIN(20));
        make.trailing.mas_equalTo(self.priceL.mas_leading).inset(AUTO_MARGIN(10));
    }];
        
    UILabel *payTitleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"实际支付", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:payTitleL];
    [payTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopNameL.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.mas_equalTo(self.shopNameL.mas_leading);
    }];
    
    self.totalPayL = [self setupContentViewWithPreView:payTitleL bold:YES title:@"¥99"];
    
    UILabel *payTypeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"支付方式", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [bgView addSubview:payTypeL];
    [payTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopNameL.mas_leading);
        make.top.mas_equalTo(payTitleL.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    self.payTypeL = [self setupContentViewWithPreView:payTypeL bold:NO title:NSLocalizedString(@"支付宝", nil)];
    
    UILabel *timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"下单时间", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [bgView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopNameL.mas_leading);
        make.top.mas_equalTo(payTypeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.timeL = [self setupContentViewWithPreView:timeL bold:NO title:@"2021-10-10 11:10"];
    
    UILabel *orderNoL = [self createSimpleLabelWithTitle:NSLocalizedString(@"订单号", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [bgView addSubview:orderNoL];
    [orderNoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopNameL.mas_leading);
        make.top.mas_equalTo(timeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.orderNoL = [self setupContentViewWithPreView:orderNoL bold:NO title:@"2000102001"];
    
    UIImageView *imageIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_flow_status")];
    self.statusIv = imageIv;
    [bgView addSubview:imageIv];
    [imageIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopNameL.mas_leading);
        make.top.mas_equalTo(orderNoL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    self.statusL = [self createSimpleLabelWithTitle:NSLocalizedString(@"配送中", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(imageIv.mas_trailing).offset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(imageIv.mas_centerY);
    }];
    
    self.completeView = [self createOrderCompleteStatusView:bgView];
    self.completeView.hidden = YES;
    
    self.finishBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"确认收货", nil) font:14 color:[ZCConfigColor whiteColor]];
    self.finishBtn.backgroundColor = [ZCConfigColor txtColor];
    [bgView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.statusIv.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(80));
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [self.finishBtn setViewCornerRadiu:AUTO_MARGIN(15)];
    [self.finishBtn addTarget:self action:@selector(finishOrderOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishOrderOperate {
    [self routerWithEventName:@"" userInfo:@{@"data":self.dataDic}];
}

- (UIView *)createOrderCompleteStatusView:(UIView *)bgView {
    
    UIView *completeView = [[UIView alloc] init];
    [bgView addSubview:completeView];
    [completeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusL.mas_centerY);
        make.trailing.mas_equalTo(bgView);
        make.width.mas_equalTo(AUTO_MARGIN(166));
    }];
    
    UIButton *scoreBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"评价", nil) font:14 color:[ZCConfigColor whiteColor]];
    [completeView addSubview:scoreBtn];
    [scoreBtn setBackgroundColor:[ZCConfigColor txtColor]];
    [scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(completeView.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(68));
        make.trailing.mas_equalTo(completeView.mas_trailing).inset(AUTO_MARGIN(15));
        make.top.bottom.mas_equalTo(completeView);
    }];
    self.scoreBtn = scoreBtn;
    scoreBtn.tag = 0;
    [scoreBtn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
    [scoreBtn setViewCornerRadiu:AUTO_MARGIN(15)];
    
    UIButton *saleBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"售后", nil) font:14 color:[ZCConfigColor txtColor]];
    [completeView addSubview:saleBtn];
    [saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(completeView.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(68));
        make.trailing.mas_equalTo(scoreBtn.mas_leading).inset(AUTO_MARGIN(15));
    }];
    saleBtn.tag = 1;
    [saleBtn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
    [saleBtn setViewBorderWithColor:1 color:[UIColor groupTableViewBackgroundColor]];
    [saleBtn setViewCornerRadiu:AUTO_MARGIN(15)];
    
    return completeView;
}

- (void)btnOperate:(UIButton *)sender {
    if (sender.tag) {
        [HCRouter router:@"ContactService" params:@{} viewController:self.superViewController animated:YES];
    } else {
        kweakself(self);
        [HCRouter router:@"GoodsCommentOperate" params:@{@"data":self.dataDic} viewController:self.superViewController animated:YES block:^(id  _Nonnull value) {
            weakself.scoreBtn.backgroundColor = rgba(43, 42, 51, 0.5);
            weakself.scoreBtn.enabled = NO;
        }];
    }
}

- (void)setType:(NSInteger)type {
    if (type) {
        self.completeView.hidden = NO;
        self.statusL.text = NSLocalizedString(@"您的订单已完成", nil);
        self.statusIv.image = kIMAGE(@"shop_flow_status_complete");
        self.finishBtn.hidden = YES;
    } else {
        self.completeView.hidden = YES;
        self.finishBtn.hidden = NO;
        self.statusIv.image = kIMAGE(@"shop_flow_status");
    }
}

- (UILabel *)setupContentViewWithPreView:(UIView *)view bold:(BOOL)bold title:(NSString *)title {
    UILabel *lb = [self createSimpleLabelWithTitle:title font:14 bold:bold color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    return lb;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSArray *productList = dataDic[@"productList"];
    self.statusL.text = checkSafeContent(dataDic[@"logisticsStatus"]);
    if (productList.count > 0) {
        NSDictionary *infoDic = productList[0];
        NSInteger count = [infoDic[@"count"] integerValue];
        self.shopNameL.text = [NSString stringWithFormat:@"%@-%@ x%tu", checkSafeContent(infoDic[@"name"]), checkSafeContent(infoDic[@"specTitle"]), count];
        double priceDou = [checkSafeContent(infoDic[@"sellPriceDou"]) doubleValue];
        NSString *priceStr = [NSString stringWithFormat:@"%f", count * priceDou];
        self.priceL.text = [NSString stringWithFormat:@"¥%@", [ZCDataTool reviseString:priceStr]];
        self.totalPayL.text = [NSString stringWithFormat:@"%@", [ZCDataTool reviseString:dataDic[@"totalFeeDou"]]];
        self.timeL.text = checkSafeContent(dataDic[@"placeOrderTime"]);
        self.orderNoL.text = checkSafeContent(dataDic[@"outTradeNo"]);        
    }
    if ([self.dataDic[@"commented"] integerValue] == 1) {
        self.scoreBtn.backgroundColor = rgba(43, 42, 51, 0.5);
        self.scoreBtn.enabled = NO;
    } else {
        self.scoreBtn.backgroundColor = [ZCConfigColor txtColor];
        self.scoreBtn.enabled = YES;
    }
    if ([dataDic[@"payType"] integerValue] == 11) {
        self.payTypeL.text = NSLocalizedString(@"支付宝", nil);
    } else {
        self.payTypeL.text = NSLocalizedString(@"微信", nil);
    }
}

@end
