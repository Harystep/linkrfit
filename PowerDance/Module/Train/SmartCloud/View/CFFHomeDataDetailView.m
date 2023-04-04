//
//  CFFHomeDataDetailView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/29.
//

#import "CFFHomeDataDetailView.h"
#import "CFFHomeStandardView.h"
#import "CFFCloudDataDiffView.h"

#define kAnimalTime 10
#define kTimer 30

@interface CFFHomeDataDetailView ()

@property (nonatomic,strong) CFFHomeStandardView *standardView;
@property (nonatomic,strong) CFFCloudDataDiffView *diffView;
@property (nonatomic,strong) UILabel *targetAlertL;
@property (nonatomic,strong) UIImageView *smallIv;
@property (nonatomic,strong) UIImageView *centerIv;
@property (nonatomic,strong) UIImageView *bottomIv;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation CFFHomeDataDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addTargetViewCloudIv:self];
    
    CFFHomeLastWeightView *weightView = [[CFFHomeLastWeightView alloc] init];
    self.weightView = weightView;
    [self.weightView.weightL setFontBold:50];
    self.weightView.timeL.textAlignment = NSTextAlignmentRight;
    [self addSubview:weightView];
    [weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(50)+kCFF_STATUS_BAR_HEIGHT);
        make.leading.trailing.mas_equalTo(self);
    }];
    
    CFFCloudDataDiffView *diffView = [[CFFCloudDataDiffView alloc] init];
    self.diffView = diffView;
    [self addSubview:diffView];
    [diffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(weightView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(92));
    }];
                
    self.standardView = [[CFFHomeStandardView alloc] init];
    [self addSubview:self.standardView];
    [self.standardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(diffView.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(100));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    [self.standardView setViewCornerRadiu:10];

}

- (void)setType:(NSInteger)type {
    [self.timer invalidate];
    self.timer = nil;
    self.smallIv.hidden = YES;
    self.centerIv.hidden = YES;
    NSLog(@"timer invalidate");
    self.weightView.cloudBtn.hidden = YES;
    
    [self.weightView.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.weightView.unitL.mas_centerY);
        make.leading.mas_equalTo(self.weightView.unitL.mas_trailing).offset(AUTO_MARGIN(12));
    }];
    [self.weightView.changeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.weightView.mas_trailing).inset(AUTO_MARGIN(10));
        make.height.width.mas_equalTo(AUTO_MARGIN(40));
        make.centerY.mas_equalTo(self.weightView.cloudBtn.mas_centerY);
    }];
    
}

- (void)addTargetViewCloudIv:(UIView *)targetView {
    self.smallIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [targetView addSubview:self.smallIv];
    self.smallIv.alpha = 0.2;
    self.smallIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, AUTO_MARGIN(60)+kCFF_STATUS_BAR_HEIGHT, AUTO_MARGIN(70), AUTO_MARGIN(50));
    
    self.centerIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [targetView addSubview:self.centerIv];
    self.centerIv.alpha = 0.2;
    self.centerIv.frame = CGRectMake(AUTO_MARGIN(250), CGRectGetMaxY(self.smallIv.frame) + AUTO_MARGIN(20), AUTO_MARGIN(70)*2.2, AUTO_MARGIN(50)*2.2);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self timerOperate];
    });

}


- (void)timerOperate {
    NSLog(@"come--->%tu", self.type);
    [self setSmallIvAnimal];
    [self setCenterIvAnimal];    
}

- (void)setDataWeight:(double)dataWeight {
    double weight = [kUserStore.userData[@"weight"] doubleValue];
    double target = [checkSafeContent(kUserStore.userData[@"targetWeight"]) doubleValue];
    if (weight - target != 0.0) {
        NSString *content = [NSString stringWithFormat:@"%.1fKg", weight - target];
        if (weight > target) {
            content = [NSString stringWithFormat:@"%@%.1fKg",NSLocalizedString(@"减", nil), weight - target];
        } else {
            content = [NSString stringWithFormat:@"%@%.1fKg",NSLocalizedString(@"增", nil), target - weight];
        }
        [self setWeightData:content];
    } else {
        [self setWeightData:@"--"];
    }
}

- (void)refreshStandViewData:(NSArray *)dataArr {
    self.standardView.dataArr = dataArr;
    self.weightView.dataArr = dataArr;
    self.diffView.dataArr = dataArr;
}

- (void)setWeightData:(NSString *)weight {
    NSString *content = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"还需", nil), weight, NSLocalizedString(@"来达到你的目标体重", nil)];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
    [attrString addAttribute:NSFontAttributeName value:FONT_SYSTEM(15) range:NSMakeRange(0, weight.length)];//设置所有的字体
    UIFont *boldFont = FONT_BOLD(15);
    [attrString addAttribute:NSFontAttributeName value:boldFont range:[content rangeOfString:weight]];//设置Text这四个字母的字体为粗体
    self.targetAlertL.attributedText = attrString;
}


- (void)setCenterIvAnimal {
    int alpha = arc4random() % 20 + 10;
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.centerIv.dn_width;
    int animal = arc4random() % 10 + 10;    
    [UIView animateWithDuration:animal animations:^{
        self.centerIv.frame = CGRectMake(x, self.centerIv.dn_y, self.centerIv.dn_width*ratio, self.centerIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        self.centerIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, self.centerIv.dn_y, AUTO_MARGIN(70)*2.2, AUTO_MARGIN(50)*2.2);
        [self setCenterIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.centerIv.alpha = alpha / 100.0;
    }];
}

- (void)setSmallIvAnimal{
    int alpha = arc4random() % 30 + 10;
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.smallIv.dn_width;
    int animal = arc4random() % 20 + 10;
//    double backX = (arc4random() % 30 + 100)/100.0;
    [UIView animateWithDuration:animal animations:^{
        self.smallIv.frame = CGRectMake(x, self.smallIv.dn_y, AUTO_MARGIN(70)*ratio, AUTO_MARGIN(50)*ratio);
    } completion:^(BOOL finished) {
        self.smallIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, self.smallIv.dn_y, AUTO_MARGIN(70), AUTO_MARGIN(50));
        [self setSmallIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.smallIv.alpha = alpha / 100.0;
    }];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
