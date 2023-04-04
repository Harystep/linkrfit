//
//  ZCDeviceDescView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/27.
//

#import "ZCDeviceDescView.h"

#define kViewHeight AUTO_MARGIN(650)

@interface ZCDeviceDescView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *detailView;

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *subL;
@property (nonatomic,strong) UILabel *descL;
@property (nonatomic,strong) UIImageView *iconIv;

@end

@implementation ZCDeviceDescView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self setViewColorAlpha:0.4 color:[ZCConfigColor txtColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskBtnClick)];
    [self addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, kViewHeight)];
    self.contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:self.contentView];
    [self setupViewRound:self.contentView corners:UIRectCornerTopRight | UIRectCornerTopLeft];
    
    self.scView = [[UIScrollView alloc] init];
    [self.contentView addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(170));
    }];
    self.scView.showsVerticalScrollIndicator = NO;
    
    self.detailView = [[UIView alloc] init];
    [self.scView addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView.mas_width);
    }];
    
    UIButton *bindBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"绑定设备", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.contentView addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(29));
    }];
    [bindBtn addTarget:self action:@selector(bindBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    bindBtn.backgroundColor = [ZCConfigColor txtColor];
    [bindBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
    UIButton *knowBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"了解设备", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(bindBtn.mas_top).inset(AUTO_MARGIN(10));
    }];
    knowBtn.hidden = YES;
    [knowBtn addTarget:self action:@selector(knowBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    knowBtn.backgroundColor = rgba(0, 0, 0, 0.1);
    [knowBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
    [self createDetailViewSubviews];
    
}

- (void)createDetailViewSubviews {
    UIView *lineView = [[UIView alloc] init];
    [self.detailView addSubview:lineView];
    lineView.backgroundColor = rgba(216, 216, 216, 1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailView.mas_centerX);
        make.top.mas_equalTo(self.detailView.mas_top).offset(AUTO_MARGIN(10));
        make.width.mas_equalTo(AUTO_MARGIN(52));
        make.height.mas_equalTo(AUTO_MARGIN(5));
    }];
    [lineView setViewCornerRadiu:AUTO_MARGIN(2.5)];
    
    UILabel *nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"家庭智能健身套装", nil) font:AUTO_MARGIN(20) bold:YES color:[ZCConfigColor txtColor]];
    [self.detailView addSubview:nameL];
    self.nameL = nameL;
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailView.mas_centerX);
        make.top.mas_equalTo(lineView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"快速测量腰围", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.detailView addSubview:subL];
    self.subL = subL;
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailView.mas_centerX);
        make.top.mas_equalTo(nameL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_equipment_icon")];
    [self.detailView addSubview:iconIv];
    iconIv.contentMode = UIViewContentModeScaleAspectFit;
    self.iconIv = iconIv;
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailView.mas_centerX);
        make.width.height.mas_equalTo(AUTO_MARGIN(280));
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    NSString *content = @"拉力器，是一种适合于大众健身锻炼的器械。使用拉力器锻炼的好处在于：肱二头肌是一块有两个肌头的肌肉，其主要作用是屈臂。拉力器，是一种适合于大众健身锻炼的器械。使用拉力器锻炼的好处在于：肱二头肌是一块有两个肌头的肌肉，其主要作用是屈臂。主要作用是屈臂。主要作用是屈…";
    UILabel *descL = [self createSimpleLabelWithTitle:content font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
    [self.detailView addSubview:descL];
    self.descL = descL;
    [descL setContentLineFeedStyle];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.detailView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.detailView.mas_bottom);
    }];
    [self.descL setAttributeStringContent:content space:5 font:FONT_SYSTEM(AUTO_MARGIN(12)) alignment:NSTextAlignmentCenter];
}

#pragma -- mark 绑定设备
- (void)bindBtnOperate {
    NSString *code = checkSafeContent(self.dataDic[@"code"]);
    if ([code containsString:@"suit"]) {        
    } else {
        [self maskBtnClick];
    }
//    [ZCDataTool signKnowSmartDeviceStatus:YES code:code];
    if (self.bindDeviceOperate) {
        self.bindDeviceOperate();
    }
}
#pragma -- mark 了解设备
- (void)knowBtnOperate {
    [self maskBtnClick];
//    NSString *code = checkSafeContent(self.dataDic[@"code"]);
//    [ZCDataTool signKnowSmartDeviceStatus:YES code:code];
    if (self.knowDeviceInfoOperate) {
        self.knowDeviceInfoOperate();
    }
}

- (void)showContentView {
    self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, SCREEN_H - kViewHeight, SCREEN_W, kViewHeight);
    }];
}

- (void)maskBtnClick {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, kViewHeight);
    } completion:^(BOOL finished) {
        self.contentView.hidden = YES;
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:dataDic[@"imgUrl"]] placeholderImage:nil];
    self.subL.text = checkSafeContent(dataDic[@"subTitle"]);
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
    self.descL.text = checkSafeContent(dataDic[@"briefDesc"]);
}

@end
