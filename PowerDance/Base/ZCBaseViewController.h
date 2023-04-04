//
//  ZCBaseViewController.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UINavBackButtonColorStyleBack = 0,
    UINavBackButtonColorStyleWhite,
} UINavBackButtonColorStyle;

typedef enum : NSUInteger {
    UINavTitlePostionStyleRight = 0,
    UINavTitlePostionStyleCenter,    
} UINavTitlePostionStyle;

NS_ASSUME_NONNULL_BEGIN

@interface ZCBaseViewController : UIViewController

@property (nonatomic,strong) UINavigationBar *navBar;

@property (nonatomic,strong) UIView *naviView;
@property (nonatomic,strong) UIImageView *navBgIcon;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,assign) BOOL showNavStatus;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel  *titleL;
@property (nonatomic,strong) UIView *noneView;
@property (nonatomic,assign) NSInteger signNoneView;
@property (nonatomic,assign) UINavBackButtonColorStyle backStyle;

@property (nonatomic,assign) UINavTitlePostionStyle titlePostionStyle;

- (void)backOperate;

- (void)maskBtnClick;

- (void)configureNoneiewWithData:(NSArray *)dataArr;

- (void)configureNoneiewWithData:(NSArray *)dataArr title:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
