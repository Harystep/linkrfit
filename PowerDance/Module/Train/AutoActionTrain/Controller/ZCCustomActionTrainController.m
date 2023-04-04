//
//  ZCCustomActionTrainController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/27.
//

#import "ZCCustomActionTrainController.h"
#import "ZCCustomActionAddView.h"
#import "ZCEquipmentModel.h"
#import "ZCCustomTrainActionTimeView.h"

@interface ZCCustomActionTrainController ()<UITextViewDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITextView *descView;
@property (nonatomic,strong) UITextField *nameF;
@property (nonatomic, strong) UILabel *placeL;
@property (nonatomic,strong) ZCCustomActionAddView *addView;
@property (nonatomic,strong) UILabel *equipmentNumL;
@property (nonatomic,strong) UIView  *colorView;
@property (nonatomic,strong) NSArray *equipmentArr;
@property (nonatomic, copy) NSString *colour;
@property (nonatomic,strong) ZCCustomTrainActionTimeView *timeView;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic,strong) UIView *alertMaskView;

@end

@implementation ZCCustomActionTrainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.equipmentArr = @[];
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    UIView *textView = [[UIView alloc] init];
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(170));
    }];
    textView.backgroundColor = rgba(173, 173, 173, 0.1);
    [textView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UIView *nameView = [[UIView alloc] init];
    [textView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_top);
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
    [self configNameView:nameView];
    
    UIView *descView = [[UIView alloc] init];
    [self.contentView addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    [self configDescView:descView];
    
    UIView *lineView = [[UIView alloc] init];
    [textView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(textView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(1));
        make.trailing.mas_equalTo(textView.mas_trailing);
        make.top.mas_equalTo(nameView.mas_bottom);
    }];
    lineView.backgroundColor = rgba(223, 223, 223, 1);
    
    UIView *actionView = [[UIView alloc] init];
    [self.contentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(textView.mas_bottom).offset(AUTO_MARGIN(14));
        make.height.mas_equalTo(AUTO_MARGIN(260));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    actionView.backgroundColor = rgba(173, 173, 173, 0.1);
    [actionView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    ZCCustomActionAddView *addView = [[ZCCustomActionAddView alloc] init];
    self.addView = addView;
    [actionView addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(actionView.mas_top).offset(AUTO_MARGIN(85));
        make.leading.trailing.mas_equalTo(actionView).inset(AUTO_MARGIN(5));
        make.height.mas_equalTo(AUTO_MARGIN(162));
    }];
    
    self.timeView = [[ZCCustomTrainActionTimeView alloc] init];
    [actionView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(actionView);
    }];
    
    UIButton *nextBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"完    成", nil) font:15 color:UIColor.whiteColor];
    nextBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));;
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(29));
        
    }];
    [nextBtn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
    [self configureOtherInfoView:actionView];
    
    if ([self.params[@"edit"] integerValue] == 1) {
        [self configureEditDataInfo];
    }
}

- (void)configureEditDataInfo {
    NSDictionary *dic = self.params[@"data"];
    NSArray *actionList = dic[@"actionList"];
    NSMutableArray *temArr = [NSMutableArray array];
    for (int i = 0; i < actionList.count; i ++) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = actionList[i];
        [temDic addEntriesFromDictionary:dic[@"courseAction"]];
        [temDic setValue:checkSafeContent(dic[@"duration"]) forKey:@"duration"];
        
        NSMutableDictionary *tem = [NSMutableDictionary dictionary];
        [tem setValue:checkSafeContent(temDic[@"actionId"]) forKey:@"actionId"];
        [tem setValue:checkSafeContent(temDic[@"rest"]) forKey:@"rest"];
        [tem setValue:temDic[@"duration"] forKey:@"duration"];
        [tem setValue:checkSafeContent(temDic[@"name"]) forKey:@"name"];
        [tem setValue:checkSafeContent(temDic[@"cover"]) forKey:@"cover"];
        [temArr addObject:tem];
    }
    self.addView.editDataArr = temArr;
    self.nameF.text = checkSafeContent(dic[@"title"]);
    self.nameStr = checkSafeContent(dic[@"title"]);
    NSString *content = checkSafeContent(dic[@"briefDesc"]);
    if (content.length > 0) {
        self.descView.text = content;
        self.placeL.hidden = YES;
    }
    self.colour = checkSafeContent(dic[@"colour"]);
    self.colorView.backgroundColor = kColorHex(checkSafeContent(dic[@"colour"]));
    NSArray *apparatusList = [ZCDataTool convertEffectiveData:dic[@"apparatusList"]];
    if (apparatusList.count > 0) {
        self.equipmentNumL.text = [NSString stringWithFormat:@"%tu", apparatusList.count];
    }
    self.equipmentArr = [ZCEquipmentModel mj_objectArrayWithKeyValuesArray:apparatusList];
    self.timeView.dataArr = temArr;
}

- (void)configureOtherInfoView:(UIView *)topView {
    UIView *equipView = [[UIView alloc] init];
    [equipView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [self.view addSubview:equipView];
    [equipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(60));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(97));
    }];
    [equipView setViewCornerRadiu:AUTO_MARGIN(10)];
    
//    UIView *colorView = [[UIView alloc] init];
//    [colorView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
//    [self.view addSubview:colorView];
//    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(equipView.mas_bottom).offset(AUTO_MARGIN(15));
//        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
//        make.height.mas_equalTo(AUTO_MARGIN(60));
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(97));
//    }];
//    [colorView setViewCornerRadiu:AUTO_MARGIN(10)];
         
    [self createSubviewsOnTargetView:equipView title:NSLocalizedString(@"关联的运动器材", nil) index:0];
//    [self createSubviewsOnTargetView:colorView title:NSLocalizedString(@"首页展现的个性颜色", nil) index:1];
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
        self.colorView.backgroundColor = kColorHex(self.colour);
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

- (void)nextOperate {
    if (self.nameF.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写训练名称", nil) duration:2 position:CSToastPositionCenter];
        return;
    }
    if (self.addView.dataArr.count == 1) {
        [self.view makeToast:NSLocalizedString(@"请选择添加运动", nil) duration:2 position:CSToastPositionCenter];
        return;
    } else {
        NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.addView.dataArr];
        [dataArr removeLastObject];
        NSDictionary *dic = @{@"actionList":dataArr,
                              @"title":self.nameF.text,
                              @"briefDesc":checkSafeContent(self.descView.text)
        };
//        [HCRouter router:@"CustomActionConfigure" params:@{@"data":dic} viewController:self animated:YES];
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
        NSMutableDictionary *baseDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [baseDic setValue:self.colour forKey:@"colour"];
        [baseDic setValue:temArr forKey:@"apparatusList"];
        if ([self.params[@"edit"] integerValue] == 1) {
            [baseDic setValue:self.params[@"data"][@"customCourseId"] forKey:@"customCourseId"];
            [ZCTrainManage editAutoActionTrainPlanOpereate:baseDic completeHandler:^(id  _Nonnull responseObj) {
                
                NSDictionary *dic = @{@"customCourseId":checkSafeContent(baseDic[@"customCourseId"])};
                [HCRouter router:@"CustomActionDetail" params:dic viewController:self animated:YES];

            }];
        } else {
            [ZCTrainManage createAutoActionTrainPlanOpereate:baseDic completeHandler:^(id  _Nonnull responseObj) {
                NSLog(@"%@", responseObj);
                NSDictionary *dic = responseObj[@"data"];
                [HCRouter router:@"CustomActionDetail" params:dic viewController:self animated:YES];
//                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
       
    }
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName isEqualToString:@"changeAction"]) {
        NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.addView.dataArr];
        [dataArr removeLastObject];
        self.timeView.dataArr = dataArr;
    }
}

- (void)configDescView:(UIView *)descView {
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0.1;
    bgView.backgroundColor = rgba(173, 173, 173, 0.1);
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

- (void)editOperate {
    [self.alertMaskView removeFromSuperview];
    self.nameF.text = @"";
    self.nameF.textColor = [ZCConfigColor txtColor];
    self.nameF.attributedPlaceholder = [self.nameF attributedText:NSLocalizedString(@"给自己的训练计划起个名吧！", nil) color:rgba(0, 0, 0, 0.25) font:14];
    [self.nameF becomeFirstResponder];
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
    bgView.backgroundColor = rgba(173, 173, 173, 0.1);
    [nameView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(nameView);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    self.nameF = tf;
    tf.font = FONT_SYSTEM(14);
    tf.textColor = [ZCConfigColor txtColor];
    [nameView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(nameView);
        make.leading.trailing.mas_equalTo(nameView).inset(AUTO_MARGIN(15));
    }];
    if ([self.params[@"edit"] integerValue] == 1) {        
    } else {
        self.alertMaskView = [[UIView alloc] init];
        [nameView addSubview:self.alertMaskView];
        [self.alertMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(nameView);
        }];
        NSString *nameStr = [NSString stringWithFormat:@"%@,%@的训练", @"Hi", checkSafeContent(kUserInfo.phone)];
        UILabel *normalL = [self.view createSimpleLabelWithTitle:nameStr font:14 bold:NO color:[ZCConfigColor txtColor]];
        [self.alertMaskView addSubview:normalL];
        [normalL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.alertMaskView.mas_centerY);
            make.leading.mas_equalTo(self.alertMaskView.mas_leading).offset(AUTO_MARGIN(14));
        }];
        
        UIButton *editBtn = [[UIButton alloc] init];
        [self.alertMaskView addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.alertMaskView.mas_centerY);
            make.leading.mas_equalTo(normalL.mas_trailing).offset(AUTO_MARGIN(5));
            make.height.width.mas_equalTo(AUTO_MARGIN(40));
        }];
        [editBtn setImage:kIMAGE(@"base_edit") forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editOperate) forControlEvents:UIControlEventTouchUpInside];
        self.nameF.text = nameStr;
        self.nameF.textColor = rgba(173, 173, 173, 0.1);
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"定制自己的训练", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.colour = [ZCDataTool randomColor];
}

@end
