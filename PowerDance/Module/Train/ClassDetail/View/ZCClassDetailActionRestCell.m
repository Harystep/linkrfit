//
//  ZCClassDetailActionRestCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/15.
//

#import "ZCClassDetailActionRestCell.h"

@interface ZCClassDetailActionRestCell ()

@property (nonatomic,strong) UILabel *mouseL;

@property (nonatomic,strong) UIButton *delBtn;

@end

@implementation ZCClassDetailActionRestCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *content = [[UIView alloc] init];
    [self.contentView addSubview:content];
    content.backgroundColor = rgba(255, 255, 255, 0.85);
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [content setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"休息", nil) font:12 bold:NO color:[ZCConfigColor subTxtColor]];
    [content addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY).offset(-AUTO_MARGIN(15));
        make.centerX.mas_equalTo(content.mas_centerX);
    }];
    
    self.mouseL = [self createSimpleLabelWithTitle:@"10" font:13 bold:YES color:[ZCConfigColor txtColor]];
    [content addSubview:self.mouseL];
    [self.mouseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lb.mas_centerX);
        make.centerY.mas_equalTo(content.mas_centerY).offset(AUTO_MARGIN(15));
    }];
    
    self.delBtn = [[UIButton alloc] init];
    self.delBtn.hidden = YES;
    [content addSubview:self.delBtn];
    [self.delBtn setImage:kIMAGE(@"custom_rest_del") forState:UIControlStateNormal];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(content.mas_centerX);
        make.bottom.mas_equalTo(content.mas_bottom).inset(AUTO_MARGIN(10));
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
    }];
    [self.delBtn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.mouseL.text = [NSString stringWithFormat:@"%@\"", checkSafeContent(dataDic[@"duration"])];
}

- (void)setSignDeleteFlag:(NSInteger)signDeleteFlag {
    _signDeleteFlag = signDeleteFlag;
    self.delBtn.hidden = NO;    
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)deleteOperate {
    NSLog(@"delete·rest ---->%tu", self.index);
    [self routerWithEventName:@"delete" userInfo:@{@"index":@(self.index)}];
}

@end
