//
//  CFFLoginAlertView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/6.
//

#import "ZCLoginAlertView.h"

@interface ZCLoginAlertView ()

@end

@implementation ZCLoginAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA_COLOR(0, 0, 0, 0.7);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.alertL = [[UILabel alloc] init];
    self.alertL.textColor = UIColor.whiteColor;
    self.alertL.font = FONT_SYSTEM(12);
    self.alertL.text = NSLocalizedString(@"手机号错误", nil);
    self.alertL.textAlignment = NSTextAlignmentCenter;
    [self.alertL setContentLineFeedStyle];
    [self addSubview:self.alertL];
    [self.alertL mas_makeConstraints:^(MASConstraintMaker *make) {        
        make.leading.trailing.mas_equalTo(self).inset(25);
        make.height.mas_equalTo(44);
        make.top.bottom.mas_equalTo(self);
    }];
        
    self.layer.cornerRadius = 22;
    self.layer.masksToBounds = YES;
}

- (CGSize)compareContentSize:(NSString *)title withFont:(CGFloat)font widthLimited:(CGFloat)limitWidth {
    UIFont *fnt = [UIFont systemFontOfSize:font];
    CGSize postJobSize = [title boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil].size;
    return postJobSize;
}

- (void)setText:(NSString *)text {
    _text = text;
    CGFloat maxWidth = SCREEN_W - AUTO_MARGIN(80);
    CGSize size = [self compareContentSize:checkSafeContent(text) withFont:12 widthLimited:maxWidth];
    if (size.height > 20) {
        [self.alertL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AUTO_MARGIN(20)+maxWidth);
            make.height.mas_equalTo(44);
            make.top.bottom.mas_equalTo(self);
        }];
    }
    
    self.alertL.text = checkSafeContent(text);
}

@end
