//
//  CourtSideViewController.h
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CourtSideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (nonatomic, assign) int channelIndex;


@end
