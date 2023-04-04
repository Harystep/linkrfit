//
//  ZCSelectPlaceController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCCreateAddressController.h"
#import "ZCArrviveAddressView.h"
#import "ZCContactTypeView.h"
#import "ZCShopAddressModel.h"

@interface ZCCreateAddressController ()

@property (nonatomic,strong) ZCContactTypeView *contactView;
@property (nonatomic,strong) ZCArrviveAddressView *addressView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) ZCShopAddressModel *model;

@end

@implementation ZCCreateAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    [self setupSubviews];
    
}

- (void)setupSubviews {
    self.contactView = [[ZCContactTypeView alloc] init];
    [self.contentView addSubview:self.contactView];
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(10));
    }];
    
    self.addressView = [[ZCArrviveAddressView alloc] init];
    [self.contentView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contactView.mas_bottom);
    }];
    
    UIView *defaultView = [[UIView alloc] init];
    [self.contentView addSubview:defaultView];
    defaultView.backgroundColor = [ZCConfigColor whiteColor];
    [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(200));
    }];
    
    [self setupDefaultView:defaultView];
    
    if (self.model != nil) {
        self.contactView.model = self.model;
        self.addressView.model = self.model;
    }
    [self setupBottomView];
}

- (void)setupDefaultView:(UIView *)defaultView {
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"设为默认地址", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [defaultView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(defaultView.mas_centerY);
        make.leading.mas_equalTo(defaultView.mas_leading).offset(AUTO_MARGIN(18));
    }];
    
    UIButton *switchBtn = [[UIButton alloc] init];
    [defaultView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(defaultView.mas_centerY);
        make.trailing.mas_equalTo(defaultView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    [switchBtn setImage:kIMAGE(@"address_default_nor") forState:UIControlStateNormal];
    [switchBtn setImage:kIMAGE(@"address_default_sel") forState:UIControlStateSelected];
    [switchBtn addTarget:self action:@selector(switchBtnOperate:) forControlEvents:UIControlEventTouchUpInside];
    if (self.model != nil) {
        switchBtn.selected = [self.model.isDefault integerValue];
        self.status = switchBtn.selected;
    }
}

- (void)switchBtnOperate:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.status = sender.selected;
}

- (void)setupBottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [ZCConfigColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(83));
    }];
    
    UIButton *addBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"保存地址", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [bottomView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(bottomView.mas_bottom).inset(AUTO_MARGIN(30));
        make.height.mas_equalTo(42);
    }];
    addBtn.backgroundColor = [ZCConfigColor txtColor];
    [addBtn setViewCornerRadiu:21];
    [addBtn addTarget:self action:@selector(submitOperate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)defaultOperate:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.status = 1;
    } else {
        self.status = 0;
    }
}

- (void)submitOperate {
    NSString *realName = self.contactView.nameF.text;
    if (realName.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写姓名", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSString *phone = self.contactView.phoneF.text;
    if (phone.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写联系方式", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSString *province = self.addressView.addressF.text;
    if (province.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请选择所在地", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSString *address = self.addressView.textF.text;
    if (address.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请输入详细地址", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSArray *addressArr = [province componentsSeparatedByString:@" "];
    NSDictionary *dic = @{
                        @"realName":realName,
                        @"phone":phone,
                        @"province":addressArr[0],
                        @"city":addressArr[1],
                        @"region":addressArr[2],
                        @"address":address,
                        @"isDefault":@(self.status)
                    };
    NSLog(@"dic--> %@", dic);
    if (self.model != nil) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:dic];
        [parm setValue:self.model.ID forKey:@"id"];
        [ZCShopManage updateShopArriveAddressInfo:parm completeHandler:^(id  _Nonnull responseObj) {
            ZCShopAddressModel *model = [ZCShopAddressModel mj_objectWithKeyValues:dic];
            self.callBackBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [ZCShopManage saveShopArriveAddressInfo:dic completeHandler:^(id  _Nonnull responseObj) {
            ZCShopAddressModel *model = [ZCShopAddressModel mj_objectWithKeyValues:dic];
            self.callBackBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"添加地址", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.scView.backgroundColor = rgba(246, 246, 246, 1);
    self.model = self.params[@"model"];

}

@end
