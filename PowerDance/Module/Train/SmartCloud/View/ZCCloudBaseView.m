//
//  ZCCloudBaseView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCCloudBaseView.h"
#import "CFFHomeLastWeightView.h"

#define kAnimalTime 10
#define kTimer 30

@interface ZCCloudBaseView ()

@property (nonatomic,strong) UIImageView *smallIv;

@property (nonatomic,strong) UIImageView *centerIv;

@property (nonatomic,strong) UIImageView *bottomIv;

@property (nonatomic,strong) CFFHomeLastWeightView *weightView;

@end

@implementation ZCCloudBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.smallIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self addSubview:self.smallIv];
    self.smallIv.alpha = 0.2;
    self.smallIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, 0, AUTO_MARGIN(70), AUTO_MARGIN(50));
    
    self.centerIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self addSubview:self.centerIv];
    self.centerIv.alpha = 0.2;
    self.centerIv.frame = CGRectMake(kCFF_SCREEN_WIDTH-AUTO_MARGIN(30), CGRectGetMaxY(self.smallIv.frame) + 70, AUTO_MARGIN(70)*1.2, AUTO_MARGIN(50)*1.2);
    
    self.bottomIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self addSubview:self.bottomIv];
    self.bottomIv.alpha = 0.2;
    self.bottomIv.frame = CGRectMake(AUTO_MARGIN(300), CGRectGetMaxY(self.centerIv.frame) + 30, AUTO_MARGIN(70) * 1.5, AUTO_MARGIN(50) * 1.5);
    
    CFFHomeLastWeightView *weightView = [[CFFHomeLastWeightView alloc] init];
    self.weightView = weightView;
    [self.weightView.weightL setFontBold:50];
    self.weightView.timeL.textAlignment = NSTextAlignmentRight;
    [self addSubview:weightView];
    [weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
        make.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    self.weightView.cloudBtn.hidden = YES;
    [self.weightView.changeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.weightView.mas_trailing).inset(AUTO_MARGIN(10));
        make.height.width.mas_equalTo(AUTO_MARGIN(40));
        make.centerY.mas_equalTo(self.weightView.cloudBtn.mas_centerY);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self timerOperate];
    });
}

- (void)timerOperate {
    [self setSmallIvAnimal];
    [self setCenterIvAnimal];
    [self setBottomIvAnimal];
}

- (void)setBottomIvAnimal {
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.bottomIv.dn_width;
    int alpha = arc4random() % 40 + 20;
    int animal = arc4random() % 10 + 10;
    [UIView animateWithDuration:animal animations:^{
        self.bottomIv.frame = CGRectMake(x, self.bottomIv.dn_y, self.bottomIv.dn_width*ratio, self.bottomIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        self.bottomIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, self.bottomIv.dn_y, AUTO_MARGIN(70)*1.5, AUTO_MARGIN(50)*1.5);
        [self setBottomIvAnimal];
    }];
    [UIView animateWithDuration:5 animations:^{
        self.bottomIv.alpha = alpha / 100.0;
    }];
}

- (void)setCenterIvAnimal {
    double ratio = (arc4random() % 130 + 20)/100.0;
    int x = -ratio * self.centerIv.dn_width;
    int alpha = arc4random() % 30 + 15;
    int animal = arc4random() % 10 + 18;
    [UIView animateWithDuration:animal animations:^{
        self.centerIv.frame = CGRectMake(x, self.centerIv.dn_y, self.centerIv.dn_width*ratio, self.centerIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        self.centerIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, self.centerIv.dn_y, AUTO_MARGIN(70)*1.2, AUTO_MARGIN(50)*1.2);
        [self setCenterIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.centerIv.alpha = alpha / 100.0;
    }];
}

- (void)setSmallIvAnimal{
    
    double ratio = (arc4random() % 130 + 20)/100.0;
    int alpha = arc4random() % 50 + 20;
    int x = -ratio * self.smallIv.dn_width;
    int animal = arc4random() % 10 + 18;
    [UIView animateWithDuration:animal animations:^{
        self.smallIv.frame = CGRectMake(x, self.smallIv.dn_y, self.smallIv.dn_width*ratio, self.smallIv.dn_height*ratio);
    } completion:^(BOOL finished) {
        self.smallIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, self.smallIv.dn_y, AUTO_MARGIN(70), AUTO_MARGIN(50));
        [self setSmallIvAnimal];
    }];
    [UIView animateWithDuration:kAnimalTime animations:^{
        self.smallIv.alpha = alpha / 100.0;
    }];
}
@end
