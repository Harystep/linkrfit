//
//  ZCWRCModelSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCWRCModelSimpleCell : UITableViewCell

@property (nonatomic, copy) void (^saveConfigureTrainData)(NSString *content, NSInteger index);

@property (nonatomic, copy) void (^saveRestConfigureTrainData)(NSString *content, NSInteger index);

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) NSInteger signNoEditFlag;

@property (nonatomic,assign) NSInteger showDeleteFlag;

+ (instancetype)wrcModelCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
