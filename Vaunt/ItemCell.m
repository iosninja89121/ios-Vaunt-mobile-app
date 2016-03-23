//
//  ItemCell.m
//  Vaunt
//
//  Created by Master on 7/7/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.photoContainerView = [[UIView alloc] init];
        self.photoContainerView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoContainerView];
        
        self.imvPlaceHolder = [[UIImageView alloc] init];
        [self.photoContainerView addSubview:self.imvPlaceHolder];
        
        self.imvPhoto = [[UIImageView alloc] init];
        [self.photoContainerView addSubview:self.imvPhoto];
        
        self.btnPlay = [[UIButton alloc] init];
        self.btnPlay.alpha = 0.7;
        [self.btnPlay setImage:[UIImage imageNamed:@"vaunt_next_button_white"] forState:UIControlStateNormal];
        [self.photoContainerView addSubview:self.btnPlay];
        
        self.lblImageText = [[UILabel alloc] init];
        self.lblImageText.textAlignment = NSTextAlignmentCenter;
        self.lblImageText.numberOfLines = 0;
        self.lblImageText.textColor = [UIColor whiteColor];
        self.lblImageText.font = [UIFont fontWithName:@"OpenSans" size:13.0];
        [self.photoContainerView addSubview:self.lblImageText];
        
        self.titleView = [[UIView alloc] init];
        [self.contentView addSubview:self.titleView];
        
        self.lblTitle = [[UILabel alloc] init];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0];
        [self.titleView addSubview:self.lblTitle];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
        [self.titleView addSubview:self.separatorView];
        
        self.imvArrow = [[UIImageView alloc] init];
        self.imvArrow.image = [UIImage imageNamed:@"vaunt_triangle_trans"];
        [self.titleView addSubview:self.imvArrow];
        
        self.lblTitleDescription =  [[UILabel alloc] init];
        self.lblTitleDescription.textAlignment = NSTextAlignmentCenter;
        self.lblTitleDescription.textColor = [UIColor whiteColor];
        self.lblTitleDescription.font = [UIFont fontWithName:@"OpenSans" size:11.0];
        self.lblTitleDescription.numberOfLines = 0;
        [self.titleView addSubview:self.lblTitleDescription];
        
        self.lblText = [[UILabel alloc] init];
        self.lblText.textAlignment = NSTextAlignmentCenter;
        self.lblText.textColor = [UIColor whiteColor];
        self.lblText.font = [UIFont fontWithName:@"OpenSans" size:12.0];
        self.lblText.numberOfLines = 0;
        [self.titleView addSubview:self.lblText];
        
        self.btnWatchNow = [[UIButton alloc] init];
        self.btnWatchNow.layer.masksToBounds = YES;
        self.btnWatchNow.layer.cornerRadius = 18.0;
        self.btnWatchNow.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnWatchNow.layer.borderWidth = 1.0;
        self.btnWatchNow.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
        [self.btnWatchNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnWatchNow setTitle:@"Watch Now" forState:UIControlStateNormal];
        [self.titleView addSubview:self.btnWatchNow];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
