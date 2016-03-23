//
//  ProfileListViewController.h
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ProfileListViewController : UIViewController <UIGestureRecognizerDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


- (IBAction)onbtnMenuClicked:(id)sender;
@end
