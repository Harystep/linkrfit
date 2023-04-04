//
//  ZCTrainHistoryItemCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainHistoryItemCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)trainHistoryItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
