//
//  CFFBluetoothStatusView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/15.
//

#import "CFFBluetoothStatusView.h"
#import "CFFBluetoothAlertView.h"

@interface CFFBluetoothStatusView ()

@property (nonatomic,strong) UIImageView *statusIv;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) CFFBluetoothAlertView *alertView;

@end

@implementation CFFBluetoothStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = RGBA_COLOR(0, 0, 0, 1);
    contentView.alpha = 0.39;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.statusIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_blu_connect")];
    [self addSubview:self.statusIv];
    [self.statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self).offset(AUTO_MARGIN(5));
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
        make.top.mas_equalTo(AUTO_MARGIN(2));
    }];
    
    self.statusL = [self createSimpleLabelWithTitle:NSLocalizedString(@"连接中", nil) font:14 bold:NO color:UIColor.whiteColor];
    [self addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.statusIv.mas_trailing).offset(AUTO_MARGIN(8));
        make.centerY.mas_equalTo(self.statusIv.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(12));
    }];
    
    self.type = 1;
    
    [self setViewCornerRadiu:AUTO_MARGIN(17)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickStatus)];
    [self addGestureRecognizer:tap];
    
//    [self loopBasecAnimation];
}

- (void)setDeviceType:(SmartDeviceType)deviceType {
    _deviceType = deviceType;
    switch (deviceType) {
        case SmartDeviceTypeScale:
        {
            self.iconStr = @"smart_scale_status";
        }
            break;
        case SmartDeviceTypeRuler:
        {
            self.iconStr = @"smart_ruler_status";
        }
            break;
        case SmartDeviceTypeCloud:
        {
            self.iconStr = @"smart_cloud_status";
        }
            break;
            
        default:
            break;
    }
    
}

-(void)showStatusView {
    CFFBluetoothAlertView *alert = [[CFFBluetoothAlertView alloc] init];
    self.alertView = alert;
    self.alertView.iconIv.image = kIMAGE(self.iconStr);
    self.alertView.type = self.deviceType;
    [self.alertView showAlertView];
    kweakself(self);
    self.alertView.BlueConnectAttempt = ^{
        weakself.alertView = nil;
        weakself.type = 1;
        [weakself loopBasecAnimation];
        weakself.BluetoothConnectOperate();
    };
}

-(void)hideStatusView {
    [self.alertView hideAlertView];
}

- (void)tapClickStatus {
    if (self.type == BluetoothConnectStatusClosed) {
        [self showStatusView];
    }
}

- (void)setIconStr:(NSString *)iconStr {
    _iconStr = iconStr;
}

- (void)setType:(BluetoothConnectStatus)type {
    _type = type;
    NSString *iconStr = @"";
    NSString *content = @"";
    switch (type) {
        case BluetoothConnectStatusClosed:
        {
            [self stopLoopAnimation];
            iconStr = @"smart_blu_Notconnect";
            content = NSLocalizedString(@"无连接", nil);
        }
            break;
        case BluetoothConnectStatusIng:
        {
            iconStr = @"smart_blu_connect";
            content = NSLocalizedString(@"连接中", nil);
            [self loopBasecAnimation];
        }
            break;
        case BluetoothConnectStatusOk:
        {
            [self stopLoopAnimation];
            iconStr = @"smart_blu_connected";
            content = NSLocalizedString(@"已连接", nil);
        }
            break;
                        
        default:
            break;
    }
    
    self.statusIv.image = kIMAGE(iconStr);
    self.statusL.text = content;
}

-(void)loopBasecAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    [self.statusIv.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

-(void)stopLoopAnimation
{
    [self.statusIv.layer removeAllAnimations];

}

@end
