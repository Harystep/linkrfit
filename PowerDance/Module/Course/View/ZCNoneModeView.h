//
//  ZCNoneModeView.h
//  BrandGogo
//
//  Created by PC-N121 on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import "ZCSimpleNoneView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCNoneModeView : UIView

@property (nonatomic,strong) ZCSimpleNoneView *noneView;

@property (nonatomic,assign) BOOL showNoneStatus;

- (void)configureNoneViewWithData:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
