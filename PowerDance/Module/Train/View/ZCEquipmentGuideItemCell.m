//
//  ZCEquipmentGuideItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import "ZCEquipmentGuideItemCell.h"

@interface ZCEquipmentGuideItemCell ()

@property (nonatomic,strong) UIButton *contentBtn;

@end

@implementation ZCEquipmentGuideItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self configureMuscleTargetView:self.contentView];
    [self.contentView setViewCornerRadiu:5];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.contentBtn setTitle:checkSafeContent(dataDic[@"name"]) forState:UIControlStateNormal];
    if ([self.selectArr containsObject:checkSafeContent(dataDic[@"id"])]) {
        [self setupTargetViewStatus:self.contentView status:YES];
    } else {
        [self setupTargetViewStatus:self.contentView status:NO];
    }
}

- (void)configureMuscleTargetView:(UIView *)targetView {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [targetView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(targetView).inset(1);
        make.top.bottom.mas_equalTo(targetView).inset(1);
    }];
    [bgView layoutIfNeeded];
    [bgView configureLeftToRightViewColorGradient:bgView width:105 height:43 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:5];
    bgView.hidden = YES;
    
    self.contentBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@" ", nil) font:13 color:[ZCConfigColor txtColor]];
    [targetView addSubview:self.contentBtn];
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(targetView);
    }];
    self.contentBtn.titleLabel.font = FONT_BOLD(13);
    self.contentBtn.userInteractionEnabled = NO;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTargetType:)];
//    [targetView addGestureRecognizer:tap];
    
}

//- (void)selectTargetType:(UITapGestureRecognizer *)tap {
//    UIView *view = tap.view;
//    [self setupTargetViewStatus:view status:YES];
//    [self routerWithEventName:@"selectEquipment" userInfo:@{@"id":checkSafeContent(self.dataDic[@"id"])}];
//}

- (void)setupTargetViewStatus:(UIView *)view status:(BOOL)status {
    if (status) {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor whiteColor] forState:UIControlStateNormal];
            }
            
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = NO;
            }
        }
        [view setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
    } else {
        for (UIView *item in view.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)item;
                [btn setTitleColor:[ZCConfigColor txtColor] forState:UIControlStateNormal];
            }
            if ([item isKindOfClass:[UIImageView class]]) {
                item.hidden = YES;
            }
        }
        [view setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    }
}

@end
