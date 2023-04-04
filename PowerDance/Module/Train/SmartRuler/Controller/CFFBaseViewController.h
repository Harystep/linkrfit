//
//  CFFBaseViewController.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/22.
//

#import <UIKit/UIKit.h>
#import "CFFNoneDataView.h"

typedef NS_ENUM(NSUInteger, CFFBackButtonStyle) {
    CFFBackButtonStyleNone     = 1 << 0,
    CFFBackButtonStyleBlack = 1 << 1,
    CFFBackButtonStyleWhite = 1 << 2
};


NS_ASSUME_NONNULL_BEGIN

@interface CFFBaseViewController : UIViewController

@property (nonatomic,copy) NSString *scheme;
@property (nonatomic,copy) NSDictionary *params;

@property (nonatomic,assign) BOOL needNavBar;

@property (nonatomic,assign) CFFBackButtonStyle backButtonStyle;

//自定义的导航栏
@property (nonatomic,strong) UIView *customNavBar;

@property (nonatomic,assign) BOOL enableIQKeyboardManager;

@property (nonatomic,strong) CFFNoneDataView *noneView;

- (instancetype) initWithParams:(NSDictionary * _Nullable )dic;

- (void)backOperate;

@end

NS_ASSUME_NONNULL_END
