//
//  CFFProcotolDetailController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/15.
//

#import "ZCProcotolDetailController.h"
#import <WebKit/WebKit.h>

@interface ZCProcotolDetailController ()

@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation ZCProcotolDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavStatus = YES;
    self.backStyle = UINavBackButtonColorStyleBack;
 
    NSString *url = self.params[@"data"];
    WKWebView *webView = [[WKWebView alloc] init];
    self.wkWebView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    
    [self createPregerssView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webView loadRequest:request];
    });
        
}

- (void)createPregerssView {
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.backgroundColor = [ZCConfigColor txtColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
