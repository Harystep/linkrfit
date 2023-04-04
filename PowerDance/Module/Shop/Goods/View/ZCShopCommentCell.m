//
//  ZCShopCommentCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/15.
//

#import "ZCShopCommentCell.h"
#import "HZPhotoGroup.h"
#import "ZCStarRateView.h"

@interface ZCShopCommentCell ()

@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIView *scoreView;
@property (nonatomic,strong) UILabel *descL;
@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,strong) HZPhotoGroup *groupView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,strong) ZCStarRateView *rateView;

@end

@implementation ZCShopCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)shopCommentCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCShopCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCShopCommentCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
        
    self.detailView = [[UIView alloc] init];
    [self.contentView addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(246, 246, 246, 1);
    [self.detailView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(10));
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    [self.detailView addSubview:self.iconIv];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(AUTO_MARGIN(20));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.width.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(25)];
    
    
    ZCStarRateView *rateView = [[ZCStarRateView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - AUTO_MARGIN(40) - AUTO_MARGIN(120)), AUTO_MARGIN(25), AUTO_MARGIN(120), 15)];
    rateView.rateStyle = HalfStar;
    rateView.isAnimation = YES;
    rateView.currentScore = 4.5;
    self.rateView = rateView;
    [self addSubview:rateView];
    
    self.nameL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"JHON", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.detailView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
    }];

    self.descL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"在中国，几乎百分之80的人去健身房的目的就是为了减肥，到了健身房就盯着跑步机和单车，天天拼命的节食做有氧，等到真正减下去之后就发现自己变成了前平后平，当不做有氧训练恢复饮食之后很快又反弹回去甚至变得更胖。", nil) font:12 bold:NO color:[ZCConfigColor txtColor]];
    self.descL.numberOfLines = 0;
    self.descL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.descL];
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(10));
    }];
    
    self.pictureView = [[UIView alloc] init];
    [self.detailView addSubview:self.pictureView];
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.descL.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(0.1));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(15));
    }];
    self.pictureView.hidden = YES;
    [self.pictureView addSubview:self.groupView];
    
    self.groupView.urlArray = @[
//        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
//        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
//        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg"
    ];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSArray *fileList = dataDic[@"fileList"];
    if (fileList.count > 0) {
        [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((([UIScreen mainScreen].bounds.size.width-AUTO_MARGIN(40)-60)/3.0 + AUTO_MARGIN(10)));
        }];
        [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.pictureView.mas_bottom).inset(AUTO_MARGIN(15));
        }];
        self.pictureView.hidden = NO;
        NSMutableArray *imgArr = [NSMutableArray array];
        for (NSDictionary *item in fileList) {
            [imgArr addObject:item[@"url"]];
        }
        self.groupView.urlArray = imgArr;
    } else {
        [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.1);
        }];
        [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.descL.mas_bottom).inset(AUTO_MARGIN(15));
        }];
        self.pictureView.hidden = YES;
    }
   
    NSDictionary *userDic = dataDic[@"user"];
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(userDic[@"imgUrl"])] placeholderImage:nil];
    self.nameL.text = checkSafeContent(userDic[@"nickName"]);
    self.descL.text = checkSafeContent(dataDic[@"content"]);
    self.rateView.currentScore = [dataDic[@"score"] doubleValue];
    self.rateView.userInteractionEnabled = NO;
}

- (HZPhotoGroup *)groupView{
    if (!_groupView) {
        _groupView = [[HZPhotoGroup alloc] init];
    }
    return _groupView;
}

- (void)setUrlArray:(NSArray<NSString *> *)urlArray{
    
    self.groupView.urlArray = urlArray;
}

@end
