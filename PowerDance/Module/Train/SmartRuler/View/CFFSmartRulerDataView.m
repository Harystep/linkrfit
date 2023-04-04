//
//  CFFSmartRulerDataView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/13.
//

#import "CFFSmartRulerDataView.h"

@interface CFFSmartRulerDataView ()
//32 14 14
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) UIButton *saveBtn;

@end

@implementation CFFSmartRulerDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [contentView setViewCornerRadius:15];
    contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(160));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    self.nameL = [self createLabelWithTitle:NSLocalizedString(@"--", nil) color:kCFF_COLOR_CONTENT_TITLE font:32 bold:YES];
    self.dataL = [self createLabelWithTitle:NSLocalizedString(@"0.0  ", nil) color:kCFF_COLOR_CONTENT_TITLE font:32 bold:YES];
    self.titleL = [self createLabelWithTitle:NSLocalizedString(@"请拉动腰围尺", nil) color:kCFF_COLOR_CONTENT_TITLE font:AUTO_MARGIN(14) bold:NO];
//    self.statusL = [self createLabelWithTitle:NSLocalizedString(@"数据同步中··", nil) color:kCFF_BG_COLOR_GREEN_COMMON font:AUTO_MARGIN(13) bold:NO];
    [self setRulerDataStyle:self.dataL.text];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(35));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
    }];
    
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(self.nameL.mas_centerY);
    }];
    
    [self.dataL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameL.mas_leading);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    self.saveBtn = [[UIButton alloc] init];
    [self.saveBtn setTitle:NSLocalizedString(@"记录", nil) forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = FONT_SYSTEM(14);
    [self.contentView addSubview:self.saveBtn];
    self.saveBtn.backgroundColor = kCFF_COLOR_SUB_TITLE;
    self.saveBtn.enabled = NO;
    [self.saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveOperate) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dataL.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(AUTO_MARGIN(95));
        make.height.mas_equalTo(40);
    }];
    [self.saveBtn setViewCornerRadius:20];
}

- (void)setRulerData:(NSString *)rulerData {
    _rulerData = rulerData;
    [self setRulerDataStyle:rulerData];
}

- (void)saveOperate {
    if (self.btnClickSaveBlock) {
        if (self.dataL.text.length > 2) {
            self.btnClickSaveBlock([self.dataL.text substringWithRange:NSMakeRange(0, self.dataL.text.length - 2)]);
            [self setRulerDataStyle:[NSString stringWithFormat:@"0.0%@", self.unit]];
        }
    }
}

- (void)setRulerDataStyle:(NSString *)content {
    if (content.length > 2) {        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:32] range:NSMakeRange(0, content.length-2)];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(content.length-2, 2)];
        self.dataL.attributedText = attr;
        self.unit = [content substringWithRange:NSMakeRange(content.length-2, 2)];
        
        NSString *data = [content substringWithRange:NSMakeRange(0, content.length-2)];
        if ([data doubleValue] > 0.0) {
            self.saveBtn.enabled = YES;
            self.saveBtn.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
        } else {
            self.saveBtn.enabled = NO;
            self.saveBtn.backgroundColor = kCFF_COLOR_SUB_TITLE;
        }
    }

}

- (UILabel *)createLabelWithTitle:(NSString *)title color:(UIColor *)color font:(CGFloat)font bold:(BOOL)flag {
    UILabel *lb = [[UILabel alloc] init];
    [self.contentView addSubview:lb];
    lb.textColor = color;
    if (flag) {
        lb.font = FONT_BOLD(font);
    } else {
        lb.font = FONT_SYSTEM(font);
    }
    lb.text = title;
    return lb;
}

@end
