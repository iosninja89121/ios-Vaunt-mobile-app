//
//  SettingsViewController.h
//  Vaunt
//
//  Created by PandaSoft on 8/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface SettingsViewController : UIViewController <SWRevealViewControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (IBAction)toggleSideBarMenu:(id)sender;
- (IBAction)toggleUpdateProfile:(id)sender;
- (IBAction)toggleAbout:(id)sender; 


@end
