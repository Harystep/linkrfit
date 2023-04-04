//
//  CFFCloudDataDiffView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/13.
//

#import "CFFCloudDataDiffView.h"

@interface CFFCloudDataDiffView ()

@property (nonatomic,strong) UILabel *weightL;

@property (nonatomic,strong) UIImageView *statusIv;

@property (nonatomic,strong) UILabel *diffL;

@property (nonatomic,strong) UILabel *decsL;

@end

@implementation CFFCloudDataDiffView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *diffView = [[UIView alloc] init];
    [self addSubview:diffView];
    
    UIView *targetView = [[UIView alloc] init];
    [self addSubview:targetView];
    
    [diffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(15));
        make.bottom.top.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(92));
        make.width.mas_equalTo(targetView);
    }];
    
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diffView.mas_trailing).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(92));
        make.centerY.mas_equalTo(diffView.mas_centerY);
    }];
    
    [diffView setViewCornerRadiu:10];
    [targetView setViewCornerRadiu:10];
    
    [self createDiffViewSubViews:diffView];
    [self createTargetViewSubViews:targetView];
}

- (void)createDiffViewSubViews:(UIView *)targetView {
    UIView *bgView = [[UIView alloc] init];
    [targetView addSubview:bgView];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.alpha = 0.23;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    self.weightL = [self createSimpleLabelWithTitle:@"--" font:20 bold:YES color:UIColor.whiteColor];
    [targetView addSubview:self.weightL];
    [self.weightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.statusIv = [[UIImageView alloc] init];
    [targetView addSubview:self.statusIv];
    [self.statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.weightL.mas_trailing).offset(AUTO_MARGIN(4));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.weightL.mas_centerY);
    }];
    
    UILabel *tL = [self createSimpleLabelWithTitle:NSLocalizedString(@"对比上次：", nil) font:12 bold:NO color:UIColor.whiteColor];
    [targetView addSubview:tL];
    [tL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(targetView).inset(AUTO_MARGIN(15));
    }];
    
    self.decsL = [self createSimpleLabelWithTitle:@"--" font:12 bold:NO color:UIColor.whiteColor];
    [targetView addSubview:self.decsL];
    [self.decsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tL);
        make.leading.mas_equalTo(tL.mas_trailing);
    }];
    
}

- (void)createTargetViewSubViews:(UIView *)targetView {
    UIView *bgView = [[UIView alloc] init];
    [targetView addSubview:bgView];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.alpha = 0.23;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    
    self.diffL = [self createSimpleLabelWithTitle:@"--" font:20 bold:YES color:UIColor.whiteColor];
    [targetView addSubview:self.diffL];
    [self.diffL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(targetView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(20));
    }];
            
    UILabel *tL = [self createSimpleLabelWithTitle:NSLocalizedString(@"达成体重目标", nil) font:12 bold:NO color:UIColor.whiteColor];
    [targetView addSubview:tL];
    [tL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(targetView).inset(AUTO_MARGIN(15));
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    double target = [checkSafeContent(kUserStore.userData[@"targetWeight"]) doubleValue];
    if (dataArr.count > 1) {
        NSDictionary *first = dataArr[0];
        NSDictionary *secord = dataArr[1];
        self.weightL.text = [NSString stringWithFormat:@"%.1f", [first[@"weight"] doubleValue]];
        double fisrtW = [first[@"weight"] doubleValue];
        double secordW = [secord[@"weight"] doubleValue];
        if (fisrtW == secordW) {
            self.statusIv.hidden = YES;
            self.weightL.text = @"0.0KG";
            self.decsL.text = NSLocalizedString(@"相同", nil);
        } else {
            self.statusIv.hidden = NO;
            if (fisrtW > secordW) {
                self.statusIv.image = kIMAGE(@"home_weight_up");
                self.weightL.text = [NSString stringWithFormat:@"%.1f", fisrtW - secordW];
                self.decsL.text = NSLocalizedString(@"上升了", nil);
            } else {
                self.statusIv.image = kIMAGE(@"home_weight_down");
                self.weightL.text = [NSString stringWithFormat:@"%.1f", secordW - fisrtW];
                self.decsL.text = NSLocalizedString(@"下降了", nil);
            }
        }
        [self setDiffWeight:fisrtW target:target];
    } else if (dataArr.count == 1){
        NSDictionary *first = dataArr[0];
        double fisrtW = [first[@"weight"] doubleValue];
        self.weightL.text = @"--";
        self.statusIv.hidden = YES;
        self.decsL.text = NSLocalizedString(@"无对比", nil);
        [self setDiffWeight:fisrtW target:target];
    }
}

- (void)setDiffWeight:(double)weight target:(double)target {
    if (weight - target != 0.0) {
        NSString *content = [NSString stringWithFormat:@"%.1fKG", weight - target];
        if (weight > target) {
            content = [NSString stringWithFormat:@"%@%.1fKG", @"-", weight - target];
        } else {
            content = [NSString stringWithFormat:@"%@%.1fKG", @"+", target - weight];
        }
        self.diffL.text = content;
    } else {
        self.diffL.text = @"0KG";
    }
}

@end
