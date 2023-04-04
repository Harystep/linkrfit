//
//  ZCCustomActionConfigureController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import "ZCCustomActionConfigureController.h"
#import "ZCTrainTopTimeView.h"
#import "ZCColorModel.h"
#import "ZCEquipmentModel.h"
#import "ZCAutoActionTrainTimeView.h"

@interface ZCCustomActionConfigureController ()

@property (nonatomic,strong) ZCTrainTopTimeView *timeView;

@property (nonatomic,strong) NSDictionary *baseDic;

@property (nonatomic,strong) NSArray *equipmentArr;

@property (nonatomic,strong) ZCColorModel *colorModel;

@property (nonatomic, copy) NSString *colour;
@property (nonatomic, copy) NSString *pattern;

@property (nonatomic,strong) UILabel *equipmentNumL;
@property (nonatomic,strong) UIView  *colorView;


@end

@implementation ZCCustomActionConfigureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    self.equipmentArr = @[];
    
    ZCAutoActionTrainTimeView *timeView = [[ZCAutoActionTrainTimeView alloc] init];
    timeView.dataDic = self.baseDic;
    [self.view addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
        
    UIView *equipView = [[UIView alloc] init];
    [equipView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.view addSubview:equipView];
    [equipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeView.mas_bottom).offset(AUTO_MARGIN(40));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
    
    UIView *colorView = [[UIView alloc] init];
    [colorView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.view addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(equipView.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
         
    [self createSubviewsOnTargetView:equipView title:NSLocalizedString(@"关联的运动器材", nil) index:0];
    [self createSubviewsOnTargetView:colorView title:NSLocalizedString(@"首页展现的个性颜色", nil) index:1];
    
    UIButton *sureBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"设置完成，立即添加到我的训练", nil) font:15 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:sureBtn];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [sureBtn addTarget:self action:@selector(finishTrainOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishTrainOperate {
    if (self.colour.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请选择个性颜色", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
   
    NSMutableArray *temArr = [NSMutableArray array];
    if (self.equipmentArr.count > 0) {
        for (ZCEquipmentModel *model in self.equipmentArr) {
            [temArr addObject:model.ID];
        }
    }
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionaryWithDictionary:self.baseDic];
    [baseDic setValue:self.colour forKey:@"colour"];
    [baseDic setValue:temArr forKey:@"apparatusList"];
    [ZCTrainManage createAutoActionTrainPlanOpereate:baseDic completeHandler:^(id  _Nonnull responseObj) {        
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    } else if (index == 1) {
        self.colorView = [[UIView alloc] init];
        [targetView addSubview:self.colorView];
        [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(targetView.mas_centerY);
            make.trailing.mas_equalTo(icon.mas_leading).inset(AUTO_MARGIN(5));
            make.height.width.mas_equalTo(AUTO_MARGIN(20));
        }];
        [self.colorView setViewCornerRadiu:AUTO_MARGIN(10)];
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
        case 1://个性颜色
        {
            [HCRouter router:@"SelectColor" params:@{} viewController:self animated:YES block:^(id  _Nonnull value) {
                weakself.colour = value;
                weakself.colorView.backgroundColor = kColorHex(value);
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
    self.view.backgroundColor = [ZCConfigColor bgColor];
}

@end
