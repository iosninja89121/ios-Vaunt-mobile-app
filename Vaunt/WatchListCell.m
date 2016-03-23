//
//  WatchListCell.m
//  Vaunt
//
//  Created by PandaSoft on 9/10/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "WatchListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation WatchListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    UIView* backView = [[UIView alloc]init];
    [backView setBackgroundColor:[UIColor clearColor]];
    
    [self setSelectedBackgroundView:backView];
}

- (void)loadImage:(NSString *)imgName{
    self.photoView.alpha = 1.0;
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:nil options:0 completed:^(UIImage *image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL){
        
        self.photoView.alpha = 0.0;

        if (cacheType == SDImageCacheTypeNone){
            [UIView transitionWithView:self.photoView duration:2.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.photoView setAlpha:1.0];
            }completion:nil];
        }else{
            [self.photoView setAlpha:1.0];
        }
    }];
}

@end
