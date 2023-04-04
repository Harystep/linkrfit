//
//  ZCGoodsDetailInfoView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/10.
//

#import "ZCGoodsDetailInfoView.h"
#import <WebKit/WebKit.h>


@interface ZCGoodsDetailInfoView ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkWebView;

@end

@implementation ZCGoodsDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"商品详情", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
//        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    
    WKWebView *webView = [[WKWebView alloc] init];
    self.wkWebView = webView;
    webView.UIDelegate = self;
    [self addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(200));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    [self.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setContent:(NSString *)content {
    _content = content;
    NSString *html = [NSString stringWithFormat:@"<html> \n" "<head> \n" "<style type=\"text/css\"> \n" "body {font-size:15px;}\n" "</style> \n" "</head> \n" "<body>" "<script type='text/javascript'>" "window.onload = function(){\n" "var $img = document.getElementsByTagName('img');\n" "for(var p in  $img){\n" " $img[p].style.width = '100%%';\n" "$img[p].style.height ='auto'\n" "}\n" "}" "</script>%@" "</body>" "</html>", content];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView loadHTMLString:html baseURL:nil];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"1111");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
   
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect webFrame = self.wkWebView.frame;
        webFrame.size.height = self.wkWebView.scrollView.contentSize.height;
        [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(webFrame.size.height);
        }];
    }
}

- (void)dealloc {
    [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
