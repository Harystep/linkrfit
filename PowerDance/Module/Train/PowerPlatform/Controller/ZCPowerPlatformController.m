//
//  ZCPowerPlatformController.m
//  PowerDance
//
//  Created by oneStep on 2023/4/11.
//

#import "ZCPowerPlatformController.h"
#import "ZCPowerPlatformTypeView.h"
#import "LNLineChartView.h"

@interface ZCPowerPlatformController ()<LNLineChartViewDelegate>

@property (nonatomic,strong) ZCPowerPlatformTypeView *topView;

@property (nonatomic,strong) LNLineChartView *chartView;

@property (nonatomic, assign) int count;

@end

@implementation ZCPowerPlatformController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.navBgIcon.hidden = NO;
    self.titleStr = NSLocalizedString(@"力量台", nil);
    self.titlePostionStyle = UINavTitlePostionStyleCenter;
    self.backStyle = UINavBackButtonColorStyleBack;
    
    self.topView = [[ZCPowerPlatformTypeView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(5);
        make.height.mas_equalTo(375);
    }];
    
    self.chartView = [[LNLineChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+5, SCREEN_W, 200)];
    self.chartView.delegate = self;
    self.chartView.backgroundColor = [ZCConfigColor whiteColor];
    [self.view addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.height.mas_equalTo(200);
    }];
    
    _count = 7;
    NSMutableArray *chartDataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<_count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (i<1) {
            dict[@"star"] = [NSNumber numberWithInt:i%4];
            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
        }else{
            dict[@"star"] = [NSNumber numberWithInt:i%4];
            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
        }
        [chartDataArr addObject:dict];
    }
    self.chartView.starInfoArr = chartDataArr;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    NSMutableArray *chartDataArr = [[NSMutableArray alloc] init];
//    _count ++;
//    for (int i = 0; i<_count; i++) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        if (i<2) {
//            dict[@"star"] = [NSNumber numberWithInt:i%4];
//            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
//        }else{
//            dict[@"star"] = [NSNumber numberWithInt:i%4];
//            dict[@"playDate"] = [NSString stringWithFormat:@"%dmin", i+1];
//        }
//        [chartDataArr addObject:dict];
//    }
//    self.chartView.starInfoArr = chartDataArr;
//}

#pragma mark - <LNLineChartViewDelegate>
- (void)refreshLatestObjectWithDateStr:(NSString *)dateStr star:(NSInteger)star
{
    
}

- (void)chartViewDotsTouchWithIndex:(NSInteger)index model:(LNLineChartModel *)model
{
    [self refreshLatestObjectWithDateStr:model.playDate star:model.star];
}



@end
