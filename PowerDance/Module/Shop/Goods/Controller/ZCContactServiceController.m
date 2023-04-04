//
//  ZCContactServiceController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import "ZCContactServiceController.h"
#import "ZCTextEnterView.h"
#import "WebSocketManager.h"
#import "ZCChatMessageCell.h"
#import "ZCTextFromMeCell.h"
#import "ZCTextFromOtherCell.h"
#import "ZCPictureFromMeCell.h"
#import "ZCPictureFromOtherCell.h"

@interface ZCContactServiceController ()<UITableViewDelegate, UITableViewDataSource, WebSocketManagerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ZCTextEnterView *enterView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger current;

@end

@implementation ZCContactServiceController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [self signMessageReadedOperate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self setupSubViews];
    
    [[WebSocketManager shared] connectServer];
    [WebSocketManager shared].delegate = self;
    
    [self getMessageListInfo];
}


- (void)setupSubViews {
             
    [self.view addSubview:self.enterView];
    [self.enterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(86) + TAB_SAFE_BOTTOM);
        make.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(self.enterView.mas_top);
    }];
    kweakself(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.current ++;
        [weakself getMoreChatRoomListInfo];
    }];
    
    [self signMessageReadedOperate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSDictionary *fromUser = dic[@"fromUser"];
    
    if ([dic[@"messageType"] integerValue] == 1) {
        if ([fromUser[@"phone"] isEqualToString:kUserInfo.phone]) {
            ZCTextFromMeCell *cell = [ZCTextFromMeCell chatMessageCellWithTableView:tableView idnexPath:indexPath];
            cell.dataDic = self.dataArr[indexPath.row];
            if (indexPath.row > 0) {
                cell.preDic = self.dataArr[indexPath.row - 1];
            }
            return cell;
        } else {
            ZCTextFromOtherCell *cell = [ZCTextFromOtherCell chatMessageCellWithTableView:tableView idnexPath:indexPath];
            cell.dataDic = self.dataArr[indexPath.row];
            if (indexPath.row > 0) {
                cell.preDic = self.dataArr[indexPath.row - 1];
            }
            return cell;
        }
    } else {
        if ([fromUser[@"phone"] isEqualToString:kUserInfo.phone]) {
            ZCPictureFromMeCell *cell = [ZCPictureFromMeCell chatMessageCellWithTableView:tableView idnexPath:indexPath];
            cell.dataDic = self.dataArr[indexPath.row];
            if (indexPath.row > 0) {
                cell.preDic = self.dataArr[indexPath.row - 1];
            }
            return cell;
        } else {
            ZCPictureFromOtherCell *cell = [ZCPictureFromOtherCell chatMessageCellWithTableView:tableView idnexPath:indexPath];
            cell.dataDic = self.dataArr[indexPath.row];
            if (indexPath.row > 0) {
                cell.preDic = self.dataArr[indexPath.row - 1];
            }
            return cell;
        }
    }
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    TZImagePickerController *pick = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    UIImage *theImage = photos[0];
    NSData *imgData = UIImageJPEGRepresentation(theImage, 0.2);
    NSString *base64string = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic = @{@"base64":base64string};
    //[@"data:image/png;base64," stringByAppendingString:base64string]
    [ZCShopManage uploadPictureOperate:dic completeHandler:^(id  _Nonnull responseObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = @{@"messageType":@"img",
                                  @"message":checkSafeContent(responseObj[@"data"]),
            };
            [[WebSocketManager shared] sendDataToServer:[self dictionaryToJson:dic]];
            [self saveSendMessageInfo:@"2" content:checkSafeContent(responseObj[@"data"])];
        });
    }];
}

- (void)getMoreChatRoomListInfo {
    [ZCShopManage getChatRoomListInfo:@{@"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        NSArray *dataArr = responseObj[@"data"][@"records"];
        [self.tableView.mj_header endRefreshing];
        if (dataArr.count > 0) {
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, dataArr.count)];
            [self.dataArr insertObjects:dataArr atIndexes:set];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"count-->%tu", self.dataArr.count);
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }
    }];
}

#pragma -- mark 获取聊天记录
- (void)getMessageListInfo {
    [ZCShopManage getChatRoomListInfo:@{@"current":@(self.current)} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"%@", responseObj);
        [self.dataArr addObjectsFromArray:responseObj[@"data"][@"records"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"count-->%tu", self.dataArr.count);
            [self.tableView reloadData];
            if (self.dataArr.count > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                });
            }

        });
    }];
}

- (void)signMessageReadedOperate {
    [ZCShopManage signChatRoomReadedOperate:@{} completeHandler:^(id  _Nonnull responseObj) {
    }];
}

#pragma -- mark WebSocketDelegate
- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string {
    
    NSLog(@"string---> %@", string);
    NSDictionary *dic = [self jsonToDictionary:string];
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([checkSafeContent(dic[@"messageType"]) isEqualToString:@"img"]) {
        [parm setValue:@"2" forKey:@"messageType"];
    } else {
        [parm setValue:@"1" forKey:@"messageType"];
    }
//    [parm setValue:[NSString getCurrentDate] forKey:@"createTime"];
    [self.dataArr addObject:parm];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.dataArr.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
    });
}

/*
 messageType : text/img
 message : 内容
 */
- (void)routerWithEventName:(NSString *)eventName {
    NSLog(@"%@", eventName);
    NSDictionary *dic = @{@"messageType":@"text",
                          @"message":eventName
    };
    
    [[WebSocketManager shared] sendDataToServer:[self dictionaryToJson:dic]];
    
    [self saveSendMessageInfo:@"1" content:eventName];
}

- (void)saveSendMessageInfo:(NSString *)type content:(NSString *)content {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [contentDic setValue:content forKey:@"message"];
    [contentDic setValue:type forKey:@"messageType"];
    [contentDic setValue:@{@"phone":kUserInfo.phone} forKey:@"fromUser"];
    [contentDic setValue:[NSString getCurrentDate] forKey:@"createTime"];
    [self.dataArr addObject:contentDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.dataArr.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
    });
}

- (NSString *)dictionaryToJson:(NSDictionary*)dic {

    NSError *parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)jsonToDictionary:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return dic;
}


- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.current = 1;
    self.titleStr = NSLocalizedString(@"联系客服", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100.f;
        _tableView.backgroundColor = rgba(246, 246, 246, 1);
        [_tableView registerClass:[ZCTextFromMeCell class] forCellReuseIdentifier:@"ZCTextFromMeCell"];
        [_tableView registerClass:[ZCTextFromOtherCell class] forCellReuseIdentifier:@"ZCTextFromOtherCell"];
        [_tableView registerClass:[ZCPictureFromMeCell class] forCellReuseIdentifier:@"ZCPictureFromMeCell"];
        [_tableView registerClass:[ZCPictureFromOtherCell class] forCellReuseIdentifier:@"ZCPictureFromOtherCell"];
        
    }
    return _tableView;
}

- (ZCTextEnterView *)enterView {
    if (!_enterView) {
        _enterView = [[ZCTextEnterView alloc] init];
    }
    return _enterView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)dealloc {
    NSLog(@"over");
    [[WebSocketManager shared] RMWebSocketClose];
}

@end
