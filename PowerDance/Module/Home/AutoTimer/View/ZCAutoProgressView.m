//
//  ZCAutoProgressView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/18.
//


#import "ZCAutoProgressView.h"

#define KProgressPadding 0.0f
@interface ZCAutoProgressView ()

@property (nonatomic, weak) UIView *tView;
@property (nonatomic, weak) UIView *borderView;

@end

@implementation ZCAutoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //边框
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
        borderView.layer.masksToBounds = YES;
//        borderView.backgroundColor = [UIColor whiteColor];
//        borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
//        borderView.layer.borderWidth = 2.0f;
        self.borderView=borderView;
        [self addSubview:borderView];

        //进度
        UIView *tView = [[UIView alloc] init];
        tView.layer.cornerRadius = AUTO_MARGIN(5);
        tView.layer.masksToBounds = YES;        
        [self addSubview:tView];
        self.tView = tView;
    }

    return self;
}

-(void)setProgerssColor:(UIColor *)progerssColor{
    _progerssColor=progerssColor;
    _tView.backgroundColor=progerssColor;
}

-(void)setProgerStokeWidth:(CGFloat)progerStokeWidth{
    _progerStokeWidth=progerStokeWidth;
    _borderView.layer.borderWidth = progerStokeWidth;

}
-(void)setProgerssStokeBackgroundColor:(UIColor *)progerssStokeBackgroundColor{
    _progerssStokeBackgroundColor=progerssStokeBackgroundColor;
     _borderView.layer.borderColor = [progerssStokeBackgroundColor CGColor];
}
-(void)setProgerssBackgroundColor:(UIColor *)progerssBackgroundColor{
    _progerssBackgroundColor = progerssBackgroundColor;
    _borderView.backgroundColor=progerssBackgroundColor;
}

//更新进度
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;

    CGFloat margin = self.progerStokeWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width - margin * 2;
    CGFloat heigth = self.bounds.size.height - margin * 2;

    _tView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
}

@end
