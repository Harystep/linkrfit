//
//  CFFSmartRulerRecordDetailController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import "CFFSmartRulerRecordDetailController.h"
#import "CFFSmartRulerRecordModel.h"
#import "CFFSmartPersonView.h"
#import "CFFSmartRulerDetailTopView.h"
#import "CFFSmartRulerDetailBottomView.h"
#import "CFFSmartRulerTrendView.h"

@interface CFFSmartRulerRecordDetailController ()

@property (nonatomic,strong) CFFSmartRulerRecordModel *model;
@property (nonatomic,strong) CFFSmartRulerDetailTopView *personView;
@property (nonatomic,strong) CFFSmartRulerDetailBottomView *bottomView;
@property (nonatomic,strong) CFFSmartRulerTrendView *lineView;
@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) NSMutableArray *temArr;
@property (nonatomic,strong) UILabel *targetL;

@end

@implementation CFFSmartRulerRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = self.params[@"data"];
    self.temArr = self.params[@"all"];
    self.title = NSLocalizedString(@"详细数据", nil);
    self.needNavBar = YES;
    self.backButtonStyle = CFFBackButtonStyleBlack;
    
    self.scView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scView];
    self.scView.backgroundColor = UIColor.whiteColor;
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.customNavBar.mas_bottom);
    }];
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    [self.contentView addSubview:self.personView];
        
    [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    self.personView.model = self.model;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.personView.mas_bottom).offset(AUTO_MARGIN(-30));
        make.height.mas_equalTo(220+50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    
    self.targetL = [self.view createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"臂", nil), NSLocalizedString(@"(趋势)", nil)] font:16 bold:YES color:kCFF_COLOR_CONTENT_TITLE];
    [bottomView addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(bottomView).inset(AUTO_MARGIN(15));
    }];
    
    CFFSmartRulerTrendView *lineView = [[CFFSmartRulerTrendView alloc] init];
    self.lineView = lineView;
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(bottomView);
        make.top.mas_equalTo(bottomView.mas_top).offset(50);
    }];
    
    [self configUI:0];
}

- (void)routerWithEventName:(NSString *)eventName {
    [self configUI:[eventName integerValue]];
}

- (void)configUI:(NSInteger)index {
    self.lineView.dataArr = [self convertDataArrayWithIndex:index];
    
}

- (NSMutableArray *)convertDataArrayWithIndex:(NSInteger)index {
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *content = @"";
    switch (index) {
        case 0:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.armSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"臂", nil);
        }
            break;
        case 1:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.chestSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"胸", nil);
        }
            break;
        case 2:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.buttocksSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"臀", nil);
        }
            break;
        case 3:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.lowerLegSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"小腿", nil);
        }
            break;
        case 4:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.shoulderSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"肩膀", nil);
        }
            break;
        case 5:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.waistSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"腰", nil);
        }
            break;
        case 6:
        {
            for (CFFSmartRulerRecordModel *model in self.temArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[CFFDataTool reviseString:model.thighSize] forKey:@"weight"];
                [dic setValue:model.createTime forKey:@"createTime"];
                [dataArr addObject:dic];
            }
            content = NSLocalizedString(@"大腿", nil);
        }
            break;
            
        default:
            break;
    }
    self.targetL.text = [NSString stringWithFormat:@"%@%@", content, NSLocalizedString(@"(趋势)", nil)];
    return dataArr;
}

- (CFFSmartRulerDetailTopView *)personView {
    if (!_personView) {
        _personView = [[CFFSmartRulerDetailTopView alloc] init];
        _personView.backgroundColor = [ZCConfigColor bgColor];
    }
    return _personView;
}

@end
