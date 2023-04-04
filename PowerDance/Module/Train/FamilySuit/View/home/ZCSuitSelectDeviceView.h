//
//  ZCSuitSelectDeviceView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSuitSelectDeviceView : UIView

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) NSMutableArray *itemArr;

@property (nonatomic,strong) NSMutableArray *viewArr;//保存View视图

- (void)resetStatusView:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
