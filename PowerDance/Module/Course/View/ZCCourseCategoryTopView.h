//
//  ZCCourseCategoryTopView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCourseCategoryTopView : UIView

@property (nonatomic, copy) void (^cleanFilterDataOp)(void);

@property (nonatomic,strong) NSArray *categoryArr;

@end

NS_ASSUME_NONNULL_END
