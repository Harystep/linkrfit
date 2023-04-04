//
//  ZCTrainClassCardItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/11.
//

#import "ZCTrainClassCardItemCell.h"

@interface ZCTrainClassCardItemCell ()

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) CAGradientLayer *gradient;

@end

@implementation ZCTrainClassCardItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_class")];
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.iconIv setViewCornerRadiu:10];
    [self.iconIv setViewColorAlpha:0.59 color:UIColor.blackColor];
    
    self.titleL = [self createSimpleLabelWithTitle:@" " font:12 bold:YES color:[ZCConfigColor whiteColor]];
    [self.titleL setContentLineFeedStyle];
    [self.iconIv addSubview:self.titleL];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv.mas_centerX);
        make.bottom.mas_equalTo(self.iconIv.mas_bottom).inset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(self.iconIv.mas_leading).offset(AUTO_MARGIN(10));
    }];
//    [self setupViewColors:self.iconIv frame:CGRectMake(0, 0, AUTO_MARGIN(100), AUTO_MARGIN(146))];
}

- (void)setupViewColors:(UIView *)view frame:(CGRect)rect {
    UIColor *colorOne = [UIColor colorWithRed:0/255.0 green:21/255.0 blue:59/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:39/255.0 green:55/255.0 blue:93/255.0 alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    self.gradient = gradient;
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0.5, 1);
    gradient.endPoint = CGPointMake(0.5, 0);
    gradient.colors = colors;
    gradient.frame = rect;
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)setPostStyle:(PostStyle)postStyle {
    _postStyle = postStyle;
    if (postStyle == PostStyleCenter) {
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.iconIv).inset(AUTO_MARGIN(10));
            make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        }];
    } else if (postStyle == PostStyleTop) {
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.iconIv).inset(AUTO_MARGIN(14));
            make.top.mas_equalTo(self.iconIv.mas_top).offset(AUTO_MARGIN(14));
        }];
        self.titleL.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if ([dataDic[@"noneData"] integerValue] == 1) {
        self.titleL.text = NSLocalizedString(@"精选课程", nil);
        self.gradient.hidden = YES;
        self.iconIv.image = kIMAGE(@"train_class");
    } else {
        self.gradient.hidden = NO;
        NSString *content = checkSafeContent(dataDic[@"title"]);
        content = content.length > 0?content:checkSafeContent(dataDic[@"name"]);
        self.titleL.text = content;
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    }
}

@end
