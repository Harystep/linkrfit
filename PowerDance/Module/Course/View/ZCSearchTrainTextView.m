//
//  ZCSearchTrainTextView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import "ZCSearchTrainTextView.h"

@interface ZCSearchTrainTextView ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *tf;

@end

@implementation ZCSearchTrainTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *searchView = [[UIView alloc] init];
    self.searchView = searchView;
    [self addSubview:searchView];
//    [searchView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.top.mas_equalTo(self);
    }];
    [self createSearchViewSubViews:searchView];
}

- (void)createSearchViewSubViews:(UIView *)searchView {
    UITextField *tf = [[UITextField alloc] init];
    self.tf = tf;
    [searchView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(searchView.mas_leading).offset(AUTO_MARGIN(12));
        make.top.bottom.mas_equalTo(searchView);
        make.trailing.mas_equalTo(searchView.mas_trailing).inset(AUTO_MARGIN(50));
    }];
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeySearch;
    tf.font = FONT_SYSTEM(15);
    tf.placeholder = NSLocalizedString(@"搜索训练", nil);
    
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_search_icon")];
    [searchView addSubview:searchIv];
    searchIv.contentMode = UIViewContentModeCenter;
    [searchIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.height.width.mas_equalTo(AUTO_MARGIN(44));
        make.trailing.mas_equalTo(searchView.mas_trailing);
    }];
    searchIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchOperate)];
    [searchIv addGestureRecognizer:tap];
}

- (void)searchOperate {
    if (self.tf.text == 0) {
        return;
    }
    [self endEditing:YES];
    if (self.searchTrainResult) {
        self.searchTrainResult(self.tf.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.tf.text == 0) {
        return NO;
    }
    [self endEditing:YES];
    if (self.searchTrainResult) {
        self.searchTrainResult(self.tf.text);
    }
    
    return YES;
}

- (void)setEditFlag:(NSInteger)editFlag {
    _editFlag = editFlag;
    self.tf.userInteractionEnabled = NO;
}

@end
