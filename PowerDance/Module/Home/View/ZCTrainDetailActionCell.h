//
//  ZCTrainDetailActionCell.h
//  PowerDance
//
//  Created by PC-N121 on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainDetailActionCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)trainDetailActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
