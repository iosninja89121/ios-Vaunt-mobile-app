//
//  ModelingViewController.h
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ModelingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onbtnBackClicked:(id)sender;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
