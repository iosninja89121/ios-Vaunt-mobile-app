//
//  ItemCell.h
//  Vaunt
//
//  Created by Master on 7/7/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (nonatomic, strong) UIView *photoContainerView;
@property (nonatomic, strong) UIImageView *imvPhoto;
@property (nonatomic, strong) UIImageView *imvPlaceHolder;

@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UILabel *lblImageText;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIImageView *imvArrow;
@property (nonatomic, strong) UILabel *lblTitleDescription;
@property (nonatomic, strong) UIButton *btnWatchNow;
@property (nonatomic, strong) UILabel *lblText;

@end
