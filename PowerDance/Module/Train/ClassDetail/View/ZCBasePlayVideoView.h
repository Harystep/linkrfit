//
//  ZCBasePlayVideoView.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import <UIKit/UIKit.h>
#import "JRPlayerView.h"
#import "JRControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCBasePlayVideoView : UIView

@property (nonatomic, strong) JRPlayerView        *player;

@property (nonatomic, copy) NSString *mp4_url;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
