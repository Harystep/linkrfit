//
//  CFFUserInfoSelectTargetView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/27.
//

#import "CFFUserInfoSelectTargetView.h"
#import "TTScrollRulerView.h"

@interface CFFUserInfoSelectTargetView ()<rulerDelegate>

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) NSMutableArray *viewArr;

@property (nonatomic,strong) NSDictionary *selectView;

@property (nonatomic,strong) UILabel *targetL;
@property (nonatomic,strong) UILabel *subL;

@property (nonatomic,strong) UIButton *btnBottom;

@property (nonatomic,strong) UIView *rulerContainer;
@property (nonatomic,strong) TTScrollRulerView *ruler;
@property (nonatomic,strong) UIImageView *imgRulerIndicator;

@property (nonatomic,strong) UIView *selectTargetView;

@end

@implementation CFFUserInfoSelectTargetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.viewArr = [NSMutableArray array];
    
    [self addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).mas_offset(AUTO_MARGIN(75));
    }];
    
    [self addSubview:self.subL];
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.targetL.mas_centerX);
        make.top.mas_equalTo(self.targetL.mas_bottom).offset(5);
    }];
    [self addSubview:self.lblWeight];
    [self.lblWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.subL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    [self addSubview:self.imgRulerIndicator];
    [self.imgRulerIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.lblWeight.mas_bottom).offset(AUTO_MARGIN(5));
    }];
    [self addSubview:self.rulerContainer];
    [self.rulerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgRulerIndicator.mas_bottom).offset(4);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(90);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [self.rulerContainer addSubview:self.ruler];
    
}


- (void)rulerWith:(NSInteger)value {
    if (value >= 0 && value <= 300){
        self.lblWeight.text = [NSString stringWithFormat:@"%tu", value];
        [kUserStore.saveData setValue:@(value) forKey:@"targetWeight"];
    }
}

- (UIView *)rulerContainer {
    if (!_rulerContainer) {
        _rulerContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kCFF_SCREEN_WIDTH, 150)];
        _rulerContainer.clipsToBounds = YES;
        _rulerContainer.backgroundColor = rgba(0, 0, 0, 0.02);
    }
    return _rulerContainer;
}

- (TTScrollRulerView *)ruler {
    if (!_ruler) {
        _ruler = [[TTScrollRulerView alloc] initWithFrame:CGRectMake(0, -35, kCFF_SCREEN_WIDTH, 100)];
        _ruler.rulerDelegate = self;
        _ruler.rulerDirection = RulerDirectionHorizontal;//设置滚动方向，默认横向滚动
        _ruler.rulerFace = RulerFace_down_right;//设置刻度位置，下方    
        _ruler.lockMin = 0;//最小值
        _ruler.lockMax = 300;//最大值
        _ruler.unitValue = 1; //一个刻度代表的数值
        double weight = 20;        
        if (kUserStore.userData != nil) {
            weight = [checkSafeContent(kUserStore.userData[@"targetWeight"]) doubleValue];
            [kUserStore.saveData setValue:@(weight) forKey:@"targetWeight"];
        }
        _ruler.lockDefault = weight;//默认值
        _ruler.rulerBackgroundColor = UIColor.clearColor;
        _ruler.pointerImage = nil;
        _ruler.pointerBackgroundColor = [ZCConfigColor txtColor];
//        [_ruler classicRuler];
        [_ruler customRulerWithLineColor:customColorMake(43, 42, 51) NumColor:[ZCConfigColor subTxtColor] scrollEnable:YES];
    }
    return _ruler;
}
- (UIImageView *)imgRulerIndicator {
    if (!_imgRulerIndicator) {
        _imgRulerIndicator = [[UIImageView alloc] init];
        _imgRulerIndicator.image = [UIImage imageNamed:@"indicator_triangle"];
    }
    return _imgRulerIndicator;
}

- (UILabel *)lblWeight {
    if (!_lblWeight) {
        _lblWeight = [[UILabel alloc] init];
        _lblWeight.font = FONT_BOLD(35);
        _lblWeight.textColor = [ZCConfigColor txtColor];
        _lblWeight.text = checkSafeContent(kUserStore.userData[@"targetWeight"]);
    }
    return _lblWeight;
}

- (UILabel *)targetL {
    if (!_targetL) {
        _targetL = [[UILabel alloc] init];
        _targetL.font = FONT_SYSTEM(15);
        _targetL.textColor = kCFF_COLOR_CONTENT_TITLE;
        _targetL.text = NSLocalizedString(@"设置平衡目标(千克)", nil);
    }
    return _targetL;
}

- (UILabel *)subL {
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.font = FONT_SYSTEM(13);
        _subL.textColor = kCFF_COLOR_SUB_TITLE;
        _subL.text = NSLocalizedString(@"set a goal", nil);
    }
    return _subL;
}

@end
