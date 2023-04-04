//
//  CFFLoginInputView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCLoginInputView : UIView

@property (nonatomic,copy) NSString *text;

@property (nonatomic,strong) UITextField *txtInput;

@property (nonatomic,assign) NSInteger errorStatus;

- (void)showMsg:(NSString *)msg;

- (void)cleanMsg;



@end

NS_ASSUME_NONNULL_END
