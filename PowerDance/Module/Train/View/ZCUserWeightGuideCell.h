//
//  ZCUserWeightGuideCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCUserWeightGuideCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) UILabel *numL;

+ (instancetype)userWeightGuideCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
