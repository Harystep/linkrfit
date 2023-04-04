//
//  ZCSearchTrainTextView.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSearchTrainTextView : UIView

@property (nonatomic, copy) void (^searchTrainResult)(NSString *content);

@property (nonatomic,strong) UIView *searchView;

@property (nonatomic,assign) NSInteger editFlag;

@end

NS_ASSUME_NONNULL_END
