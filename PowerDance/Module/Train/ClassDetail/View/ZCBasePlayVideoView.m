//
//  ZCBasePlayVideoView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import "ZCBasePlayVideoView.h"

@interface ZCBasePlayVideoView ()

@end

@implementation ZCBasePlayVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.player = [[JRPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                                asset:[NSURL URLWithString:@""]];
    [self addSubview:self.player];
//    self.player.smallControlView.delegate = self;
}

- (void)setMp4_url:(NSString *)mp4_url {
    _mp4_url = mp4_url;
    self.player.urlString = mp4_url;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error: nil];
        [self.player prepareToPlay];
    });
   
}

- (void)play {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error: nil];
        [self.player play];
    });
}

- (void)pause {
    [self.player pause];
}

@end

