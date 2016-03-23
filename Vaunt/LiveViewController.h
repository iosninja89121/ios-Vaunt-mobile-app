//
//  LiveViewController.h
//  Vaunt
//
//  Created by Master on 7/2/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LiveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *lblLive;
@property (weak, nonatomic) IBOutlet UILabel *lblSubscribe;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewersCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;

@property (nonatomic, strong) NSDictionary *section;
@property (nonatomic, strong) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
