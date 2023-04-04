//
//  ZCGoodsCommentOperateController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/19.
//

#import "ZCGoodsCommentOperateController.h"
#import "ZCBuyGoodsInfoView.h"
#import "ZCGoodScoreView.h"

@interface ZCGoodsCommentOperateController ()<TZImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView       *contentView;
@property (nonatomic,strong) ZCBuyGoodsInfoView *goodsInfoView;
@property (nonatomic,strong) ZCGoodScoreView *scoreView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *imageStrArr;
@property (nonatomic,strong) UIView *picView;
@property (nonatomic, strong) UILabel *placeL;
@property (nonatomic, strong) UITextView *tfView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) CGFloat score;

@end

@implementation ZCGoodsCommentOperateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    self.index = 0;
    self.score = -1;
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.scView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(98));
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    [self.contentView addSubview:self.goodsInfoView];
    self.goodsInfoView.dataDic = self.params[@"data"];
    [self.goodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    self.scoreView = [[ZCGoodScoreView alloc] init];
    self.scoreView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.goodsInfoView.mas_bottom).offset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(114));
    }];
    kweakself(self);
    self.scoreView.saveScoreOperate = ^(CGFloat value) {
        weakself.score = value;
    };
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.scoreView.mas_bottom).offset(15);
        make.height.mas_equalTo(AUTO_MARGIN(334));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"补充说明", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [bottomView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(bottomView).offset(AUTO_MARGIN(20));
    }];
    
    UIView *picView = [[UIView alloc] init];
    self.picView = picView;
    [bottomView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(20);
        make.height.mas_equalTo(80);
    }];
    [self createPicViewSubViews:picView];
    
    UIView *textView = [[UIView alloc] init];
    [bottomView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bottomView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(picView.mas_bottom).offset(20);
        make.height.mas_equalTo(175);
    }];
    [textView setViewBorderWithColor:1 color:rgba(43, 42, 51, 0.1)];
    
    [self createTextViewSubViews:textView];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    [self.view addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    finishBtn.backgroundColor = [ZCConfigColor txtColor];
    [finishBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishOperate) forControlEvents:UIControlEventTouchUpInside];
}
#pragma -- mark 完成
- (void)finishOperate {
    if (self.tfView.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请输入文字内容", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSLog(@"tijiao");
    if (self.dataArr.count > 0) {
        [CFFHud showLoadingWithTitle:@""];
        self.index = 0;
        [self.imageStrArr removeAllObjects];
        [self uploadFacebackPic:self.dataArr];
    } else {
        [self submitFacebackOperate];
    }
}

- (void)submitFacebackOperate {
    if (self.score < 0) {
        [self.view makeToast:NSLocalizedString(@"请打分", nil) duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *dataDic = self.params[@"data"];
    NSArray *productList = dataDic[@"productList"];
    NSString *productId = @"";
    if (productList.count > 0) {
        NSDictionary *dic = productList[0];
        productId = [NSString stringWithFormat:@"%@", checkSafeContent(dic[@"productId"])];
    }
    NSDictionary *dic = @{@"content":checkSafeContent(self.tfView.text),
                          @"fileList":self.imageStrArr,
                          @"outOrderNo":checkSafeContent(dataDic[@"outTradeNo"]),
                          @"productId":productId,
                          @"score":@(self.score)
    };
  
    [ZCShopManage goodsCommentOperate:dic completeHandler:^(id  _Nonnull responseObj) {
        [self dismissStopLoading];       
        if ([responseObj[@"code"] integerValue] == 200) {
            self.callBackBlock(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)dismissStopLoading {

    dispatch_async(dispatch_get_main_queue(), ^{
        [CFFHud stopLoading];
    });
}

- (void)uploadFacebackPic:(NSArray *)array {
    [self uploadOptionWithImage:array[self.index]];
}

- (void)uploadOptionWithImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic = @{@"base64":base64Str};
    [ZCShopManage uploadPictureOperate:dic completeHandler:^(id  _Nonnull responseObj) {        
        if ([responseObj[@"code"] integerValue] == 200) {
            NSDictionary *dic = @{@"url":checkSafeContent(responseObj[@"data"]),
                                  @"suffix":@".png",
                                  @"fileType":@"1",
                                  @"sort":@(self.index)
            };
            self.index ++;
            [self.imageStrArr addObject:dic];
            if (self.dataArr.count == self.index) {
                [self submitFacebackOperate];
            } else {
                [self uploadFacebackPic:self.dataArr];
            }
        } else {
            [self dismissStopLoading];
        }
    }];
}

- (void)createTextViewSubViews:(UIView *)contentView {
    
    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"文字评价", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(contentView).offset(AUTO_MARGIN(12));
    }];
    
    UITextView *tfView = [[UITextView alloc] init];
    self.tfView = tfView;
    tfView.font = FONT_SYSTEM(15);
    tfView.delegate = self;
    tfView.textColor = [ZCConfigColor txtColor];
    [contentView addSubview:tfView];
    [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
    
    self.placeL = [[UILabel alloc] init];
    self.placeL.font = FONT_SYSTEM(15);
    self.placeL.textColor = RGBA_COLOR(0, 0, 0, 0.5);
    self.placeL.text = NSLocalizedString(@"请填写文字评价，100字以内～", nil);
    [self.placeL setContentLineFeedStyle];
    [contentView addSubview:self.placeL];
    [self.placeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(12));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(18));
    }];
}
#pragma -- mark 添加图片
- (void)resetPicViewSubviews {
    //order_comment_delete
    for (UIView *view in self.picView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat margin = AUTO_MARGIN(10);
    if (self.dataArr.count == 3) {
        for (int i = 0; i < 3; i ++) {
            UIImageView *icon = [[UIImageView alloc] init];
            icon.image = self.dataArr[i];
            icon.contentMode = UIViewContentModeScaleAspectFill;
            icon.clipsToBounds = YES;
            [self.picView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(80);
                make.centerY.mas_equalTo(self.picView.mas_centerY);
                make.leading.mas_equalTo(self.picView.mas_leading).offset((margin+80)*i);
            }];
            [icon setViewCornerRadiu:10];
            icon.tag = i;
            icon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
            [icon addGestureRecognizer:tap];
                       
            UIButton *add = [[UIButton alloc] init];
            [add setImage:kIMAGE(@"order_comment_delete") forState:UIControlStateNormal];
            add.backgroundColor = UIColor.groupTableViewBackgroundColor;
            [icon addSubview:add];
            add.tag = icon.tag;
            [add mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.trailing.mas_equalTo(icon);
                make.height.width.mas_equalTo(20);
            }];
            [add addTarget:self action:@selector(deletePicOperate:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    } else {
        for (int i = 0; i < self.dataArr.count + 1; i ++) {
            if (i == self.dataArr.count) {
                UIButton *add = [[UIButton alloc] init];
                [add setImage:kIMAGE(@"profile_faceback_add") forState:UIControlStateNormal];
                add.backgroundColor = UIColor.groupTableViewBackgroundColor;
                [self.picView addSubview:add];
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(self.picView.mas_leading).offset((margin+80)*i);
                    make.width.height.mas_equalTo(80);
                    make.centerY.mas_equalTo(self.picView.mas_centerY);
                }];
                [add addTarget:self action:@selector(addPicOperate) forControlEvents:UIControlEventTouchUpInside];
            } else {
                UIImageView *icon = [[UIImageView alloc] init];
                icon.image = self.dataArr[i];
                icon.contentMode = UIViewContentModeScaleAspectFill;
                icon.clipsToBounds = YES;
                [self.picView addSubview:icon];
                [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(80);
                    make.centerY.mas_equalTo(self.picView.mas_centerY);
                    make.leading.mas_equalTo(self.picView.mas_leading).offset((margin+80)*i);
                }];
                [icon setViewCornerRadiu:10];
                icon.tag = i;
                icon.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
                [icon addGestureRecognizer:tap];
                
                UIButton *add = [[UIButton alloc] init];
                [add setImage:kIMAGE(@"order_comment_delete") forState:UIControlStateNormal];
                add.backgroundColor = UIColor.groupTableViewBackgroundColor;
                [icon addSubview:add];
                add.tag = icon.tag;
                [add mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.trailing.mas_equalTo(icon);
                    make.height.width.mas_equalTo(20);
                }];
                [add addTarget:self action:@selector(deletePicOperate:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}
#pragma -- mark 删除图片
- (void)deletePicOperate:(UIButton *)sender {
    [self.dataArr removeObjectAtIndex:sender.tag];
    [self resetPicViewSubviews];
}

- (void)iconClick:(UITapGestureRecognizer *)tap {
    XLPhotoBrowser *brower = [XLPhotoBrowser showPhotoBrowserWithImages:self.dataArr currentImageIndex:tap.view.tag];
    
}

- (void)createPicViewSubViews:(UIView *)contentView {
    UIButton *add = [[UIButton alloc] init];
    [add setImage:kIMAGE(@"profile_faceback_add") forState:UIControlStateNormal];
    add.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [contentView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading);
        make.width.height.mas_equalTo(80);
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    [add addTarget:self action:@selector(addPicOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPicOperate {
    TZImagePickerController *pick = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.dataArr.count delegate:self];
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    [self.dataArr addObjectsFromArray:photos];
    [self resetPicViewSubviews];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeL.hidden = NO;
    } else {
        self.placeL.hidden = YES;
    }
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"订单评价", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    self.view.backgroundColor = rgba(246, 246, 246, 1);
}

- (ZCBuyGoodsInfoView *)goodsInfoView {
    if (!_goodsInfoView) {
        _goodsInfoView = [[ZCBuyGoodsInfoView alloc] init];
        _goodsInfoView.backgroundColor = UIColor.whiteColor;
    }
    return _goodsInfoView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)imageStrArr {
    if (!_imageStrArr) {
        _imageStrArr = [NSMutableArray array];
    }
    return _imageStrArr;
}

@end
