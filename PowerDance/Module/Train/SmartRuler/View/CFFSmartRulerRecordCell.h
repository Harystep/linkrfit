//
//  CFFSmartRulerRecordCell.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import <UIKit/UIKit.h>
@class CFFSmartRulerRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartRulerRecordCell : UITableViewCell

@property (nonatomic,strong) CFFSmartRulerRecordModel *model;

+ (instancetype)smartRulerRecordCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
