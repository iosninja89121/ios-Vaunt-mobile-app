//
//  ChannelCell.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ChannelCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@implementation ChannelCell

- (void)awakeFromNib {
    // Initialization code

    self.isLoading = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(NSString *)imgName{
    NSString* imageURL = [NSString stringWithFormat:@"%@/%@/%@.png",kS3AWSImageBaseUrl, kS3CoreImage, imgName];
    NSString* urlTextEscaped = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.imgFade.alpha = 1.0;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlTextEscaped] placeholderImage:nil options:0 completed:^(UIImage *image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL){

        self.imgFade.alpha = 0.0;
        self.imgView.alpha = 0.0;
        if (cacheType == SDImageCacheTypeNone){
            [UIView transitionWithView:self.imgView duration:3.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.imgView setAlpha:1.0];
            }completion:nil];
        }else{
            [self.imgView setAlpha:1.0];
        }
        
    }];
}

@end
