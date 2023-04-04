//
//  ZCTrainSportGroupController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCTrainSportGroupController.h"
#import "ZCSearchTrainTextView.h"
#import "ZCSportGroupTagView.h"
#import "ZCSportGroupModel.h"
#import "ZCAutoActionView.h"
#import "ZCConfigureActionView.h"

@interface ZCTrainSportGroupController ()

@property (nonatomic,strong) ZCSportGroupTagView *tagsView;

@property (nonatomic,strong) NSMutableArray *itemArr;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) ZCSportGroupModel *selectModel;

@property (nonatomic,strong) ZCAutoActionView *autoView;

@property (nonatomic,strong) ZCConfigureActionView *configureView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,assign) NSInteger type;

@end

@implementation ZCTrainSportGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    [self createSubviews];
    
    [self getTrainSportGroupInfo:@""];
}

- (void)createSubviews {
    ZCSearchTrainTextView *textView = [[ZCSearchTrainTextView alloc] init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
//    textView.backgroundColor = [ZCConfigColor bgColor];
    [textView.searchView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [textView.searchView setViewCornerRadiu:AUTO_MARGIN(20)];
    kweakself(self);
    textView.searchTrainResult = ^(NSString * _Nonnull content) {
        [weakself getTrainSportGroupInfo:content];
    };
    
    UIScrollView *scView = [[UIScrollView alloc] init];
    [self.view addSubview:scView];
    [scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(textView.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    [scView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scView);
        make.width.mas_equalTo(scView);
    }];
    
    self.tagsView = [[ZCSportGroupTagView alloc] init];
    self.tagsView.type = 1;
    [contentView addSubview:self.tagsView];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.equalTo(contentView.mas_top);
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    self.tagsView.clickLabelResule = ^(id value) {
        weakself.selectModel = value;
        [weakself showConfigureView];
    };
    
    [self createAddSprotView];
}

- (void)showConfigureView {
    self.type = 1;
    [self.view addSubview:self.maskBtn];
    self.maskBtn.hidden = NO;
    [self.view addSubview:self.configureView];
    if ([self.selectModel.rest integerValue] == 1) {
        self.configureView.restStatus = YES;
    }
    self.configureView.titleL.text = self.selectModel.name;
    self.configureView.energy = self.selectModel.energy;
    [UIView animateWithDuration:0.25 animations:^{
        self.configureView.frame = CGRectMake(0, SCREEN_H-AUTO_MARGIN(276), SCREEN_W, AUTO_MARGIN(276));
    }];
    kweakself(self);
    self.configureView.saveActionTimeOperate = ^(NSDictionary * _Nonnull dic) {
        [weakself maskBtnClick];
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [temDic setValue:weakself.selectModel.name forKey:@"name"];
        [temDic setValue:[NSString stringWithFormat:@"%@", weakself.selectModel.ID] forKey:@"actionId"];
        weakself.callBackBlock(temDic);
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}

- (void)createAddSprotView {
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AUTO_MARGIN(130));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(80));
    }];
    view.layer.backgroundColor = [UIColor colorWithRed:43/255.0 green:42/255.0 blue:51/255.0 alpha:1.0].CGColor;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,10);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 31;
    
    UIButton *addBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"自定义动作", nil) font:14 color:[ZCConfigColor whiteColor]];
    [addBtn setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [addBtn setImage:kIMAGE(@"train_add_nor") forState:UIControlStateNormal];
    [view addSubview:addBtn];
    [addBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:5];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    
    [addBtn addTarget:self action:@selector(addSportOperate) forControlEvents:UIControlEventTouchUpInside];

}

- (void)addSportOperate {
    self.type = 0;
    [self.view addSubview:self.maskBtn];
    self.maskBtn.hidden = NO;
    [self.view addSubview:self.autoView];
    [UIView animateWithDuration:0.25 animations:^{
        self.autoView.frame = CGRectMake(0, SCREEN_H-AUTO_MARGIN(335), SCREEN_W, AUTO_MARGIN(335));
    }];
    kweakself(self);
    self.autoView.saveAutoActionOperate = ^(id  _Nonnull value) {
        NSDictionary *dic = value;
        [weakself maskBtnClick];
        [weakself saveGroupActionOperate:dic];
    };
}

- (void)saveGroupActionOperate:(NSDictionary *)dic {
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parms setValue:@(NO) forKey:@"rest"];
    [ZCTrainManage addTrainActionOpereate:parms completeHandler:^(id  _Nonnull responseObj) {
        [self getTrainSportGroupInfo:@""];
    }];
}

- (void)maskBtnClick {
    self.maskBtn.hidden = YES;
    if (self.type == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.configureView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(276));
        } completion:^(BOOL finished) {
            self.configureView.hidden = YES;
            self.configureView = nil;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.autoView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(335));
        } completion:^(BOOL finished) {
            self.autoView.hidden = YES;
            self.autoView = nil;
        }];
    }
}

- (void)getTrainSportGroupInfo:(NSString *)key {
    NSDictionary *dic = @{@"keyword":key};
    [ZCTrainManage queryTrainActionListInfo:dic completeHandler:^(id  _Nonnull responseObj) {
        self.dataArr = [ZCSportGroupModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tagsView.arrayTags = self.dataArr;
        });
    }];
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"动作库", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;    
}

- (ZCAutoActionView *)autoView {
    if (!_autoView) {
        _autoView = [[ZCAutoActionView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(335))];
        _autoView.backgroundColor = UIColor.whiteColor;
    }
    return _autoView;
}

- (ZCConfigureActionView *)configureView {
    if (!_configureView) {
        _configureView = [[ZCConfigureActionView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, AUTO_MARGIN(276))];
        _configureView.backgroundColor = UIColor.whiteColor;
    }
    return _configureView;
}

@end
