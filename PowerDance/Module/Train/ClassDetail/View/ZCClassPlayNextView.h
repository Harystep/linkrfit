//
//  ZCClassPlayNextView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassPlayNextView : UIView
//下一个动作
@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSDictionary *currentDic;

@property (nonatomic,assign) NSInteger signFirstFlag;

@end

NS_ASSUME_NONNULL_END
