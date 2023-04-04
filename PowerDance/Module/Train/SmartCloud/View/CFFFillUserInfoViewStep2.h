//
//  CFFFillUserInfoViewStep2.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CFFUserInfoSelectTargetView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFFFillUserInfoViewStep2 : UIView

@property (nonatomic,strong) CFFUserInfoSelectTargetView *targetView;

@property (nonatomic,strong) NSDictionary *parm;

@end

NS_ASSUME_NONNULL_END
