//
//  ZCClassDetailSimpleCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCClassDetailSimpleCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)classDetailSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
