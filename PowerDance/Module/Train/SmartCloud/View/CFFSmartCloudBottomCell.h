//
//  CFFSmartCloudBottomCell.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartCloudBottomCell : UITableViewCell

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSDictionary *modelDic;

@property (nonatomic,strong) UIImageView *statusIv;

@property (nonatomic,strong) UILabel *precentL;

+ (instancetype)homeDataAnalysisWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
