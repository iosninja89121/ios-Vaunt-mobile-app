//
//  LiveTrialViewController.m
//  Vaunt
//
//  Created by Master on 7/2/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "LiveTrialViewController.h"
#import "LiveViewController.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface LiveTrialViewController () 

@end

@implementation LiveTrialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self.section objectForKey:@"isOnline"] boolValue]) {
        //[self playVideo];
    }
    
    [self.imageView setAlpha:0.0];
    [self.imgPlaceHolder setAlpha:1.0];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.section objectForKey:@"BigImage"]] placeholderImage:nil options:0 completed:^(UIImage *image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL){

        [self.imgPlaceHolder setAlpha:0.0];
        
        if (cacheType == SDImageCacheTypeNone){
            [UIView transitionWithView:self.imageView duration:3.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.imageView setAlpha:1.0];
            }completion:nil];
        }else{
            [self.imageView setAlpha:1.0];
        }
        
    }];
    
    
    [self.imvThumb setImageWithURL:[NSURL URLWithString:[self.section objectForKey:@"CoverImage"]] placeholderImage:nil options:SDWebImageProgressiveDownload usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    self.lblName.text = [[self.section objectForKey:@"title"] uppercaseString];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height);
    
    self.lblSubscribe.text = [self.section objectForKey:@"subscribeText"];
    self.lblSubscribe.font = [UIFont fontWithName:@"OpenSans" size:12.0];
    self.lblSubscribe.numberOfLines = 0;
    CGSize size = [self.lblSubscribe sizeThatFits:CGSizeMake(self.lblSubscribe.frame.size.width, CGFLOAT_MAX)];
    self.lblSubscribe.frame = CGRectMake(self.lblSubscribe.frame.origin.x, self.lblSubscribe.frame.origin.y, size.width, size.height);
    
    self.lblLive.text = [self.section objectForKey:@"liveText"];
    self.lblLive.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12.0];
    self.lblLive.numberOfLines = 0;
    size = [self.lblLive sizeThatFits:CGSizeMake(self.lblLive.frame.size.width, CGFLOAT_MAX)];
    self.lblLive.frame = CGRectMake(self.lblLive.frame.origin.x, self.lblLive.frame.origin.y, size.width, size.height);
    
    self.lblViewersCount.text = [self.section objectForKey:@"viewers"];
    
    self.countView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtnBackClicked:(id)sender {
    [_moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [_moviePlayer.view removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubscribeClicked:(id)sender {
    LiveViewController *liveVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveVC"];
    [liveVC setSection:self.section];
    [liveVC setVideoURL:self.videoURL];
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)playVideo {
    if (!self.videoURL)
        return;
    
    // Play the video from the link
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    [_moviePlayer play];
    [self.videoView addSubview:_moviePlayer.view];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    [_moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [_moviePlayer.view removeFromSuperview];
}

@end
