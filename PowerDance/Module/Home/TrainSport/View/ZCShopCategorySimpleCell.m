//
//  ZCShopCategorySimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/5.
//

#import "ZCShopCategorySimpleCell.h"

@interface ZCShopCategorySimpleCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *descL;

@end

@implementation ZCShopCategorySimpleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"shop_simple")];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(AUTO_MARGIN(90));
        make.top.mas_equalTo(self.contentView).offset(AUTO_MARGIN(25));
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"智能腰围尺", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(28));
    }];
    
    self.descL = [self createSimpleLabelWithTitle:NSLocalizedString(@"快速测量腰围", nil) font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    self.descL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(8));
    }];
}

@end
