//
//  WatchViewController.h
//  Vaunt
//
//  Created by PandaSoft on 8/20/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface WatchViewController : UIViewController<SWRevealViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UIButton* watchListButton;
@property(nonatomic, weak) IBOutlet UIButton* continueButton;
@property(nonatomic, weak) IBOutlet UITableView* tableView; 
@property(nonatomic, weak) IBOutlet UILabel* emptyLabel;

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


- (IBAction)toogleMenuBtn:(id)sender;
- (IBAction)toogleWatchBtn:(id)sender;
- (IBAction)toogleContinueBtn:(id)sender;

@end
