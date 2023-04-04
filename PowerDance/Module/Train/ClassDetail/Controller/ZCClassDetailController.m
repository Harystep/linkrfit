//
//  ZCClassDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCClassDetailController.h"
#import "ZCClassDetailTopView.h"
#import "ZCClassDetailActionCell.h"
#import "ZCPhotoManage.h"
#import "ZCClassPlayMiddleView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZCClassDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) ZCClassDetailTopView *topView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *actionArr;

@property (nonatomic,strong) NSMutableArray *videoUrlArr;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) ZCClassPlayMiddleView *middleView;

@property (nonatomic,assign) NSInteger signExitFlag;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *showActionArr;

@property (nonatomic,strong) NSString *restStr;//标记

@end

@implementation ZCClassDetailController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.topView.playStatus = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(-AUTO_MARGIN(STATUS_BAR_HEIGHT));
        make.bottom.leading.trailing.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(98));
    }];
    self.topView = [[ZCClassDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(500))];
    self.tableView.tableHeaderView = self.topView;
    [self configureBaseInfo];
    
    [self createBottomBlurView];
    
    [self getClassDetailInfo];
    
}

- (void)createBottomBlurView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, SCREEN_H - AUTO_MARGIN(98), SCREEN_W, AUTO_MARGIN(98));
    view.backgroundColor = UIColor.clearColor;
    [view setViewColorAlpha:0.1 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:view];

    // blur
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(98));
    [view addSubview:visualView];
    
    UIButton *startBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"立即开始训练", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self.view addSubview:startBtn];
    startBtn.backgroundColor = [ZCConfigColor txtColor];
    [startBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [startBtn addTarget:self action:@selector(startOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getClassDetailInfo {
    [ZCClassSportManage classDetailInfo:@{@"id":checkSafeContent(self.params[@"courseId"])} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSDictionary *dataDic = responseObj[@"data"];
        self.dataDic = dataDic;
        self.topView.dataDic = dataDic;
        [self compareContentSize:dataDic[@"briefDesc"] withFont:12 widthLimited:SCREEN_W - AUTO_MARGIN(40)];
        NSArray *dataList = dataDic[@"actionList"];
        NSMutableArray *temArr = [NSMutableArray array];
        for (NSDictionary *dic in dataList) {
            NSDictionary *courseAction = dic[@"courseAction"];
            if ([courseAction[@"rest"] integerValue] == 1) {
            } else {
                [temArr addObject:dic];
            }
        }
        self.showActionArr = temArr;
        self.actionArr = dataDic[@"actionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)startOperate {
    [ZCDataTool judgeUserMode];
    
    if (self.actionArr.count > 0) {
        self.index = 0;
        self.signExitFlag = NO;
        [self.view addSubview:self.middleView];
        self.middleView.hidden = NO;
        self.middleView.iconStr = self.dataDic[@"imgUrl"];
        self.middleView.nameL.text = self.dataDic[@"title"];
        self.videoUrlArr = [NSMutableArray array];
        NSDictionary *dic = self.actionArr[self.index];
        [self downloadVideoSource:[self convertVideoUrl:dic]];
    } else {
        [self.view makeToast:NSLocalizedString(@"似乎已断开与网联网的连接", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (NSString *)convertVideoUrl:(NSDictionary *)dic {
    return checkSafeContent(dic[@"courseAction"][@"vedio"]);
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"middle"]) {
        [self.middleView fireCustomTimer];
        self.middleView.hidden = YES;
        self.middleView = nil;
        self.signExitFlag = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    count = self.showActionArr.count > 0?1:0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCClassDetailActionCell *cell = [ZCClassDetailActionCell classDetailActionCellWithTableView:tableView idnexPath:indexPath];
    cell.dataArr = self.actionArr;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return AUTO_MARGIN(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //EquipmentDetail   ActionDetail
    NSDictionary *dic = self.showActionArr[indexPath.row];
    [HCRouter router:@"ActionDetail" params:dic viewController:self animated:YES];
}

- (void)downloadVideoSource:(NSString *)pathUrl {
    if (self.signExitFlag) return;
    NSLog(@"pathUrl---->%@", pathUrl);
    [[ZCPhotoManage alloc] newLoadData:[NSURL URLWithString:pathUrl] completeHandler:^(id  _Nonnull responseObj) {
        if ([responseObj[@"code"] integerValue] == 200) {
            NSDictionary *dic = self.actionArr[self.index];
            NSDictionary *contentDic = dic[@"courseAction"];
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setValue:contentDic[@"actionId"] forKey:@"actionId"];
            [temDic setValue:responseObj[@"path"] forKey:@"url"];
            [temDic setValue:contentDic[@"name"] forKey:@"name"];
            [temDic setValue:dic[@"duration"] forKey:@"time"];
            [temDic setValue:@"0" forKey:@"rest"];
            NSLog(@"111:%@", temDic);
            [self.videoUrlArr addObject:temDic];
            self.index ++;
            if (self.index == self.actionArr.count) {
                NSLog(@"下载完成");
                [self jumpController];
            } else {
                if (!self.signExitFlag) {
                    NSDictionary *dic = self.actionArr[self.index];
                    NSDictionary *contentDic = dic[@"courseAction"];
                    if ([contentDic[@"rest"] integerValue] == 1) {
                        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
                        [temDic setValue:contentDic[@"actionId"] forKey:@"actionId"];
                        [temDic setValue:@"" forKey:@"url"];
                        [temDic setValue:contentDic[@"name"] forKey:@"name"];
                        [temDic setValue:dic[@"duration"] forKey:@"time"];
                        [temDic setValue:@"1" forKey:@"rest"];
                        [self.videoUrlArr addObject:temDic];
                        self.index ++;
                        if (self.index == self.actionArr.count) {
                            NSLog(@"下载完成");
                            [self jumpController];
                        } else {
                            NSDictionary *tem = self.actionArr[self.index];
                            [self downloadVideoSource:[self convertVideoUrl:tem]];
                        }
                    } else {
                        [self downloadVideoSource:[self convertVideoUrl:dic]];
                    }
                    
                } else {
                    [self downloadVideoSource:[self convertVideoUrl:dic]];
                }
            }
        } else {
            [self.view makeToast:NSLocalizedString(@"网络已断开,下载资源过程中，请保持网络通畅", nil) duration:2.0 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.middleView.hidden = YES;
                [self.middleView removeFromSuperview];
            });
        }
    }];
}

- (void)jumpController {
    if (!self.signExitFlag) {
        if (self.videoUrlArr.count > 0) {
            [self.middleView fireCustomTimer];
            self.middleView.hidden = YES;
            self.middleView = nil;
            NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
            NSDictionary *parmDic = self.params;
            [temDic setValue:parmDic[@"planId"] forKey:@"planId"];
            [HCRouter router:@"ClassPlay" params:@{@"data":self.videoUrlArr, @"title":temDic} viewController:self animated:YES];
        }
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"课程详情", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleWhite;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (void)compareContentSize:(NSString *)title withFont:(CGFloat)font widthLimited:(CGFloat)limitWidth {
    UIFont *fnt = [UIFont systemFontOfSize:font];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //关键代码
    [paragraphStyle setLineSpacing:8];//设置距离
    NSDictionary *parms = @{NSFontAttributeName:fnt,
                            NSParagraphStyleAttributeName:paragraphStyle
    };
    CGSize postJobSize = [title boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:parms context:nil].size;
    [self.topView.subL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(postJobSize.height);
    }];
//    self.topView.subL.text = title;
    [self.topView.subL setAttributeStringContent:title space:5 font:FONT_SYSTEM(font) alignment:NSTextAlignmentLeft];
    CGFloat height = [self.topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.topView.frame;
    frame.size.height = height;
    self.topView.frame = frame;
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = self.topView;
    [self.tableView endUpdates];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);        
        [_tableView registerClass:[ZCClassDetailActionCell class] forCellReuseIdentifier:@"ZCClassDetailActionCell"];
    }
    return _tableView;
}

- (ZCClassPlayMiddleView *)middleView {
    if (!_middleView) {
        _middleView = [[ZCClassPlayMiddleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    }
    return _middleView;
}

@end
