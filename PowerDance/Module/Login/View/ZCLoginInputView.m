//
//  CFFLoginInputView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import "ZCLoginInputView.h"


@interface ZCLoginInputView()


//@property (nonatomic,strong) UIView *bgError;

@property (nonatomic,strong) UILabel *preL;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UIView *contentView;

@end

@implementation ZCLoginInputView

#pragma mark : init

- (instancetype) init {
    self = [super init];
    if (self) {
        
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.txtInput];
        [self makeConstraints];
        @weakify(self);        
        [[self.txtInput rac_signalForControlEvents:UIControlEventAllEditingEvents] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            UITextField *txt = (UITextField *)x;
            txt.textColor = [UIColor blackColor];
            self.text = txt.text;
        }];
    }
    return self;;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.txtInput.text = text;
}

#pragma mark : funcs

- (void) makeConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(56);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.txtInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.leading.trailing.equalTo(self.contentView).inset(AUTO_MARGIN(13));
    }];
 
}

- (void)cleanMsg {
    [self showMsg:@" "];
}

- (BOOL)becomeFirstResponder {
    return [self.txtInput becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.txtInput resignFirstResponder];
}

- (void)textInputEditStatus {
    if (self.errorStatus) {
        self.errorStatus = 0;
        self.txtInput.textColor = [UIColor blackColor];
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
        _txtInput.keyboardType = UIKeyboardTypeNumberPad;
        _txtInput.placeholder = NSLocalizedString(@"手机号", nil);
        [_txtInput addTarget:self action:@selector(textInputEditStatus) forControlEvents:UIControlEventEditingChanged];
    }
    return _txtInput;
}

- (UILabel *)preL {
    if (!_preL) {
        _preL = [[UILabel alloc] init];
        _preL.textColor = RGBA_COLOR(0, 0, 0, 0.5);
        _preL.text = @"+86";
        _preL.font = FONT_SYSTEM(16);
    }
    return _preL;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBA_COLOR(244, 244, 244, 1);
    }
    return _contentView;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.25);
        
    }
    return _sepView;
}

@end
