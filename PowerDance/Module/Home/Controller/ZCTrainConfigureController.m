//
//  ZCTrainConfigureController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/1.
//

#import "ZCTrainConfigureController.h"
#import "ZCTrainTopTimeView.h"
#import "ZCColorModel.h"
#import "ZCEquipmentModel.h"

@interface ZCTrainConfigureController ()<UITextViewDelegate>

@property (nonatomic,strong) ZCTrainTopTimeView *timeView;

@property (nonatomic,strong) NSDictionary *baseDic;

@property (nonatomic,strong) NSArray *equipmentArr;

@property (nonatomic,strong) ZCColorModel *colorModel;

@property (nonatomic,strong) UILabel *equipmentNumL;

@property (nonatomic,strong) UITextView *descView;
@property (nonatomic,strong) UITextField *nameF;
@property (nonatomic, strong) UILabel *placeL;

@end

@implementation ZCTrainConfigureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    self.equipmentArr = @[];
    ZCTrainTopTimeView *timeView = [[ZCTrainTopTimeView alloc] init];
    timeView.dataArr = self.baseDic[@"groupList"];
    [self.view addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(50));
    }];
      
    UIView *nameView = [[UIView alloc] init];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeView.mas_bottom).offset(AUTO_MARGIN(20));
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
    
    UIView *equipView = [[UIView alloc] init];
    [equipView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.view addSubview:equipView];
    [equipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descView.mas_bottom).offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];    
    
    [self createSubviewsOnTargetView:equipView title:NSLocalizedString(@"关联的运动器材", nil) index:0];
    
    UIButton *sureBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"设置完成，立即开始训练", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:sureBtn];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [sureBtn addTarget:self action:@selector(finishTrainOperate) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)finishTrainOperate {
 
    NSMutableArray *temArr = [NSMutableArray array];
    if (self.equipmentArr.count > 0) {
        for (ZCEquipmentModel *model in self.equipmentArr) {
            [temArr addObject:model.ID];
        }
    }
    
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionaryWithDictionary:self.baseDic];
    [baseDic setValue:@"" forKey:@"colour"];
    [baseDic setValue:@"" forKey:@"pattern"];
    [baseDic setValue:checkSafeContent(self.nameF.text) forKey:@"name"];
    [baseDic setValue:checkSafeContent(self.descView.text) forKey:@"briefDesc"];
    [baseDic setValue:temArr forKey:@"apparatusIds"];
    [ZCTrainManage createAutoTrainPlanOpereate:baseDic completeHandler:^(id  _Nonnull responseObj) {
        kProfileStore.recordTrainRefresh = YES;
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:responseObj[@"data"]];
        [temDic setValue:@"1" forKey:@"type"];
        [temDic setValue:temDic[@"trainId"] forKey:@"id"];
        [HCRouter router:@"TrainDetail" params:temDic viewController:self animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)createSubviewsOnTargetView:(UIView *)targetView title:(NSString *)title index:(NSInteger)index {
    UILabel *titleL = [targetView createSimpleLabelWithTitle:title font:14 bold:NO color:[ZCConfigColor txtColor]];
    [targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView);
        make.leading.mas_equalTo(targetView).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:kIMAGE(@"base_Black_arrow")];
    [targetView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(targetView);
        make.trailing.mas_equalTo(targetView).inset(AUTO_MARGIN(15));
    }];
    targetView.tag = index;
    
    if (index == 0) {
        self.equipmentNumL = [self.view createSimpleLabelWithTitle:@"" font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
        [targetView addSubview:self.equipmentNumL];
        [self.equipmentNumL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(targetView.mas_centerY);
            make.trailing.mas_equalTo(icon.mas_leading).inset(AUTO_MARGIN(5));
        }];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [targetView addGestureRecognizer:tap];
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    kweakself(self);
    switch (tap.view.tag) {
        case 0://器材
        {
            [HCRouter router:@"SelectEquipment" params:@{@"data":self.equipmentArr} viewController:self animated:YES block:^(id  _Nonnull value) {
                weakself.equipmentArr = value;
                weakself.equipmentNumL.text = [NSString stringWithFormat:@"%tu", weakself.equipmentArr.count];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"定制自己的训练", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.baseDic = self.params[@"data"];
}


@end
