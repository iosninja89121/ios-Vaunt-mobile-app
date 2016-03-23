//
//  LiveTrialViewController.h
//  Vaunt
//
//  Created by Master on 7/2/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LiveTrialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgPlaceHolder;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *imvThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLive;
@property (weak, nonatomic) IBOutlet UILabel *lblSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;

@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewersCount;

@property (nonatomic, strong) NSDictionary *section;
@property (nonatomic, strong) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
