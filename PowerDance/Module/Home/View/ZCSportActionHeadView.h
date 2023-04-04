//
//  ZCSportActionHeadView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSportActionHeadView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic, copy) void (^changeGroupNameOperate)(NSString *content);
@property (nonatomic, copy) void (^changeGroupLoopOperate)(NSString *content);

@end

NS_ASSUME_NONNULL_END
