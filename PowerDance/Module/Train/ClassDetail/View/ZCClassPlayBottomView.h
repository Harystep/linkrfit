//
//  ZCClassPlayBottomView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import <UIKit/UIKit.h>
#import "ZCBaseCircleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassPlayBottomView : UIView

@property (nonatomic,strong) UIButton *trainPreBtn;
@property (nonatomic,strong) UIButton *trainNextBtn;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) ZCBaseCircleView *bigView;
@property (nonatomic,strong) ZCBaseCircleView *smallView;

@end

NS_ASSUME_NONNULL_END
