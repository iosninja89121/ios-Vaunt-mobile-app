//
//  ChannelSelectionViewController.h
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SWRevealViewController.h"

@interface ChannelSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton* sideBarButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;



- (IBAction)onbtnMenuClicked:(id)sender;
- (IBAction)onbtnSearchClicked:(id)sender;
//- (IBAction)onbtnBackClicked:(id)sender;
//- (IBAction)onbtnClicked:(id)sender;

@end
