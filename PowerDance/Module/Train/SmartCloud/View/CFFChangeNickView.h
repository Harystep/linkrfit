//
//  CFFChangeNickView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFChangeNickView : UIView

@property (nonatomic, copy) void (^SaveNickOperate)(NSString *name);

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UILabel *unitL;
@property (nonatomic,strong) UILabel *descL;

- (void)showAlertView;

@end

NS_ASSUME_NONNULL_END
