//
//  ZCCustomCourseEditView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/13.
//

#import "ZCCustomCourseEditView.h"

@interface ZCCustomCourseEditView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@end

@implementation ZCCustomCourseEditView

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self addSubview:self.maskBtn];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    self.contentView = contentView;
    [self addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(206));
        make.bottom.leading.trailing.mas_equalTo(self);
    }];
        
    
    UIButton *editBtn = [self createShadowButtonWithTitle:NSLocalizedString(@"重新编辑此课程", nil) font:14 color:[ZCConfigColor txtColor]];
    [contentView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(25));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
    }];
    editBtn.backgroundColor = rgba(246, 246, 246, 1);
    [editBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    editBtn.tag = 0;
    [editBtn addTarget:self action:@selector(operateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [self createShadowButtonWithTitle:NSLocalizedString(@"删除此课程", nil) font:14 color:rgba(255, 75, 75, 1)];
    [contentView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(editBtn.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
    }];
    deleteBtn.backgroundColor = rgba(246, 246, 246, 1);
    [deleteBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    deleteBtn.tag = 1;
    [deleteBtn addTarget:self action:@selector(operateClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)operateClick:(UIButton *)sender {
    if (self.sureEditOperate) {
        [self hideAlertView];
        self.sureEditOperate([NSString stringWithFormat:@"%tu", sender.tag]);
    }
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [self.superViewController.view addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)sureOperate {
    [ZCDataTool saveCustomTrainGuideSign:1];
    [self hideAlertView];
}

- (void)maskBtnClick {
    [self hideAlertView];
}

@end
