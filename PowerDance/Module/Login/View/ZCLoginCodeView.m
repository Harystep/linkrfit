//
//  CFFLoginCodeView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/6.
//

#import "ZCLoginCodeView.h"

@interface ZCLoginCodeView ()

@property (nonatomic,strong) UILabel *preL;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *fieldView;

@property (nonatomic,strong) UIButton *mouseBtn;

@property (nonatomic,assign) NSInteger index;

@end

@implementation ZCLoginCodeView

#pragma mark : init

- (instancetype) init {
    self = [super init];
    if (self) {
        self.index = 60;
        [self createSubViews];
        [self makeConstraints];
    }
    return self;;
}

- (void)createSubViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.mouseBtn];
    [self.contentView addSubview:self.fieldView];
    [self.fieldView addSubview:self.txtInput];
    
    @weakify(self);
    [[self.txtInput rac_signalForControlEvents:UIControlEventAllEditingEvents] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        UITextField *txt = (UITextField *)x;
        self.text = txt.text;
    }];
}

- (void)mouseOperate {
    self.index --;
    if (self.index == 0) {
        self.index = 60;
        self.mouseBtn.backgroundColor = [ZCConfigColor txtColor];
        [self.mouseBtn setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
        [self.mouseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.mouseBtn.userInteractionEnabled = YES;
        [self fireTimer];
    } else {
        self.mouseBtn.userInteractionEnabled = NO;
        self.mouseBtn.backgroundColor = RGBA_COLOR(244, 244, 244, 1);
        [self.mouseBtn setTitleColor:rgba(43, 42, 51, 0.5) forState:UIControlStateNormal];
        [self.mouseBtn setTitle:[NSString stringWithFormat:@"%zds", self.index] forState:UIControlStateNormal];
    }
}

#pragma mark : funcs

- (void) makeConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(56);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.mouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(90);
    }];
        
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.mouseBtn.mas_leading).inset(15);
    }];
    
    [self.txtInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.fieldView);
        make.leading.trailing.mas_equalTo(self.fieldView).inset(AUTO_MARGIN(13));
    }];
    
}

//- (BOOL)becomeFirstResponder {
//    return [self.txtInput becomeFirstResponder];
//}
//
//- (BOOL)resignFirstResponder {
//    [super resignFirstResponder];
//    return [self.txtInput resignFirstResponder];
//}


- (void)mouseBtnRefresh {
    if (self.clickSendCodeOperate) {
        self.clickSendCodeOperate();
    }    
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(mouseOperate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)textInputEditStatus {
    if (self.errorStatus) {
        self.errorStatus = 0;
        self.txtInput.textColor = [UIColor whiteColor];
    }
}

- (void)setErrorStatus:(NSInteger)errorStatus {
    _errorStatus = errorStatus;
    self.txtInput.textColor = UIColor.whiteColor;
}

#pragma mark : lazy laod
- (UITextField *)txtInput {
    if (!_txtInput) {
        _txtInput = [[UITextField alloc] init];
        _txtInput.textColor = [UIColor blackColor];
        _txtInput.font = FONT_SYSTEM(16);
        _txtInput.backgroundColor = RGBA_COLOR(244, 244, 244, 1);
        _txtInput.placeholder = NSLocalizedString(@"验证码", nil);
        _txtInput.textAlignment = NSTextAlignmentLeft;
        _txtInput.keyboardType = UIKeyboardTypeNumberPad;
        [_txtInput addTarget:self action:@selector(textInputEditStatus) forControlEvents:UIControlEventEditingChanged];
    }
    return _txtInput;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)fieldView {
    if (!_fieldView) {
        _fieldView = [[UIView alloc] init];
        _fieldView.backgroundColor = RGBA_COLOR(244, 244, 244, 1);
    }
    return _fieldView;
}

- (UIButton *)mouseBtn {
    if (!_mouseBtn) {
        _mouseBtn = [[UIButton alloc] init];
        _mouseBtn.backgroundColor = [ZCConfigColor txtColor];
        _mouseBtn.titleLabel.font = FONT_SYSTEM(15);
        [_mouseBtn setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
        [_mouseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mouseBtn addTarget:self action:@selector(mouseBtnRefresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mouseBtn;
}

- (void)fireTimer {
    [self.timer invalidate];
    self.timer = nil;
}

@end
