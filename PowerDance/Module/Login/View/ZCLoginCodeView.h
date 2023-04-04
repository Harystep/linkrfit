//
//  CFFLoginCodeView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/6.
//

#import <UIKit/UIKit.h>


@interface ZCLoginCodeView : UIView

@property (nonatomic, copy) void (^clickSendCodeOperate)(void);

@property (nonatomic,copy) NSString *text;

@property (nonatomic,strong) UITextField *txtInput;

@property (nonatomic,assign) NSInteger errorStatus;

@property (nonatomic,strong) NSTimer *timer;

- (void)startTimer;

@end

