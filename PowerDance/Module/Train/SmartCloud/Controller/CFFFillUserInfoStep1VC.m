//
//  CFFFillUserInfoStep1VC.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/26.
//

#import "CFFFillUserInfoStep1VC.h"
#import "CFFFillUserInfoViewStep1.h"

@interface CFFFillUserInfoStep1VC ()

@property (nonatomic,strong) CFFFillUserInfoViewStep1 *stepView1;

@property (nonatomic,assign) NSInteger ageFlag;

@end

@implementation CFFFillUserInfoStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
    }
    self.showNavStatus = YES;
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.lblMsg.text = NSLocalizedString(@"基本资料", nil);
    self.lblSubMsg.text = NSLocalizedString(@"填写得越详细越能精准地了解自己的身体哦", nil);
    [self.btnBottom setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [self.pageIndex setCurrentPage:0];
    
    [self.view addSubview:self.stepView1];
    [self.stepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kCFF_FILL_USER_INFO_TOP_HEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- kCFF_FILL_USER_INFO_BOTTOM_HEIGHT);
    }];
    
    [self.view bringSubviewToFront:self.btnBottom];
    kweakself(self);
    [self.btnBottom addTapGestureWithAction:^{
        [weakself jumpNextOperate];
    }];

}
#pragma -- mark 跳转下一步
- (void)jumpNextOperate {
    NSDictionary *dataDic = kUserStore.saveData;
    NSArray *keyArr = dataDic.allKeys;
    if (keyArr.count >= 4) {
        [ZCProfileManage updateUserInfoOperate:dataDic completeHandler:^(id  _Nonnull responseObj) {
            [HCRouter router:@"FillUserInfoStep2" params:@{} viewController:self animated:YES];
        }];
    } else {
        [self.view makeToast:NSLocalizedString(@"请填写信息", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (CFFFillUserInfoViewStep1 *)stepView1 {
    if (!_stepView1) {
        _stepView1 = [[CFFFillUserInfoViewStep1 alloc] init];
    }
    return _stepView1;
}

@end
