//
//  CFFSmartRulerDetailTopView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import "CFFSmartRulerDetailTopView.h"
#import "CFFSmartRulerDataView.h"
#import "CFFSmartRulerRecordModel.h"

@interface CFFSmartRulerDetailTopView ()

@property (nonatomic,strong) UIImageView *ArmIv;//手臂
@property (nonatomic,strong) UIImageView *butIv;//tun
@property (nonatomic,strong) UIImageView *waistIv;//腰
@property (nonatomic,strong) UIImageView *bigIv;
@property (nonatomic,strong) UIImageView *smallIv;
@property (nonatomic,strong) UIImageView *chestIv;//胸
@property (nonatomic,strong) UIImageView *shoulderIv;//肩膀
@property (nonatomic,strong) NSMutableArray *viewArr;
@property (nonatomic,strong) NSMutableArray *viewTArr;
@property (nonatomic,strong) NSMutableArray *viewBgArr;
@property (nonatomic,strong) NSMutableDictionary *parms;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UIView  *armView;
@property (nonatomic,strong) UIView  *chestView;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UILabel *selDataL;
@property (nonatomic,strong) UILabel *selTitleL;
@property (nonatomic,strong) UIImageView *selectIv;
@property (nonatomic,strong) UIImageView *bgCircleIv;

@end

@implementation CFFSmartRulerDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.viewArr = [NSMutableArray array];
    self.viewTArr = [NSMutableArray array];
    self.viewBgArr = [NSMutableArray array];
    self.parms = [NSMutableDictionary dictionary];
    NSString *sexImage;
    CGFloat chestTop;
    CGFloat waistTop;
    CGFloat bigTop;
    CGFloat shoulderTop;
    CGFloat shoulderLead;
    CGFloat armTop;
    
    if ([kUserStore.userData[@"sex"] integerValue] == 0) {
        sexImage = @"body_man";
        chestTop = 158;
        waistTop = 9;
        bigTop = 19;
        shoulderTop = 100;
        shoulderLead = -17;
        armTop = 97;
    } else {
        sexImage = @"body_woman";
        chestTop = 174;
        waistTop = 13;
        bigTop = 13;
        shoulderTop = 122;
        shoulderLead = -16;
        armTop = 120;
    }
    UIImageView *manIv = [[UIImageView alloc] initWithImage:kIMAGE(sexImage)];//body_woman body_man
    [self addSubview:manIv];
    [manIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(73));
    }];
    
    UIImageView *bigIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_big")];
    [self addSubview:bigIv];
    self.bgCircleIv = bigIv;
    [bigIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(manIv.mas_bottom).offset(AUTO_MARGIN(-30));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    //胸
    self.chestIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_xiong")];
    [self addSubview:self.chestIv];
    
    [self.chestIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(chestTop));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //腰
    self.waistIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_yao")];
    [self addSubview:self.waistIv];
    [self.waistIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chestIv.mas_bottom).offset(AUTO_MARGIN(waistTop));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    self.butIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_tun")];
    [self addSubview:self.butIv];
    [self.butIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.waistIv.mas_bottom).offset(AUTO_MARGIN(4));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    self.bigIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_datui")];
    [self addSubview:self.bigIv];
    [self.bigIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.butIv.mas_bottom).offset(AUTO_MARGIN(bigTop));
        make.leading.mas_equalTo(self.butIv.mas_leading).offset(AUTO_MARGIN(8));
    }];

    self.smallIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_xiaotui")];
    [self addSubview:self.smallIv];
    [self.smallIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigIv.mas_bottom).offset(AUTO_MARGIN(32));
        make.leading.mas_equalTo(self.bigIv.mas_leading).offset(AUTO_MARGIN(39));
    }];
 
    //肩膀
    self.shoulderIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_jian")];
    [self addSubview:self.shoulderIv];
    [self.shoulderIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(shoulderTop));
        make.leading.mas_equalTo(self.chestIv.mas_leading).offset(AUTO_MARGIN(shoulderLead));
    }];
    //手臂
    self.ArmIv = [[UIImageView alloc] initWithImage:kIMAGE(@"circle_bi")];
    [self addSubview:self.ArmIv];
    [self.ArmIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(armTop));
        make.leading.mas_equalTo(self.chestIv.mas_trailing).offset(AUTO_MARGIN(8));
    }];
    
    [self setSubviewsAlpha:0.2];
    
    [self createSubViewButton];
        
}

- (void)setSubviewsAlpha:(CGFloat)alpha {
    self.chestIv.alpha = alpha;
    self.bigIv.alpha = alpha;
    self.smallIv.alpha = alpha;
    self.waistIv.alpha = alpha;
    self.butIv.alpha = alpha;
    self.ArmIv.alpha = alpha;
    self.shoulderIv.alpha = alpha;
}

- (void)tapOperate:(UITapGestureRecognizer *)tap {
    if (self.selectView == tap.view) return;
    [self setSelectTargetView:tap.view.tag];
    [tap.view routerWithEventName:[NSString stringWithFormat:@"%tu", tap.view.tag]];
}

- (void)createSubViewButton {
     
    self.armView = [self createLeftButtonWithIndex:0 marginView:nil];
    UIView *chestView = [self createLeftButtonWithIndex:1 marginView:nil];
    self.chestView = chestView;
    UIView *butView = [self createLeftButtonWithIndex:2 marginView:chestView];
    [self createLeftButtonWithIndex:3 marginView:butView];
    UIView *shoulderView = [self createLeftButtonWithIndex:4 marginView:nil];
    UIView *waistView = [self createLeftButtonWithIndex:5 marginView:shoulderView];
    [self createLeftButtonWithIndex:6 marginView:waistView];
    [self setSelectTargetView:0];
}

- (void)setSelectTargetView:(NSInteger)index {
    self.selectView.backgroundColor = UIColor.whiteColor;
    self.selDataL.textColor = kCFF_COLOR_CONTENT_TITLE;
    self.selTitleL.textColor = kCFF_COLOR_SUB_TITLE;
    [self setSelectColor:self.viewBgArr[index]];
    self.selectView = self.viewBgArr[index];
    
    UILabel *selL = self.viewTArr[index];
    selL.textColor = UIColor.whiteColor;
    self.selTitleL = selL;
    
    UILabel *selDataL = self.viewArr[index];
    selDataL.textColor = UIColor.whiteColor;
    self.selDataL = selDataL;
    self.selectIv.alpha = 0.2;
    UIImageView *selectIv = [self convertSelectWithIndex:index];
    selectIv.alpha = 1.0;
    self.selectIv = selectIv;
}

- (void)setParmsValue:(NSString *)content index:(NSInteger)index {
    [self.parms setValue:content forKey:[self convertKeyWithIndex:index]];
}

- (UIView *)createLeftButtonWithIndex:(NSInteger)index marginView:(UIView *)marginView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOperate:)];
    UIView *view = [[UIView alloc] init];
    view.layer.backgroundColor = [UIColor.whiteColor CGColor];
    view.tag = index;
    [view addGestureRecognizer:tap];
    [self addSubview:view];
    [self.viewBgArr addObject:view];
    if (index < 4) {
        if (index == 0) {
            view.frame = CGRectMake(kCFF_SCREEN_WIDTH - AUTO_MARGIN(100), AUTO_MARGIN(50), AUTO_MARGIN(90), 38);
        } else {
            if (marginView != nil) {
                view.frame = CGRectMake(kCFF_SCREEN_WIDTH - AUTO_MARGIN(100), CGRectGetMaxY(marginView.frame) + 20, AUTO_MARGIN(90), 38);
            } else {
                view.frame = CGRectMake(kCFF_SCREEN_WIDTH - AUTO_MARGIN(100), CGRectGetMaxY(self.armView.frame) + AUTO_MARGIN(78), AUTO_MARGIN(90), 38);
            }
        }
    } else {
        if (marginView != nil) {
            view.frame = CGRectMake(AUTO_MARGIN(10),  CGRectGetMaxY(marginView.frame) + 20, AUTO_MARGIN(90), 38);
        } else {
            view.frame = CGRectMake(AUTO_MARGIN(10), CGRectGetMinY(self.chestView.frame), AUTO_MARGIN(90), 38);
        }
    }
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = FONT_SYSTEM(14);
    titleL.text = self.titleArr[index];
    titleL.textColor = kCFF_COLOR_SUB_TITLE;
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(view.mas_leading).offset(8);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(50));
    }];
    [self.viewTArr addObject:titleL];
    UILabel *contentL = [[UILabel alloc] init];
    contentL.font = FONT_SYSTEM(14);
    contentL.textColor = kCFF_COLOR_CONTENT_TITLE;
    [view addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view.mas_trailing).inset(8);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    contentL.text = @"---";
    [self.viewArr addObject:contentL];
    [self createCornerWithButton:view];
    return view;
    
}

- (void)setSelectColor:(UIView *)view {
   view.backgroundColor = [UIColor colorWithRed:48/255.0 green:203/255.0 blue:165/255.0 alpha:1.0];
}

- (void)createCornerWithButton:(UIView *)button {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds   byRoundingCorners:UIRectCornerTopLeft |    UIRectCornerBottomRight    cornerRadii:CGSizeMake(19, 19)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[NSLocalizedString(@"臂", nil), NSLocalizedString(@"胸", nil), NSLocalizedString(@"臀", nil), NSLocalizedString(@"小腿", nil), NSLocalizedString(@"肩膀", nil), NSLocalizedString(@"腰", nil), NSLocalizedString(@"大腿", nil)];
    }
    return _titleArr;
}

- (UIImageView *)convertSelectWithIndex:(NSInteger)index {
    UIImageView *selectIv;
    switch (index) {
        case 0:
            selectIv = self.ArmIv;
            break;
        case 1:
            selectIv = self.chestIv;
            break;
        case 2:
            selectIv = self.butIv;
            break;
        case 3:
            selectIv = self.smallIv;
            break;
        case 4:
            selectIv = self.shoulderIv;
            break;
        case 5:
            selectIv = self.waistIv;
            break;
        case 6:
            selectIv = self.bigIv;
            break;
            
        default:
            break;
    }
    return selectIv;
}

- (NSString *)convertKeyWithIndex:(NSInteger)index {
    NSString *selectStr;
    switch (index) {
        case 0:
            selectStr = @"armSize";
            break;
        case 1:
            selectStr = @"chestSize";
            break;
        case 2:
            selectStr = @"buttocksSize";
            break;
        case 3:
            selectStr = @"lowerLegSize";
            break;
        case 4:
            selectStr = @"shoulderSize";
            break;
        case 5:
            selectStr = @"waistSize";
            break;
        case 6:
            selectStr = @"thighSize";
            break;
            
        default:
            break;
    }
    return selectStr;
}

- (void)nextSelectTargetView:(NSInteger)index {
    if (index == 6) {
        index = 0;
    } else {
        index ++;
    }
    [self setSelectTargetView:index];
}

- (void)setModel:(CFFSmartRulerRecordModel *)model {
    _model = model;
    NSArray *dataArr = @[[self convertContentWithData:model.armSize], [self convertContentWithData:model.chestSize], [self convertContentWithData:model.buttocksSize], [self convertContentWithData:model.lowerLegSize], [self convertContentWithData:model.shoulderSize], [self convertContentWithData:model.waistSize], [self convertContentWithData:model.thighSize]];
    for (int i = 0; i < dataArr.count; i ++) {
        UILabel *lb = self.viewArr[i];
        lb.text = dataArr[i];
    }
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
