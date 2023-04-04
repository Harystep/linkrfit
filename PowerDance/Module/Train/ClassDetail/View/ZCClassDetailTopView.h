//
//  ZCClassDetailTopView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassDetailTopView : UIView

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) UILabel *subL;

@property (nonatomic, copy) NSString *mp4_url;

@property (nonatomic,assign) BOOL playStatus;

@end

NS_ASSUME_NONNULL_END
