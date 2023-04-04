//
//  ZCTextEnterView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import "ZCTextEnterView.h"
#import "ZCSimpleTextView.h"

@interface ZCTextEnterView ()<UITextFieldDelegate>

@property (nonatomic,strong) ZCSimpleTextView *textView;

@end

@implementation ZCTextEnterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *picBtn = [[UIButton alloc] init];
    [self addSubview:picBtn];
    [picBtn setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [picBtn setImage:kIMAGE(@"shop_message_pic") forState:UIControlStateNormal];
    [picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(46));
        make.width.mas_equalTo(AUTO_MARGIN(70));
        make.top.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
//        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [picBtn addTarget:self action:@selector(picBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView = [[ZCSimpleTextView alloc] init];    
    [self addSubview:self.textView];
    self.textView.contentF.returnKeyType = UIReturnKeySend;
    [self.textView.bgView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    self.textView.contentF.placeholder = NSLocalizedString(@"输入您想咨询的问题", nil);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
        make.trailing.mas_equalTo(picBtn.mas_leading).inset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(46));
    }];
    self.textView.contentF.delegate = self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField);
    NSString *content = textField.text;
    if (content.length > 0) {
        [textField routerWithEventName:content];
        textField.text = @"";
        return YES;
    } else {
        return NO;
    }
}

- (void)picBtnOperate {
    [self routerWithEventName:@"" userInfo:@{}];
}

@end
