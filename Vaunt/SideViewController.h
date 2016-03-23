//
//  SideViewController.h
//  Vaunt
//
//  Created by PandaSoft on 8/13/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"



@interface SideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MCPercentageDoughnutViewDataSource, UIImagePickerControllerDelegate, UIActionSheetDelegate, TGCameraDelegate>

@property (strong, nonatomic) MCPercentageDoughnutView *percentageDoughnut;

@property(nonatomic, weak) IBOutlet UITableView *menuTableView;
@property(nonatomic, weak) IBOutlet UIImageView *photoView;
@property(nonatomic, weak) IBOutlet UIView* infoView;
@property(nonatomic, weak) IBOutlet UILabel* userAccountNameLabel;


@end
