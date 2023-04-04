//
//  ZCHomeTrainPlanHeightGuideView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/29.
//

#import "ZCHomeTrainPlanHeightGuideView.h"
#import "TTScrollRulerView.h"

@interface ZCHomeTrainPlanHeightGuideView ()<rulerDelegate>

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIView *rulerContainer;
@property (nonatomic,strong) TTScrollRulerView *ruler;

@end

@implementation ZCHomeTrainPlanHeightGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_plan_guide_bg")];
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"6、请选择你的当前身高", nil) font:14 bold:NO color:[ZCConfigColor point8TxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];

    UIView *targetView = [[UIView alloc] init];
    [self addSubview:targetView];
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(10));
    }];       
        
    self.numL = [self createSimpleLabelWithTitle:NSLocalizedString(@"150CM", nil) font:22 bold:YES color:[ZCConfigColor point8TxtColor]];
    [targetView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(25));
    }];
    
    UIImageView *coverIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_guide_cover")];
    [targetView addSubview:coverIv];
    [coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(targetView);
        make.top.mas_equalTo(self.numL.mas_bottom).offset(5);
        make.height.mas_equalTo(75);
    }];
    coverIv.userInteractionEnabled = YES;
    
    [targetView addSubview:self.rulerContainer];
    [self.rulerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numL.mas_bottom).offset(AUTO_MARGIN(20));
        make.leading.trailing.mas_equalTo(targetView);
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    [self.rulerContainer addSubview:self.ruler];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_arrow_down")];
    [targetView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(self.numL.mas_bottom).inset(8);
    }];
    
    ZCSimpleButton *btn = [self createShadowButtonWithTitle:NSLocalizedString(@"下一步", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [targetView addSubview:btn];
    btn.backgroundColor = [ZCConfigColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView);
        make.width.mas_equalTo(AUTO_MARGIN(182));
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(12));
        
    }];
    [btn addTarget:self action:@selector(btnOperate) forControlEvents:UIControlEventTouchUpInside];
    [btn configureLeftToRightViewColorGradient:btn width:AUTO_MARGIN(182) height:36 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:18];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [self addSubview:leftBtn];
    [leftBtn setImage:kIMAGE(@"home_guide_arrow_left") forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
    }];
    [leftBtn addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.alpha = 0.6;
}

- (void)backOperate {
    [self routerWithEventName:@"heightBack" userInfo:@{}];
}

- (void)rulerWith:(NSInteger)value {
    if (value >= 100 && value <= 300){
        self.numL.text = [NSString stringWithFormat:@"%tuCM", value];
    }
}

- (void)btnOperate {
    NSString *content = [self.numL.text substringWithRange:NSMakeRange(0, self.numL.text.length - 2)];
    [self routerWithEventName:@"heightNext" userInfo:@{@"height":content}];
    [self saveUserInfoWithData:@{@"height":checkSafeContent(content)}];
    
}

- (void)saveUserInfoWithData:(NSDictionary *)parm {
    
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
    }];
}

- (UIView *)rulerContainer {
    if (!_rulerContainer) {
        _rulerContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_W-AUTO_MARGIN(110), 100)];
        _rulerContainer.clipsToBounds = YES;
    }
    return _rulerContainer;
}

- (TTScrollRulerView *)ruler {
    if (!_ruler) {
        _ruler = [[TTScrollRulerView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_W - AUTO_MARGIN(80), 120)];
        _ruler.rulerDelegate = self;
        _ruler.rulerDirection = RulerDirectionHorizontal;//设置滚动方向，默认横向滚动
        _ruler.rulerFace = RulerFace_down_right;//设置刻度位置，下方
        _ruler.lockMin = 100;//最小值
        _ruler.lockMax = 300;//最大值
        _ruler.unitValue = 1; //一个刻度代表的数值
        double weight = 150;
        _ruler.lockDefault = weight;//默认值
        _ruler.rulerBackgroundColor = [UIColor clearColor];
        _ruler.pointerImage = nil;
        _ruler.pointerBackgroundColor = rgba(142, 207, 254, 1);
        [_ruler classicRuler];
    }
    return _ruler;
}

@end
