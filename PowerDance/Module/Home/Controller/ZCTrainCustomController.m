//
//  ZCTrainCustomController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import "ZCTrainCustomController.h"
#import "ZCTrainTopTimeView.h"

@interface ZCTrainCustomController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *descView;
@property (nonatomic,strong) UITextField *nameF;
@property (nonatomic, strong) UILabel *placeL;

@end

@implementation ZCTrainCustomController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self configureBaseInfo];
    
    ZCTrainTopTimeView *timeView = [[ZCTrainTopTimeView alloc] init];
    [self.view addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(50));
    }];
    
    UIView *nameView = [[UIView alloc] init];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeView.mas_bottom).offset(AUTO_MARGIN(30));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
    [self configNameView:nameView];
    
    UIView *descView = [[UIView alloc] init];
    [self.view addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameView.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(162));
    }];
    [self configDescView:descView];
    
    UIButton *nextBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"下一步", nil) font:15 color:UIColor.whiteColor];
    nextBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [nextBtn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configDescView:(UIView *)descView {
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0.1;
    bgView.backgroundColor = rgba(173, 173, 173, 1);
    [descView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(descView);
    }];
    
    UITextView *tf = [[UITextView alloc] init];
    self.descView = tf;
    tf.backgroundColor = UIColor.clearColor;
    tf.font = FONT_SYSTEM(14);
    tf.delegate = self;
    tf.textColor = [ZCConfigColor txtColor];
    [descView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(descView).inset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(descView).inset(AUTO_MARGIN(15));
    }];
    
    self.placeL = [descView createSimpleLabelWithTitle:NSLocalizedString(@"添加描述（选写）", nil) font:14 bold:NO color:rgba(0, 0, 0, 0.25)];
    [tf addSubview:self.placeL];
    [self.placeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(tf.mas_leading).offset(AUTO_MARGIN(2));
        make.top.mas_equalTo(tf.mas_top).offset(AUTO_MARGIN(AUTO_MARGIN(8)));
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeL.hidden = NO;
    } else {
        self.placeL.hidden = YES;
    }
}

- (void)configNameView:(UIView *)nameView {
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0.1;
    bgView.backgroundColor = rgba(173, 173, 173, 1);
    [nameView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(nameView);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    self.nameF = tf;
    tf.font = FONT_SYSTEM(14);
    tf.textColor = [ZCConfigColor txtColor];
    tf.attributedPlaceholder = [tf attributedText:NSLocalizedString(@"给自己的训练计划起个名吧！", nil) color:rgba(0, 0, 0, 0.25) font:14];
    [nameView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(nameView);
        make.leading.trailing.mas_equalTo(nameView).inset(AUTO_MARGIN(15));
    }];
}

- (void)nextOperate {
    if (self.nameF.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写训练名称", nil) duration:2 position:CSToastPositionCenter];
        return;
    }
    [HCRouter router:@"TrainPlan" params:@{@"data":@{@"name":self.nameF.text, @"briefDesc":checkSafeContent(self.descView.text)}} viewController:self animated:YES];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"定制自己的训练", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
}

@end
