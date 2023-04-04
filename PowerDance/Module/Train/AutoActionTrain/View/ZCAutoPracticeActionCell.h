//
//  ZCAutoPracticeActionCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoPracticeActionCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)autoPracticeActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
