//
//  ZCActionDetailTopView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCActionDetailTopView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

- (void)pausePlayVideo;

- (void)continuePlay;

@end

NS_ASSUME_NONNULL_END
