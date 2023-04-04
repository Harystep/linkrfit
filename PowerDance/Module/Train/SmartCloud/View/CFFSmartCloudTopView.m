//
//  CFFSamrtCloudTopView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/30.
//

#import "CFFSmartCloudTopView.h"

#define kAnimalTime 10
#define kTimer 30

@interface CFFSmartCloudTopView ()

@property (nonatomic,strong) UIView *cloudView;

@property (nonatomic,strong) UIImageView *smallIv;

@property (nonatomic,strong) UIImageView *centerIv;

@property (nonatomic,strong) UIImageView *bottomIv;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UILabel *titleL;

@end

@implementation CFFSmartCloudTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.cloudView];
    UIImageView *cloudIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud")];
    [self.cloudView addSubview:cloudIv];
    [cloudIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.cloudView);
    }];
    
    self.smallIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self.cloudView addSubview:self.smallIv];
    self.smallIv.alpha = 0.2;
    self.smallIv.frame = CGRectMake(kCFF_SCREEN_WIDTH, 0, AUTO_MARGIN(70), AUTO_MARGIN(50));
    
    self.centerIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self.cloudView addSubview:self.centerIv];
    self.centerIv.alpha = 0.2;
    self.centerIv.frame = CGRectMake(kCFF_SCREEN_WIDTH-AUTO_MARGIN(30), CGRectGetMaxY(self.smallIv.frame) + 70, AUTO_MARGIN(70)*1.2, AUTO_MARGIN(50)*1.2);
    
    self.bottomIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_cloud_small")];
    [self.cloudView addSubview:self.bottomIv];
    self.bottomIv.alpha = 0.2;
    self.bottomIv.frame = CGRectMake(AUTO_MARGIN(300), CGRectGetMaxY(self.centerIv.frame) + 30, AUTO_MARGIN(70) * 1.5, AUTO_MARGIN(50) * 1.5);
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你好，请上秤", nil) font:14 bold:NO color:RGBA_COLOR(0, 0, 0, 0.5)];
    [cloudIv addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cloudIv.mas_top).offset(AUTO_MARGIN(50));
//        make.leading.mas_equalTo(cloudIv.mas_leading).offset(AUTO_MARGIN(72));
        make.centerX.mas_equalTo(cloudIv.mas_centerX);
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:@"0.0kg" font:44 bold:YES color:RGBA_COLOR(69, 161, 138, 1)];
    [cloudIv addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleL.mas_centerX);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(10));
    }];

    UIView *transView = [[UIView alloc] init];
    [cloudIv addSubview:transView];
    [transView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentL.mas_centerX);
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(AUTO_MARGIN(17));
        make.height.mas_equalTo(34);
    }];
    transView.backgroundColor = RGBA_COLOR(0, 0, 0, 1);
    transView.alpha = 0.39;
    [transView setViewCornerRadiu:17];
    
    self.transformL = [self createSimpleLabelWithTitle:@"00斤/00磅" font:14 bold:NO color:UIColor.whiteColor];
    self.transformL.textAlignment = NSTextAlignmentCenter;
    [transView addSubview:self.transformL];
    [self.transformL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(transView.mas_centerY);
        make.leading.trailing.mas_equalTo(transView).inset(AUTO_MARGIN(20));
//        make.centerX.mas_equalTo(self.contentL.mas_centerX);
//        make.top.mas_equalTo(self.contentL.mas_bottom).offset(AUTO_MARGIN(17));
//        make.width.mas_equalTo(AUTO_MARGIN(150));
//        make.height.mas_equalTo(34);
    }];
//    self.transformL.backgroundColor = RGBA_COLOR(0, 0, 0, 1);
//    self.transformL.alpha = 0.39;
//    [self.transformL setViewCornerRadiu:17];
    
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

- (UIView *)cloudView {
    if (!_cloudView) {
        _cloudView = [[UIView alloc] init];
        _cloudView.frame = CGRectMake(0, AUTO_MARGIN(100), kCFF_SCREEN_WIDTH, AUTO_MARGIN(300));
    }
    return _cloudView;
}
@end
