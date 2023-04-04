//
//  ZCAutoTimerSWController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/24.
//

#import "ZCAutoTimerSWController.h"
#import "ZCAutoTimerSWOperateView.h"
#import "ZCAutoTimerSWCell.h"

@interface ZCAutoTimerSWController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) ZCAutoTimerSWOperateView *operateView;

@property (nonatomic,strong) UILabel *msL;
@property (nonatomic,strong) UILabel *minuteL;
@property (nonatomic,strong) NSTimer *mouseTimer;
@property (nonatomic,strong) NSTimer *minuteTimer;
@property (nonatomic,assign) NSInteger mouseIndex;
@property (nonatomic,assign) NSInteger minuteIndex;
/// 标记计时开始
@property (nonatomic,assign) NSInteger signStartFlag;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCAutoTimerSWController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self destroyTimer];
    [self removeBackgroundNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addBackgroundNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavStatus = YES;
    self.signEndFlag = YES;
    self.titleStr = [NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"在线计时器", nil), NSLocalizedString(@"秒表", nil)];
    self.operateView = [[ZCAutoTimerSWOperateView alloc] init];
    [self.view addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(210));
        make.height.mas_equalTo(AUTO_MARGIN(80));
    }];
        
    UILabel *minuteL = [self.view createSimpleLabelWithTitle:@"00:00" font:80 bold:NO color:[ZCConfigColor txtColor]];
    minuteL.font = [UIFont fontWithName:@"Helvetica Neue" size:80];
    self.minuteL = minuteL;
    [self.view addSubview:minuteL];
    [minuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(80));
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-AUTO_MARGIN(58));
    }];
    UILabel *mouseL = [self.view createSimpleLabelWithTitle:@".00" font:80 bold:NO color:[ZCConfigColor txtColor]];
    [self.view addSubview:mouseL];
    self.msL = mouseL;
    mouseL.font = [UIFont fontWithName:@"Helvetica Neue" size:80];
    [mouseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(80));
        make.leading.mas_equalTo(minuteL.mas_trailing);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.operateView.mas_bottom).offset(AUTO_MARGIN(5));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(TAB_BAR_HEIGHT + AUTO_MARGIN(5));
    }];
//    [self labelAlightLeftAndRightWithWidth:AUTO_MARGIN(56) view:minuteL content:@"00:00"];
//    [self labelAlightLeftAndRightWithWidth:AUTO_MARGIN(56) view:mouseL content:@".00"];
}

- (void)appEnterBackground {
    NSLog(@"sw - leave");
    self.goBackgroundDate = [NSDate date];
    [self pauseTimer];
}

- (void)appBecomeActive {
    NSLog(@"sw - come");
    if (self.signEndFlag) {
    } else {
        NSTimeInterval  timeGone = [[NSDate date] timeIntervalSinceDate:self.goBackgroundDate];
        NSInteger count = timeGone;
        self.minuteIndex = self.minuteIndex + count;
        self.minuteL.text = [ZCDataTool convertMouseToMSTimeString:self.minuteIndex];
        [self continueTimer];
    }
    
}

- (void)labelAlightLeftAndRightWithWidth:(CGFloat)labelWidth view:(UILabel *)lb content:(NSString *)content {
    CGSize testSize = [content boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FONT_BOLD(80)} context:nil].size;

    CGFloat margin = (labelWidth - testSize.width)/(content.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:content];

    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, content.length - 1 )];
    lb.attributedText = attribute;
    
}


- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo block:(void (^)(id _Nonnull))block {
    if ([eventName isEqualToString:@"start"]) {
        if ([userInfo[@"status"] integerValue] == 1) {
            [self continueTimer];
        } else {
            self.signEndFlag = YES;
            [self pauseTimer];
        }
    } else if ([eventName isEqualToString:@"cancel"]) {
        if (self.signStartFlag) {
            if ([userInfo[@"status"] integerValue] == 1) {//复位
                [self resetData];
            } else {//计次
                NSString *content = [NSString stringWithFormat:@"%@%@", self.minuteL.text, self.msL.text];
                NSInteger count = self.dataArr.count;
                NSDictionary *dic = @{@"title":@(count+1),
                                      @"content":content
                };
                [self.dataArr insertObject:dic atIndex:0];
                [self.tableView reloadData];
            }
        }
    }
}

#pragma -- mark 毫秒计时
- (void)mouseOperate {
    self.mouseIndex ++;
    self.msL.text = [NSString stringWithFormat:@".%02tu", self.mouseIndex];
//    [self labelAlightLeftAndRightWithWidth:AUTO_MARGIN(56) view:self.msL content:[NSString stringWithFormat:@".%02tu", self.mouseIndex]];
    if (self.mouseIndex == 99) {
        self.mouseIndex = 0;
    }
}
#pragma -- mark 秒计时
- (void)minuteOperate {    
    self.minuteIndex ++;
    self.minuteL.text = [ZCDataTool convertMouseToMSTimeString:self.minuteIndex];
//    [self labelAlightLeftAndRightWithWidth:AUTO_MARGIN(56) view:self.minuteL content:[ZCDataTool convertMouseToMSTimeString:self.minuteIndex]];
}

- (void)resetData {
    [self destroyTimer];
    self.mouseIndex = 0;
    self.minuteIndex = 0;
    self.signStartFlag = NO;
    self.msL.text = @".00";
    self.minuteL.text = @"00:00";
    self.signStartFlag = NO;
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}

- (void)destroyTimer {
    NSLog(@"destroyTimer");
    [self.operateView resetSubviews];
    [self.mouseTimer invalidate];
    self.mouseTimer = nil;
    [self.minuteTimer invalidate];
    self.minuteTimer = nil;
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer {
    [self.mouseTimer setFireDate:[NSDate distantFuture]];
    [self.minuteTimer setFireDate:[NSDate distantFuture]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCAutoTimerSWCell *cell = [ZCAutoTimerSWCell autoTimerSWCellWithTableView:tableView idnexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

//继续计时
-(void)continueTimer {
    self.signEndFlag = NO;
    if (self.signStartFlag) {
        [self.mouseTimer setFireDate:[NSDate distantPast]];
        [self.minuteTimer setFireDate:[NSDate distantPast]];
    } else {
        self.signStartFlag = YES;
        [[NSRunLoop mainRunLoop] addTimer:self.mouseTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop mainRunLoop] addTimer:self.minuteTimer forMode:NSRunLoopCommonModes];
    }
}

- (NSTimer *)mouseTimer {
    if (!_mouseTimer) {
        _mouseTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(mouseOperate) userInfo:nil repeats:YES];
    }
    return _mouseTimer;
}

- (NSTimer *)minuteTimer {
    if (!_minuteTimer) {
        _minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minuteOperate) userInfo:nil repeats:YES];
    }
    return _minuteTimer;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZCAutoTimerSWCell class] forCellReuseIdentifier:@"ZCAutoTimerSWCell"];
        
    }
    return _tableView;
}

@end
