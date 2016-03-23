//
//  ProfileViewController.h
//  Vaunt
//
//  Created by PandaSoft on 8/18/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"


@interface ProfileViewController : UIViewController<UITextFieldDelegate, MCPercentageDoughnutViewDataSource, UIActionSheetDelegate, TGCameraDelegate>

@property(nonatomic, weak)IBOutlet UIImageView* avatarView;

@property(nonatomic, weak) IBOutlet UITextField* firstNameTxt;
@property(nonatomic, weak) IBOutlet UITextField* lastNameTxt;
@property(nonatomic, weak) IBOutlet UITextField* accountNameTxt;
@property(nonatomic, weak) IBOutlet UITextField* emailTxt;
@property(nonatomic, weak) IBOutlet UITextField* zipCodeTxt;

@property(nonatomic, weak) UITextField* activeTextField;

@property(nonatomic, weak) IBOutlet UIScrollView* textView;

@property (strong, nonatomic) MCPercentageDoughnutView *percentageDoughnut;

- (IBAction)toggleChangeAvatar:(id)sender; 

@end
