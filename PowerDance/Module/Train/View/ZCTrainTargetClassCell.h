//
//  ZCTrainTargetClassCell.h
//  PowerDance
//
//  Created by PC-N121 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTrainTargetClassCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDic;

+ (instancetype)trainTargetClassCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
