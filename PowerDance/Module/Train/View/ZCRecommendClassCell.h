//
//  ZCRecommendClassCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCRecommendClassCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)recommendClassCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
