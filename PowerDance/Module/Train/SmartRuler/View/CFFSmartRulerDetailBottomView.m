//
//  CFFSmartRulerDetailBottomView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import "CFFSmartRulerDetailBottomView.h"
#import "CFFSmartRulerRecordModel.h"

@interface CFFSmartRulerDetailBottomView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *scaleL;
@property (nonatomic,strong) UILabel *chestL;
@property (nonatomic,strong) UILabel *butL;
@property (nonatomic,strong) UILabel *waistL;
@property (nonatomic,strong) UILabel *armL;
@property (nonatomic,strong) UILabel *bigL;
@property (nonatomic,strong) UILabel *smallL;
@property (nonatomic,strong) UILabel *shoulderL;
@property (nonatomic,strong) UILabel *scaleTL;
@property (nonatomic,strong) UILabel *chestTL;
@property (nonatomic,strong) UILabel *butTL;
@property (nonatomic,strong) UILabel *waistTL;
@property (nonatomic,strong) UILabel *armTL;
@property (nonatomic,strong) UILabel *bigTL;
@property (nonatomic,strong) UILabel *smallTL;
@property (nonatomic,strong) UILabel *shoulderTL;

@property (nonatomic,strong) UIView *sepView;

@end

@implementation CFFSmartRulerDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
        
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.bgView];
    [self.bgView setViewCornerRadius:15];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(242);
    }];
    
    self.sepView = [[UIView alloc] init];
    self.sepView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
    [self.bgView addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.leading.trailing.mas_equalTo(self.bgView).inset(AUTO_MARGIN(25));
        make.top.mas_equalTo(74);
    }];
        
    self.scaleTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.scaleTL.text = NSLocalizedString(@"腰臀比", nil);
    
    self.chestTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.chestTL.text = NSLocalizedString(@"胸围", nil);
    
    self.waistTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.waistTL.text = NSLocalizedString(@"腰围", nil);
    
    self.butTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.butTL.text = NSLocalizedString(@"臀围", nil);
    
    self.armTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.armTL.text = NSLocalizedString(@"臂围", nil);
    
    self.bigTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.bigTL.text = NSLocalizedString(@"大腿", nil);
    
    self.smallTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.smallTL.text = NSLocalizedString(@"小腿", nil);
    
    self.shoulderTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.shoulderTL.text = NSLocalizedString(@"肩围", nil);    
    
    self.scaleL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.chestL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.waistL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.butL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.armL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.bigL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.smallL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.shoulderL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    
    
    [self setupContraints];
}

- (void)setupContraints {
    [self.scaleTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading).offset(30);
        make.top.mas_equalTo(self.bgView.mas_top).offset(32);
    }];
    
    [self.scaleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scaleTL.mas_centerY);
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(30);
    }];
    
    [self.armTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading).inset(30);
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(26);
        make.height.mas_equalTo(20);
    }];
    
    [self.chestTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.armTL.mas_leading);
        make.top.mas_equalTo(self.armTL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.butTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.armTL.mas_leading);
        make.top.mas_equalTo(self.chestTL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.smallTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.armTL.mas_leading);
        make.top.mas_equalTo(self.butTL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.shoulderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(26);
        make.height.mas_equalTo(20);
    }];
    
    [self.waistL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.shoulderL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.bigL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.waistL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.shoulderTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_centerX).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.shoulderL.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [self.waistTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_centerX).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.waistL.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [self.bigTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_centerX).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.bigL.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [self.waistL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.shoulderL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.bigL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(30));
        make.top.mas_equalTo(self.waistL.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.armL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.armTL.mas_centerY);
        make.leading.mas_equalTo(self.armTL.mas_trailing).offset(28);
    }];
    
    [self.chestL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.chestTL.mas_centerY);
        make.leading.mas_equalTo(self.chestTL.mas_trailing).offset(28);
    }];
    
    [self.butL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.butTL.mas_centerY);
        make.leading.mas_equalTo(self.butTL.mas_trailing).offset(28);
    }];
    
    [self.smallL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.smallTL.mas_centerY);
        make.leading.mas_equalTo(self.smallTL.mas_trailing).offset(28);
    }];
    
}

- (UILabel *)createSubLabelWithFont:(CGFloat)font color:(UIColor *)color bold:(BOOL)flag {
    UILabel *lb = [[UILabel alloc] init];
    [self.bgView addSubview:lb];
    if (flag) {
        lb.font = FONT_BOLD(font);
    } else {
        lb.font = FONT_SYSTEM(font);
    }
    lb.textColor = color;
    return lb;
}

- (void)setModel:(CFFSmartRulerRecordModel *)model {
    _model = model;
    self.chestL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.chestSize], [self convertUnitWithNum:model.unit]];
    self.waistL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.waistSize], [self convertUnitWithNum:model.unit]];
    self.armL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.armSize], [self convertUnitWithNum:model.unit]];
    self.shoulderL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.shoulderSize], [self convertUnitWithNum:model.unit]];
    self.bigL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.thighSize], [self convertUnitWithNum:model.unit]];
    self.smallL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.lowerLegSize], [self convertUnitWithNum:model.unit]];
    self.butL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.buttocksSize], [self convertUnitWithNum:model.unit]];
    
    self.scaleL.text = [NSString stringWithFormat:@"%.2f", [model.waistSize doubleValue]/[model.buttocksSize doubleValue]];
}

- (NSString *)convertUnitWithNum:(NSString *)num {
    NSString *unit;
    if ([num integerValue] == 1) {
        unit = @"CM";
    } else {
        unit = @"IN";
    }
    return unit;
}

- (NSString *)convertContentWithData:(NSString *)data {
    NSString *content;
    data = checkSafeContent(data);
    if ([data isEqualToString:@"(null)"] || [data isEqualToString:@"(NULL)"] || [data isEqualToString:@"NULL"] ||[data isEqualToString:@"null"]) {
        content = @"--";
    } else if ([data doubleValue] == 0.0) {
        content = @"--";
    } else {
        content = [CFFDataTool reviseString:data];
        content = [NSString stringWithFormat:@"%.1f", [content doubleValue]];
    }
    return content;
}

@end
