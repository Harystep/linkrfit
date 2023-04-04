//
//  ZCAutoWRCModelSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAutoWRCModelSimpleCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)wrcModelCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
