//
//  ZCSimpleNoneView.m
//  BrandGogo
//
//  Created by PC-N121 on 2022/6/10.
//

#import "ZCSimpleNoneView.h"

@interface ZCSimpleNoneView ()

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIButton *postBtn;

@end

@implementation ZCSimpleNoneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.hidden = YES;
//    self.userInteractionEnabled = NO;
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"base_none_data")];
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"暂无数据", nil) font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:self.titleL];
    [self.titleL setContentLineFeedStyle];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleL.text = titleStr;
}

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    self.iconIv.image = kIMAGE(imageStr);
}

- (void)configureViewColors:(UIView *)view {
    UIColor *colorOne = rgba(247, 56, 91, 1);
    UIColor *colorTwo = rgba(255, 113, 110, 1);
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(-0.03, 0);
    gradient.endPoint = CGPointMake(1, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, self.postBtn.width, AUTO_MARGIN(44));
    gradient.cornerRadius = AUTO_MARGIN(22);
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)setupViewColors:(UIView *)view {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = view.frame;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:56/255.0 blue:91/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:113/255.0 blue:110/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    view.layer.cornerRadius = 22;
    view.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:82/255.0 blue:82/255.0 alpha:0.5].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 21;
}

-(void)setShowBtnStatus:(NSInteger)showBtnStatus {
    if (showBtnStatus) {
        self.postBtn.hidden = YES;
    } else {
        self.postBtn.hidden = NO;
    }
}

@end
