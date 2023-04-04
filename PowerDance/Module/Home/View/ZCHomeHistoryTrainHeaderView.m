//
//  ZCHomeHistoryTrainHeaderView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import "ZCHomeHistoryTrainHeaderView.h"

@interface ZCHomeHistoryTrainHeaderView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCHomeHistoryTrainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIImageView *timeIv = [[UIImageView alloc] initWithImage:kIMAGE(@"")];
    [self addSubview:timeIv];
    [timeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(10));
        make.height.width.mas_equalTo(18);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"最近一次", nil) font:16 bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeIv);
        make.leading.mas_equalTo(timeIv.mas_trailing).offset(AUTO_MARGIN(8));
    }];
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.top.mas_equalTo(timeIv.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"")];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.bottom.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(160));
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:16 bold:YES color:rgba(255, 255, 255, 1)];
    [self.iconIv addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.iconIv).offset(AUTO_MARGIN(22));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"" font:16 bold:NO color:[ZCConfigColor txtColor]];
    self.timeL.numberOfLines = 0;
    self.timeL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
    }];
    
    [self configTimeView:self.timeL time:@""];
    
}

- (void)configTimeView:(UILabel *)timeL time:(NSString *)time {
    if (time.length > 16) {
        NSArray *timeArr = [time componentsSeparatedByString:@" "];
        NSString *endStr = timeArr[1];
        NSString *timeStr = [NSString stringWithFormat:@"%@\n%@", timeArr[0], [endStr substringWithRange:NSMakeRange(0, 5)]];
        self.timeL.text = timeStr;
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = checkSafeContent(dataDic[@"name"]);
    [self configTimeView:self.titleL time:checkSafeContent(dataDic[@"createTime"])];
}

@end
