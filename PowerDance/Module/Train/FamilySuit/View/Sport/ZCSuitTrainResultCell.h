//
//  ZCSuitTrainSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSuitTrainResultCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)suitTrainResultCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
