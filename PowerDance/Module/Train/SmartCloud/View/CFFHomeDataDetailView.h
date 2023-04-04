//
//  CFFHomeDataDetailView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/29.
//

#import <UIKit/UIKit.h>
#import "CFFHomeLastWeightView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFFHomeDataDetailView : UIView

@property (nonatomic,assign) double dataWeight;
@property (nonatomic,strong) CFFHomeLastWeightView *weightView;
@property (nonatomic,assign) NSInteger type;//1 云朵秤
- (void)refreshStandViewData:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
