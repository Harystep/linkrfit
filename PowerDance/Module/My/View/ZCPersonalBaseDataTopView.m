//
//  ZCPersonalBaseDataCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCPersonalBaseDataTopView.h"

@interface ZCPersonalBaseDataTopView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *userIconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) NSMutableArray *viewArr;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation ZCPersonalBaseDataTopView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(68));
        make.height.mas_equalTo(AUTO_MARGIN(230));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
    }];
    self.bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.bgView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"my_center_top_bg")];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(168));
    }];
    
    UIView *iconView = [[UIView alloc] init];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(76));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(35));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(70));
    }];
    iconView.backgroundColor = [ZCConfigColor whiteColor];
    [iconView setViewCornerRadiu:AUTO_MARGIN(38)];
    
    self.userIconIv = [[UIImageView alloc] init];
    [iconView addSubview:self.userIconIv];
    [self.userIconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(70));
        make.centerX.mas_equalTo(iconView.mas_centerX);
        make.centerY.mas_equalTo(iconView.mas_centerY);
    }];
    [self.userIconIv setViewCornerRadiu:AUTO_MARGIN(35)];
    
    UIButton *setBtn = [[UIButton alloc] init];
    [self.contentView addSubview:setBtn];
    setBtn.backgroundColor = [ZCConfigColor whiteColor];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(26));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(76));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
    }];
    [setBtn setImage:kIMAGE(@"my_center_top_set") forState:UIControlStateNormal];
    [setBtn setViewCornerRadiu:AUTO_MARGIN(13)];
    setBtn.tag = 0;
    [setBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *serviceBtn = [[UIButton alloc] init];
    [self.contentView addSubview:serviceBtn];
    serviceBtn.backgroundColor = [ZCConfigColor whiteColor];
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(26));
        make.centerY.mas_equalTo(setBtn.mas_centerY);
        make.trailing.mas_equalTo(setBtn.mas_leading).inset(AUTO_MARGIN(15));
    }];
    serviceBtn.tag = 1;
    [serviceBtn setImage:kIMAGE(@"my_center_top_service") forState:UIControlStateNormal];
    [serviceBtn setViewCornerRadiu:AUTO_MARGIN(13)];
    [serviceBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *infoBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"个人资料", nil) font:AUTO_MARGIN(10) color:rgba(138, 205, 215, 1)];
    [self.contentView addSubview:infoBtn];
    infoBtn.backgroundColor = [ZCConfigColor whiteColor];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(62));
        make.height.mas_equalTo(AUTO_MARGIN(26));
        make.centerY.mas_equalTo(setBtn.mas_centerY);
        make.trailing.mas_equalTo(serviceBtn.mas_leading).inset(AUTO_MARGIN(15));
    }];
    infoBtn.tag = 2;
    [infoBtn setViewCornerRadiu:AUTO_MARGIN(13)];
    [infoBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameL = [self createSimpleLabelWithTitle:@" " font:AUTO_MARGIN(17) bold:YES color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(iconView.mas_bottom).offset(AUTO_MARGIN(18));
    }];
    
    self.statusBtn = [[UIButton alloc] init];
    [self.bgView addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
        make.leading.mas_equalTo(self.nameL.mas_trailing).offset(AUTO_MARGIN(5));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    [self.statusBtn setImage:kIMAGE(@"personal_data_open") forState:UIControlStateNormal];
    [self.statusBtn setImage:kIMAGE(@"personal_data_close") forState:UIControlStateSelected];
    [self.statusBtn addTarget:self action:@selector(dataShowStatus) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn.selected = [ZCDataTool getUserShowCenterDataStatus];
    
    UIView *dataView = [[UIView alloc] init];
    [self.contentView addSubview:dataView];
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(35));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(64));
    }];
    [dataView setViewCornerRadiu:3];
    [dataView setViewColorAlpha:0.1 color:rgba(138, 205, 215, 1)];
    
    CGFloat width = (SCREEN_W-AUTO_MARGIN(35)*2-AUTO_MARGIN(40))/3.0;
    self.viewArr = [NSMutableArray array];
    NSArray *titleArr = @[NSLocalizedString(@"身高 (CM)", nil), NSLocalizedString(@"体重 (KG)", nil), @"BMI"];
    for (int i = 0; i < 3; i ++) {
        UIView *itemView = [[UIView alloc] init];
        [dataView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(dataView);
            make.leading.mas_equalTo(dataView.mas_leading).offset(width*i);
            make.width.mas_equalTo(width);
        }];
        UILabel *numL = [self createSimpleLabelWithTitle:@"--" font:19 bold:YES color:[ZCConfigColor txtColor]];
        [itemView addSubview:numL];
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemView.mas_centerX);
            make.top.mas_equalTo(itemView.mas_top).offset(16);
        }];
        UILabel *titleL = [self createSimpleLabelWithTitle:titleArr[i] font:10 bold:NO color:[ZCConfigColor point6TxtColor]];
        [itemView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemView.mas_centerX);
            make.top.mas_equalTo(numL.mas_bottom).offset(4);
        }];
        [self.viewArr addObject:numL];
    }
    
    UIButton *goBtn = [[UIButton alloc] init];
    [dataView addSubview:goBtn];
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(40));
        make.top.bottom.trailing.mas_equalTo(dataView);
    }];
    [goBtn setImage:kIMAGE(@"personal_data_arow") forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(checkDataOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self bindUserBaseData];
}
#pragma -- mark 展示数据状态
- (void)dataShowStatus {
    self.statusBtn.selected = !self.statusBtn.selected;
    [ZCDataTool saveUserShowCenterDataStatus:self.statusBtn.selected];
    NSArray *dataArr = @[checkSafeContent(self.dataDic[@"height"]), checkSafeContent(self.dataDic[@"weight"]), checkSafeContent(self.dataDic[@"bmi"])];
    if ([ZCDataTool getUserShowCenterDataStatus]) {
        dataArr = @[@"****", @"****", @"****"];
    }
    for (int i = 0; i < self.viewArr.count; i ++) {
        UILabel *lb = self.viewArr[i];
        lb.text = dataArr[i];
    }
}

#pragma -- mark 监控数据
- (void)bindUserBaseData {
    kweakself(self);
    [RACObserve(kUserStore, userData) subscribeNext:^(id  _Nullable x) {
        [weakself.userIconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(x[@"imgUrl"])] placeholderImage:kIMAGE(@"login_icon")];
        [ZCDataTool saveUserPortraint:x[@"imgUrl"]];
        weakself.nameL.text = checkSafeContent(x[@"nickName"]);
    }];
}

#pragma -- mark 查看个人数据
- (void)checkDataOperate {
//    [HCRouter router:@"PersonalHealthyData" params:self.dataDic viewController:self.superViewController animated:YES];
    [HCRouter router:@"PowerPlatform" params:@{} viewController:self.superViewController];
}

- (void)infoBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0://设置
            [HCRouter router:@"MoreSet" params:@{} viewController:self.superViewController animated:YES];
            break;
        case 1://客服
            [HCRouter router:@"ContactService" params:@{} viewController:self.superViewController animated:YES];
            break;
        case 2://个人资料
            [HCRouter router:@"ProfileSet" params:@{} viewController:self.superViewController animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.userIconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:kIMAGE(@"screen_icon_logo")];
    NSString *name = checkSafeContent(dataDic[@"nickName"]).length > 0?checkSafeContent(dataDic[@"nickName"]):checkSafeContent(kUserInfo.phone);
    self.nameL.text = name;
    NSString *height = [checkSafeContent(dataDic[@"height"]) doubleValue] > 0.0?checkSafeContent(dataDic[@"height"]):@"--";
    NSString *weight = [checkSafeContent(dataDic[@"weight"]) doubleValue] > 0.0?checkSafeContent(dataDic[@"weight"]):@"--";
    NSString *bmi = [checkSafeContent(dataDic[@"height"]) doubleValue] > 0.0?checkSafeContent(dataDic[@"bmi"]):@"--";
    NSArray *dataArr = @[height, weight, bmi];
    if ([ZCDataTool getUserShowCenterDataStatus]) {
        dataArr = @[@"****", @"****", @"****"];
    }
    for (int i = 0; i < self.viewArr.count; i ++) {
        UILabel *lb = self.viewArr[i];
        lb.text = dataArr[i];
    }
    
}

@end
