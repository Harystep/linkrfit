//
//  ZCSuitSelectDeviceView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitSelectDeviceView.h"

@interface ZCSuitSelectDeviceView ()

@property (nonatomic,strong) UIView *selectItemView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *itemView;

@property (nonatomic,strong) NSMutableArray *labelArr;//保存title视图

@property (nonatomic,assign) NSInteger selectIndex;//当前索引


@end

@implementation ZCSuitSelectDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    self.contentView = topView;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    _dataArr = @[
        @{@"title":NSLocalizedString(@"健腹轮", nil), @"image":kIMAGE(@"family_suit_jfl")},
        @{@"title":NSLocalizedString(@"跳绳", nil), @"image":kIMAGE(@"family_suit_jump")},
        @{@"title":NSLocalizedString(@"拉力器", nil), @"image":kIMAGE(@"family_suit_llq")}
    ];
    self.itemArr = [NSMutableArray arrayWithArray:_dataArr];
    self.labelArr = [NSMutableArray array];
    self.viewArr = [NSMutableArray array];
    [self setupSubviews:self.contentView index:0];
}

- (void)resetStatusView:(NSInteger)index {

    CGFloat marginX = AUTO_MARGIN(28);
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(56)) / 3.0;
    UIView *clickView = self.viewArr[index];
    UIView *firstView = self.viewArr[0];
    if (index == 2) {
        UIView *midView = self.viewArr[1];
        [self setNeedsUpdateConstraints:midView offset:(marginX+width)*2];
    }
    [self setNeedsUpdateConstraints:clickView offset:0];
    [self setNeedsUpdateConstraints:firstView offset:(marginX+width)];
    [self.viewArr removeObjectAtIndex:index];
    [self.viewArr insertObject:clickView atIndex:0];
}

- (void)setNeedsUpdateConstraints:(UIView *)targetView offset:(CGFloat)offset {
    [self setNeedsUpdateConstraints];
//    [targetView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [targetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(offset);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)setupSubviews:(UIView *)topView index:(NSInteger)index {
    CGFloat marginX = AUTO_MARGIN(28);
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(56)) / 3.0;
    for (int i = 0; i < 3; i ++) {
        self.itemView = [[UIView alloc] init];
        [topView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.leading.mas_equalTo((width+marginX)*i);
            make.top.mas_equalTo(topView.mas_top);
            make.bottom.mas_equalTo(topView);
        }];
        self.itemView.tag = i;
        [self.viewArr addObject:self.itemView];
        NSDictionary *dic = self.itemArr[i];
        UIView *itemView = [[UIView alloc] init];
        [self.itemView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(width);
            make.leading.trailing.top.mas_equalTo(self.itemView);
        }];
        [itemView setViewCornerRadiu:AUTO_MARGIN(10)];
        itemView.backgroundColor = [ZCConfigColor bgColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [itemView addGestureRecognizer:tap];
        
        UIImageView *iconIv = [[UIImageView alloc] init];
        [itemView addSubview:iconIv];
        iconIv.image = dic[@"image"];
        iconIv.contentMode = UIViewContentModeScaleAspectFit;
        iconIv.clipsToBounds = YES;
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.mas_equalTo(itemView).inset(AUTO_MARGIN(5));
        }];
        
        UIButton *lineView = [[UIButton alloc] init];
        [itemView addSubview:lineView];
        lineView.backgroundColor = rgba(250, 100, 0, 1);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(itemView);
            make.height.mas_equalTo(AUTO_MARGIN(3));
        }];
        
        UILabel *lb = [self createSimpleLabelWithTitle:dic[@"title"] font:AUTO_MARGIN(12) bold:YES color:[ZCConfigColor txtColor]];
        [self.itemView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconIv.mas_centerX);
            make.top.mas_equalTo(itemView.mas_bottom).offset(AUTO_MARGIN(10));
            make.bottom.mas_equalTo(self.itemView.mas_bottom);
        }];
        [self.labelArr addObject:lb];
        itemView.tag = i;
        
        if (i == index) {
            [self configureItemViewSelectStatus:YES view:itemView];
            self.selectItemView = itemView;
            self.selectIndex = i;
        } else {
            [self configureItemViewSelectStatus:NO view:itemView];
            lb.textColor = [ZCConfigColor subTxtColor];
        }
    }
}

- (void)configureItemViewSelectStatus:(BOOL)status view:(UIView *)itemView {
    UIImageView *iconIv = [self convertImageViewWithItemView:itemView];
    UILabel *lb = self.labelArr[itemView.tag];
    UIButton *line = [self convertLineViewWithItemView:itemView];
    if (status) {
        iconIv.alpha = 1.0;
        lb.textColor = [ZCConfigColor txtColor];
        line.hidden = NO;
    } else {
        iconIv.alpha = 0.3;
        lb.textColor = [ZCConfigColor subTxtColor];
        line.hidden = YES;
    }
}

- (UIImageView *)convertImageViewWithItemView:(UIView *)itemView {
    UIImageView *imageIv;
    if (itemView != nil) {
        for (UIView *item in itemView.subviews) {
            if ([item isKindOfClass:[UIImageView class]]) {
                imageIv = (UIImageView *)item;
                break;
            }
        }
    }
    return imageIv;
}

- (UIButton *)convertLineViewWithItemView:(UIView *)itemView {
    UIButton *btn;
    if (itemView != nil) {
        for (UIView *item in itemView.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                btn = (UIButton *)item;
                break;
            }
        }
    }
    return btn;
}

- (UILabel *)convertLabelViewWithItemView:(UIView *)itemView {
    UILabel *lb;
    if (itemView != nil) {
        for (UIView *item in itemView.subviews) {
            if ([item isKindOfClass:[UILabel class]]) {
                lb = (UILabel *)item;
                break;
            }
        }
    }
    return lb;
}

- (void)viewClick:(UITapGestureRecognizer *)tap {
    UIView *itemView = tap.view;
    if (self.selectItemView == itemView)return;
    self.selectIndex = itemView.tag;
    [self configureItemViewSelectStatus:NO view:self.selectItemView];
    [self configureItemViewSelectStatus:YES view:itemView];
    self.selectItemView = itemView;
    
    [self routerWithEventName:@"brind" userInfo:self.itemArr[self.selectIndex]];
}

@end
