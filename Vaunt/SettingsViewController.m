//
//  SettingsViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    self.revealViewController.rightViewRevealWidth      = self.view.frame.size.width * SIDEBAR_WIDTH_RATE;
    self.revealViewController.rearViewRevealWidth       = self.view.frame.size.width * SIDEBAR_WIDTH_RATE;
    self.revealViewController.rightViewRevealOverdraw   = self.view.frame.size.width * (1.0f - SIDEBAR_WIDTH_RATE);
    self.revealViewController.rearViewRevealOverdraw    = self.view.frame.size.width * (1.0f - SIDEBAR_WIDTH_RATE);
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(rightRevealToggle:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
    
    self.revealViewController.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Actions
- (IBAction)toggleSideBarMenu:(id)sender{
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)toggleUpdateProfile:(id)sender{
    [self performSegueWithIdentifier:@"segueProfileVC" sender:self];
}

- (IBAction)toggleAbout:(id)sender{
    [self performSegueWithIdentifier:@"segueAboutVC" sender:self];
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionRight) {               // Menu will get revealed
        self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        self.tapGestureRecognizer.enabled = NO;                 // Enable the tap gesture Recognizer
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
