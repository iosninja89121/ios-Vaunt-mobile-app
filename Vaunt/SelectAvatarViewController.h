//
//  SelectAvatarViewController.h
//  Vaunt
//
//  Created by PandaSoft on 8/14/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPercentageDoughnutView.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"


@interface SelectAvatarViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,MCPercentageDoughnutViewDataSource, TGCameraDelegate>

@property (nonatomic, weak) IBOutlet UITextField* userNameTextField;
@property (nonatomic, weak) IBOutlet UIImageView* portfolioView;
@property (nonatomic, strong) UIActionSheet *cameraPopup;
@property (strong, nonatomic) MCPercentageDoughnutView *percentageDoughnut;

@end
