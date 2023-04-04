//
//  ZCHomeTopHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/25.
//

#import "ZCHomeTopHeaderView.h"

@interface ZCHomeTopHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView  *bannerView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *muniteL;//时间

@property (nonatomic,strong) UILabel *consumeL;//消耗

@end

@implementation ZCHomeTopHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.clipsToBounds = YES;
    self.bannerView.autoScrollTimeInterval = 7.0;
    [self addSubview:self.bannerView];
    self.bannerView.backgroundColor = [ZCConfigColor bgColor];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_offset(AUTO_MARGIN(240));
    }];
    self.bannerView.pageControlBottomOffset = AUTO_MARGIN(10);
    self.bannerView.imageURLStringsGroup = @[

    ];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, AUTO_MARGIN(230), SCREEN_W, AUTO_MARGIN(40))];
    [self addSubview:titleView];
//    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.mas_equalTo(self);
//        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(-AUTO_MARGIN(10));
//        make.height.mas_equalTo(AUTO_MARGIN(40));
//    }];
    titleView.backgroundColor = [ZCConfigColor whiteColor];
    [titleView setupViewRound:titleView corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    UIView *bgView = [[UIView alloc] init];
    [titleView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(titleView);
    }];
    
    [bgView configureLeftToRightViewColorGradient:bgView width:SCREEN_W height:AUTO_MARGIN(40) one:rgba(138, 205, 215, 0.16) two:rgba(158, 168, 194, 0.1) cornerRadius:0];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_calendar_icon")];
    [titleView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.leading.mas_equalTo(titleView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"今日运动", nil) font:AUTO_MARGIN(15) bold:YES color:[ZCConfigColor txtColor]];
    [titleView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(3));
    }];
    
    UIImageView *allIcon = [[UIImageView alloc] initWithImage:kIMAGE(@"home_all_icon")];
    [titleView addSubview:allIcon];
    [allIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(titleView);
        make.height.mas_equalTo(AUTO_MARGIN(30));
        make.width.mas_equalTo(AUTO_MARGIN(110));
    }];
    allIcon.userInteractionEnabled = YES;
    
    UIButton *allBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"查看全部运动", nil) font:AUTO_MARGIN(11) color:[ZCConfigColor whiteColor]];
    [allIcon addSubview:allBtn];
    allBtn.titleLabel.font = FONT_BOLD(11);
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(allIcon);
    }];
    
    [allBtn setImage:kIMAGE(@"home_right-s") forState:UIControlStateNormal];
    [allBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:3];
    [allBtn addTarget:self action:@selector(watchTrainAllData) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomView = [[UIView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.top.mas_equalTo(titleView.mas_bottom);
    }];
   
    [self setupBottomViewSubviews];
    
    UIButton *connectBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"连接设备", nil) font:13 color:[ZCConfigColor whiteColor]];
    [self addSubview:connectBtn];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(STATUS_H+AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(AUTO_MARGIN(85));
    }];
    [connectBtn setImage:kIMAGE(@"home_device_connect") forState:UIControlStateNormal];
    [connectBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
    [connectBtn addTarget:self action:@selector(connectDeviceOperate) forControlEvents:UIControlEventTouchUpInside];
    [connectBtn setViewCornerRadiu:11];
    connectBtn.backgroundColor = rgba(0, 0, 0, 0.22);
    
    UILabel *lb = [self createSimpleLabelWithTitle:@"推荐" font:16 bold:YES color:[ZCConfigColor whiteColor]];
    lb.hidden = YES;
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(connectBtn.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
}
#pragma -- mark 连接设备
- (void)connectDeviceOperate {
    [self routerWithEventName:@"bindDeviceConnect"];
}

- (void)setupBottomViewSubviews {
 
    UIImageView *sepIcon = [[UIImageView alloc] initWithImage:kIMAGE(@"home_blue_sep_icon")];
    [self.bottomView addSubview:sepIcon];
    [sepIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
        
    UIView *sportTimeView = [[UIView alloc] init];
    [self.bottomView addSubview:sportTimeView];
    [sportTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bottomView.mas_leading).offset(AUTO_MARGIN(40));
        make.height.mas_equalTo(AUTO_MARGIN(14));
        make.top.mas_equalTo(self.bottomView.mas_top).offset(AUTO_MARGIN(22));
    }];
    
    [self configureTitleViewSubviews:sportTimeView];
    
    UIView *consumeTimeView = [[UIView alloc] init];
    [self.bottomView addSubview:consumeTimeView];
    [consumeTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bottomView.mas_trailing).inset(AUTO_MARGIN(40));
        make.height.mas_equalTo(AUTO_MARGIN(14));
        make.top.mas_equalTo(self.bottomView.mas_top).offset(AUTO_MARGIN(22));
    }];
    
    [self configureConsumeViewSubviews:consumeTimeView];
        
    self.muniteL = [self createSimpleLabelWithTitle:@"0/200" font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.bottomView addSubview:self.muniteL];
    [self.muniteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sportTimeView.mas_centerX);
        make.top.mas_equalTo(sportTimeView.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
    self.consumeL = [self createSimpleLabelWithTitle:@"0/6000" font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.bottomView addSubview:self.consumeL];
    [self.consumeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(consumeTimeView.mas_centerX);
        make.top.mas_equalTo(consumeTimeView.mas_bottom).offset(AUTO_MARGIN(10));
    }];
        
    self.muniteL.attributedText = [self.muniteL.text dn_changeFont:FONT_BOLD(28) color:[ZCConfigColor txtColor] andRange:NSMakeRange(0, 1)];
    
    self.consumeL.attributedText = [self.consumeL.text dn_changeFont:FONT_BOLD(28) color:[ZCConfigColor txtColor] andRange:NSMakeRange(0, 1)];
    
    UIView *lineView = [[UIView alloc] init];
    [self.bottomView addSubview:lineView];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.bottomView);
        make.height.mas_equalTo(AUTO_MARGIN(8));
    }];
    
}


- (void)configureTitleViewSubviews:(UIView *)titleView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_sport_time")];
    [titleView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(titleView);
        make.height.width.mas_equalTo(AUTO_MARGIN(13));
    }];
     
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"运动时长", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [titleView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(3));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"(分钟)", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor subTxtColor]];
    [titleView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleL.mas_bottom).inset(AUTO_MARGIN(1));
        make.leading.mas_equalTo(titleL.mas_trailing).offset(AUTO_MARGIN(3));
        make.trailing.mas_equalTo(titleView.mas_trailing);
    }];
}

- (void)configureConsumeViewSubviews:(UIView *)titleView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_sport_consume")];
    [titleView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(titleView);
        make.height.width.mas_equalTo(AUTO_MARGIN(13));
    }];
     
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"消耗热量", nil) font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [titleView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconIv.mas_centerY);
        make.leading.mas_equalTo(iconIv.mas_trailing).offset(AUTO_MARGIN(3));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"(千卡)", nil) font:AUTO_MARGIN(11) bold:NO color:[ZCConfigColor subTxtColor]];
    [titleView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleL.mas_bottom).inset(AUTO_MARGIN(1));
        make.leading.mas_equalTo(titleL.mas_trailing).offset(AUTO_MARGIN(3));
        make.trailing.mas_equalTo(titleView.mas_trailing);
    }];
        
}

#pragma -- mark 查看所有运动数据
- (void)watchTrainAllData {
    [HCRouter router:@"TrainPlanAllData" params:@{} viewController:self.superViewController animated:YES];
}

- (void)setBannerArr:(NSArray *)bannerArr {
    _bannerArr = bannerArr;
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSDictionary *dic in bannerArr) {
        [imageArr addObject:checkSafeContent(dic[@"imageUrl"])];
    }
    self.bannerView.imageURLStringsGroup = imageArr;
}

- (void)setTrainDic:(NSDictionary *)trainDic {
    _trainDic = trainDic;
    CGFloat totalTime = [checkSafeContent(trainDic[@"todayDuration"]) integerValue]/60.0;
    CGFloat todayTime = [checkSafeContent(trainDic[@"duration"]) integerValue]/60.0;
    NSString *totalStr = [NSString stringWithFormat:@"%.1f%@", totalTime, NSLocalizedString(@"分钟_D", nil)];
    NSString *todayStr = [NSString stringWithFormat:@"%.1f", todayTime];
    if (todayTime == 0) {
        todayStr = @"0";
    }
    NSString *time = [NSString stringWithFormat:@"%@/%@", todayStr, totalStr];
    self.muniteL.attributedText = [time dn_changeFont:FONT_BOLD(28) color:[ZCConfigColor txtColor] andRange:NSMakeRange(0, todayStr.length)];
    
    NSString *totalConsume = checkSafeContent(trainDic[@"todayEnergy"]);
    NSString *todayConsume = checkSafeContent(trainDic[@"energy"]);
    if ([todayConsume doubleValue] == 0.0) {
        todayConsume = @"0";
    }
    NSString *consume = [NSString stringWithFormat:@"%@/%@%@", todayConsume, totalConsume, NSLocalizedString(@"千卡_D", nil)];
    self.consumeL.attributedText = [consume dn_changeFont:FONT_BOLD(28) color:[ZCConfigColor txtColor] andRange:NSMakeRange(0, todayConsume.length)];
    
}

@end
