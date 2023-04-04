//
//  ZCEfficientDeviceItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/26.
//

#import "ZCEfficientDeviceItemCell.h"

@interface ZCEfficientDeviceItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIView *statusView;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation ZCEfficientDeviceItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"login_top_white_icon")];
    [self.bgView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(80));
        make.top.mas_equalTo(self.bgView.mas_top).offset(AUTO_MARGIN(25));
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
    self.statusView = [[UIView alloc] init];
    [self.bgView addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv.mas_centerX);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(5));
        make.height.width.mas_equalTo(AUTO_MARGIN(5));
    }];
    self.statusView.backgroundColor = rgba(109, 212, 0, 1);
    [self.statusView setViewCornerRadiu:AUTO_MARGIN(2.5)];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"家庭智能健身套装", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:self.nameL];
    [self.nameL setContentLineFeedStyle];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.bgView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.statusView.mas_bottom).offset(AUTO_MARGIN(25));
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:dataDic[@"cover"]] placeholderImage:nil];
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
}

@end
