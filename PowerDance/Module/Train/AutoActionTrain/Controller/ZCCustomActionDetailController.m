//
//  ZCCustomActionDetailController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/28.
//

#import "ZCCustomActionDetailController.h"
#import "ZCClassDetailActionCell.h"
#import "ZCPhotoManage.h"
#import "ZCClassPlayMiddleView.h"
#import "ZCCustomActionDetailTopView.h"

@interface ZCCustomActionDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) ZCCustomActionDetailTopView *topView;

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

@implementation ZCCustomActionDetailController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NAV_BAR_HEIGHT);
        make.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    self.topView = [[ZCCustomActionDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(350))];
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

    [ZCTrainManage getAutoActionTrainDetailInfo:@{@"id":checkSafeContent(self.params[@"customCourseId"])} completeHandler:^(id  _Nonnull responseObj) {
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
    self.index = 0;
    self.signExitFlag = NO;
    [self.view addSubview:self.middleView];
    self.middleView.hidden = NO;
    self.middleView.iconStr = self.dataDic[@"imgUrl"];
    self.middleView.nameL.text = self.dataDic[@"title"];
    self.videoUrlArr = [NSMutableArray array];
    NSDictionary *dic = self.actionArr[self.index];
    [self downloadVideoSource:[self convertVideoUrl:dic]];
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
        }
    }];
}

- (void)jumpController {
    if (!self.signExitFlag) {
        if (self.videoUrlArr.count > 0) {
            [self.middleView fireCustomTimer];
            self.middleView.hidden = YES;
            self.middleView = nil;
            [HCRouter router:@"ClassPlay" params:@{@"data":self.videoUrlArr, @"title":self.dataDic} viewController:self animated:YES];
        }
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = @"";
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (void)compareContentSize:(NSString *)title withFont:(CGFloat)font widthLimited:(CGFloat)limitWidth {
    UIFont *fnt = [UIFont systemFontOfSize:font];
    CGSize postJobSize = [title boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil].size;
    [self.topView.subL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(postJobSize.height+10);
    }];
    self.topView.subL.text = title;
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
