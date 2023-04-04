//
//  ZCShopTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import "ZCShopTopView.h"

@interface ZCShopTopView ()

@property (nonatomic,strong) NSMutableArray *favViewArr;//猜你喜欢

@property (nonatomic,strong) NSMutableArray *nowViewArr;//最近上新

@end

@implementation ZCShopTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *leftView = [[UIView alloc] init];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AUTO_MARGIN(8));
        make.leading.mas_equalTo(self).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(75));
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AUTO_MARGIN(8));
        make.trailing.mas_equalTo(self).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(75));
        make.leading.mas_equalTo(leftView.mas_trailing).offset(AUTO_MARGIN(10));
        make.width.mas_equalTo(leftView.mas_width);
    }];
    
    [self configureLeftViewSubviews:leftView];
    
    [self configureRighttViewSubviews:rightView];
    
}

#pragma -- mark 猜你喜欢
- (void)configureLeftViewSubviews:(UIView *)view {
    self.favViewArr = [NSMutableArray array];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_top_left")];
    [view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"猜你喜欢", nil) font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor txtColor]];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    [self addConfigureSubViews:view type:0];
}

#pragma -- mark 最近上新
- (void)configureRighttViewSubviews:(UIView *)view {
    self.nowViewArr = [NSMutableArray array];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_top_right")];
    [view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"最近上新", nil) font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor txtColor]];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AUTO_MARGIN(10));
        make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    [self addConfigureSubViews:view type:1];
    
}

- (void)addConfigureSubViews:(UIView *)view type:(NSInteger)type {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(10) - AUTO_MARGIN(10) - AUTO_MARGIN(10))/2.0;
    CGFloat marginX = (width - AUTO_MARGIN(35) - AUTO_MARGIN(35))/3.0;
    for (int i = 0; i < 2; i ++) {
        UIImageView *iconIv = [[UIImageView alloc] init];
        [view addSubview:iconIv];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(AUTO_MARGIN(35));
            make.leading.mas_equalTo(view.mas_leading).offset(marginX+(marginX+AUTO_MARGIN(35))*i);
            make.bottom.mas_equalTo(view.mas_bottom).inset(10);
        }];
        [iconIv setViewCornerRadiu:AUTO_MARGIN(5)];
        iconIv.tag = i;
        iconIv.userInteractionEnabled = YES;
        if (type == 1) {//最近上新
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconNowClick:)];
            [iconIv addGestureRecognizer:tap];
            [self.nowViewArr addObject:iconIv];
        } else {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconFavClick:)];
            [iconIv addGestureRecognizer:tap];
            [self.favViewArr addObject:iconIv];
        }
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.favDataArr = dataDic[@"likeList"];
    
    self.nowDataArr = dataDic[@"newestList"];
    
}

- (void)setFavDataArr:(NSArray *)favDataArr {
    _favDataArr = favDataArr;
    NSInteger count = favDataArr.count > 1 ? 2:favDataArr.count;
    for (int i = 0; i < count; i ++) {
        UIImageView *icon = self.favViewArr[i];
        NSDictionary *dic = favDataArr[i];
        [icon sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dic[@"imgUrl"])] placeholderImage:nil];
    }
}

- (void)setNowDataArr:(NSArray *)nowDataArr {
    _nowDataArr = nowDataArr;
    NSInteger count = nowDataArr.count > 1 ? 2:nowDataArr.count;
    for (int i = 0; i < count; i ++) {
        UIImageView *icon = self.nowViewArr[i];
        NSDictionary *dic = nowDataArr[i];
        [icon sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dic[@"imgUrl"])] placeholderImage:nil];
    }
}

#pragma -- mark 点击猜我喜欢
- (void)iconFavClick:(UITapGestureRecognizer *)tap {
    NSDictionary *dic = self.favDataArr[tap.view.tag];
    [HCRouter router:@"GoodsDetail" params:@{@"data":checkSafeContent(dic[@"id"])} viewController:self.superViewController animated:YES];
}

#pragma -- mark 点击最近上新
- (void)iconNowClick:(UITapGestureRecognizer *)tap {
    NSDictionary *dic = self.nowDataArr[tap.view.tag];
    [HCRouter router:@"GoodsDetail" params:@{@"data":checkSafeContent(dic[@"id"])} viewController:self.superViewController animated:YES];
}

@end
