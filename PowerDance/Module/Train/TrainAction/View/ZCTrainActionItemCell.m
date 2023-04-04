//
//  ZCTrainActionItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/16.
//

#import "ZCTrainActionItemCell.h"

@interface ZCTrainActionItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIButton *delBtn;

@end

@implementation ZCTrainActionItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] init];
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    self.iconIv.image = kIMAGE(@"train_class");
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(10)];
    [self.iconIv setViewColorAlpha:0.59 color:UIColor.blackColor];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"腿抬高", nil) font:13 bold:YES color:[ZCConfigColor whiteColor]];
    [self.iconIv addSubview:self.nameL];
    [self.nameL setContentLineFeedStyle];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.iconIv).inset(AUTO_MARGIN(14));
        make.top.mas_equalTo(self.iconIv.mas_top).offset(AUTO_MARGIN(14));
    }];
        
    self.delBtn = [[UIButton alloc] init];
    self.delBtn.hidden = YES;
    [self.contentView addSubview:self.delBtn];
    [self.delBtn setImage:kIMAGE(@"custom_action_del") forState:UIControlStateNormal];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(10));
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
    }];
    [self.delBtn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSignDeleteFlag:(NSInteger)signDeleteFlag {
    _signDeleteFlag = signDeleteFlag;
    self.delBtn.hidden = NO;
}

- (void)deleteOperate {
    [self routerWithEventName:@"delete" userInfo:@{@"index":@(self.index)}];
}

- (void)setupViewColors:(UIView *)view frame:(CGRect)rect {
    UIColor *colorOne = [UIColor colorWithRed:0/255.0 green:21/255.0 blue:59/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:39/255.0 green:55/255.0 blue:93/255.0 alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0.5, 1);
    gradient.endPoint = CGPointMake(0.5, 0);
    gradient.colors = colors;
    gradient.frame = rect;
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(dataDic[@"title"]);
}

- (void)setActionDic:(NSDictionary *)actionDic {
    _actionDic = actionDic;    
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(actionDic[@"cover"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(actionDic[@"name"]);
}



@end
