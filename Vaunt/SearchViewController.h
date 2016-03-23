//
//  SearchViewController.h
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfKeyword;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotFound;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
