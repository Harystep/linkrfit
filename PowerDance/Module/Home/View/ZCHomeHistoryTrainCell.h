//
//  ZCHomeHistoryTrainCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHomeHistoryTrainCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)homeHistoryTrainCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
