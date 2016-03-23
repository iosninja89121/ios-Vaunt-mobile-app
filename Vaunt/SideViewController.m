//
//  SideViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/13/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SideViewController.h"
#import "SWRevealViewController.h"
#import "ProfileListViewController.h"
#import "MenuViewCell.h"
#import "ChannelSelectionViewController.h"
#import "UserInformation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SideViewController ()

- (void)Initialize;
- (void)saveImage:(UIImage*)image;
- (void)createImageController;
- (void)updateProfile:(UIImage*)image;

@end

@implementation SideViewController
{
    NSArray* actionArray;
    UIImagePickerController *imagePicker;
    NSArray *cameraPhotoType;
    UIActionSheet *cameraPopup;
    int     selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self Initialize];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.photoView.image){
        NSString* avatarImageURL = [[UserInformation sharedInstance] avatarImage];
        
        NSLog(@"avatar image URL : %@", avatarImageURL);
        
        if ([avatarImageURL isEqual:[NSNull null]]){
            [self.photoView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [self.photoView setImageWithURL:[NSURL URLWithString:avatarImageURL] placeholderImage:nil options:SDWebImageProgressiveDownload usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
    }

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toogleAvatarBtn:(id)sender{
    [cameraPopup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
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

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    chosenImage = info[UIImagePickerControllerEditedImage];
    
    [self saveImage:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int actionTagCounts = (int)[actionArray count];
    
    return actionTagCounts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *actionTagItemIdentifire = @"ActionMenuItemCell";
    
    MenuViewCell* menuViewCell = (MenuViewCell*)[tableView dequeueReusableCellWithIdentifier:actionTagItemIdentifire];
    
    if (menuViewCell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuViewCell" owner:self options:nil];
        menuViewCell = [nib objectAtIndex:0];
    }
    
    NSString* actionTitle = [[actionArray objectAtIndex:(indexPath.row)]objectForKey:SIDEBAR_TITLE_TAG];
    NSString* actionIcon  = [[actionArray objectAtIndex:(indexPath.row)]objectForKey:SIDEBAR_ICON_TAG];
    
    if (selectedIndex == indexPath.row){
        [menuViewCell.actionTitle setTextColor:[UIColor whiteColor]];
    }else{
        [menuViewCell.actionTitle setTextColor:[UIColor lightGrayColor]];
    }
    
    [menuViewCell.actionTitle setText:actionTitle];
    [menuViewCell.actionIcon  setImage:[UIImage imageNamed:actionIcon]];

    return menuViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case SIDEBAR_HOME_ITEM:
            [self performSegueWithIdentifier:@"channelSegue" sender:self];
            selectedIndex = SIDEBAR_HOME_ITEM;
            break;
        case SIDEBAR_LIVE_ITEM:
            [self performSegueWithIdentifier:@"liveSegue" sender:self];
            selectedIndex = SIDEBAR_LIVE_ITEM;
            break;
        case SIDEBAR_WATCH_ITEM:
            [self performSegueWithIdentifier:@"watchSegue" sender:self];
            selectedIndex = SIDEBAR_WATCH_ITEM;
            break;
        case SIDEBAR_SETTING_ITEM:
            [self performSegueWithIdentifier:@"settingSegue" sender:self];
            selectedIndex = SIDEBAR_SETTING_ITEM;
            break; 
        case SIDEBAR_LOGOUT_ITEM:
            [SHAlertHelper showOkCancelAlertViewWithTitle:@"Confirmation" message:@"Are you sure you swant to Logout?" onOk:^(void){
                selectedIndex = SIDEBAR_HOME_ITEM;
                [self removeInformation];
                //[[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotify object:nil];
                [self performSegueWithIdentifier:@"splashSegue" sender:self];
            }onCancel:^(void){
                NSLog(@"Cancel operation");
            }];
            break;
    }
    
    [self.menuTableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MenuViewCell cellHeight];
}

#pragma mark - percentage delegate
- (UIView*)viewForCenterOfPercentageDoughnutView:(MCPercentageDoughnutView *)pecentageDoughnutView
                                  withCenterView:(UIView *)centerView {
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zaridan.jpg"]];
//    imageView.frame = centerView.bounds;
    
    return nil;
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];

    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self presentViewController:navigationController animated:YES completion:nil];
                    
                    break;
                case 1:
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = cameraPhotoType;
                    [self presentViewController:imagePicker animated:YES completion:NULL];
                    break;
                default:
                    break;
            }
            
            
            break;
        }
        default:
            break;
    }
}


#pragma mark -
#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    [self saveImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [self saveImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private functions
- (void)Initialize
{
    
    actionArray = @[@{SIDEBAR_TITLE_TAG : SIDEBAR_HOME_TITLE,       SIDEBAR_ICON_TAG : SIDEBAR_HOME_ICON        },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_LIVE_TITLE,       SIDEBAR_ICON_TAG : SIDEBAR_LIVE_ICON        },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_WATCH_TITLE,      SIDEBAR_ICON_TAG : SIDEBAR_WATCH_ICON       },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_DISCOVER_TITLE,   SIDEBAR_ICON_TAG : SIDEBAR_DISCOVER_ICON    },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_BROWSER_TITLE,    SIDEBAR_ICON_TAG : SIDEBAR_BROWSER_ICON     },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_SETTINGS_TITLE,    SIDEBAR_ICON_TAG : SIDEBAR_SETTINGS_ICON     },
                    @{SIDEBAR_TITLE_TAG : SIDEBAR_LOGOUT_TITLE,     SIDEBAR_ICON_TAG : SIDEBAR_LOGOUT_ICON     }];
    
    selectedIndex = 0;
    
    [self.menuTableView.backgroundView setBackgroundColor:[UIColor blackColor]];
    
    
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
    self.photoView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.photoView.clipsToBounds = YES;
    
    self.percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(0, 0, self.photoView.frame.size.width, self.photoView.frame.size.height)];
    self.percentageDoughnut.dataSource              = self;
    self.percentageDoughnut.percentage              = 0.7;
    self.percentageDoughnut.linePercentage          = 0.1;
    self.percentageDoughnut.animationDuration       = 2;
    self.percentageDoughnut.decimalPlaces           = 1;
    self.percentageDoughnut.showTextLabel           = YES;
    self.percentageDoughnut.animatesBegining        = YES;
    self.percentageDoughnut.enableGradient          = NO;
    
    //EB4120
    
    self.percentageDoughnut.fillColor               = UIColorFromRGB(0xf1592a);
    self.percentageDoughnut.unfillColor             = [UIColor darkGrayColor];
    self.percentageDoughnut.textLabel.textColor     = [UIColor blackColor];
    self.percentageDoughnut.textLabel.font          = [UIFont systemFontOfSize:50];
    self.percentageDoughnut.gradientColor1          = UIColorFromRGB(0xf1592a);
    self.percentageDoughnut.gradientColor2          = [UIColor darkGrayColor];
    self.percentageDoughnut.showTextLabel           = NO;
    
    [self.photoView addSubview:self.percentageDoughnut];
    
    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.menuTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.menuTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cameraPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                        @"Take a Photo",
                        @"Select one from Camera Roll",
                        nil];
    cameraPopup.tag = 1;
    
    self.userAccountNameLabel.font = [UIFont fontWithName:@"Open Sans" size:20];
    
    [self performSelectorOnMainThread:@selector(createImageController) withObject:nil waitUntilDone:NO];
    
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];

}

- (void)saveImage:(UIImage *)image
{
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    CGRect cropRect = CGRectMake((imageWidth / 2 - CROPIMAGE_SIZE_WIDTH /2), (imageHeight / 2 - CROPIMAGE_SIZE_HEIGHT /2), CROPIMAGE_SIZE_WIDTH, CROPIMAGE_SIZE_HEIGHT);
    
    UIImage* croppedImage = [self getSubImageFrom:image WithRect:cropRect];
    
    [self.photoView setImage:croppedImage];
    [self updateProfile:croppedImage];
}

- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

- (void)createImageController
{
    if (!imagePicker){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        cameraPhotoType = imagePicker.mediaTypes;
    }
}

- (void)updateProfile:(UIImage *)image
{
    NSMutableArray *imageData = [[NSMutableArray alloc] init];
    
    NSData *avatarData = UIImageJPEGRepresentation(image, 1.0);
    NSDictionary *avatar = @{@"fileType": @"image", @"name": @"avatar", @"fileName": @"avatar.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
    [imageData addObject:avatar];
    
    NSString* authToken = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:kUDAuthToken];
    NSDictionary* updateParams = @{kUDAuthToken : authToken};
    
    [MBProgressHUD showHUDAddedTo:self.photoView animated:YES];

    [[ServerConnect sharedManager] UploadFiles:kWSApiUpdate withData:imageData withParams:(NSDictionary*)updateParams onSuccess:^(id json){

        int returnCode = (int)[json[kWSApiResponseCode] integerValue];
        NSString *message = json[kWSApiResponseMessage];
        
        NSLog(@"update profile data : %@", json);
        
        if (returnCode == SUCCESS_CODE) {
            
            NSDictionary* profileParams = @{@"auth_token" : authToken};
            
            [[ServerConnect sharedManager] POST:kWSApiProfile withParams:profileParams onSuccess:^(id json){
                [MBProgressHUD hideHUDForView:self.photoView animated:YES];
                [[UserInformation sharedInstance] setAuthTokenKey:authToken];
                [[UserInformation sharedInstance] setInformation:json];
                
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] email] forKey:kUDEmail];
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] authTokenKey] forKey:kUDAuthToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } onFailure:^(NSInteger statusCode, id json){
                [MBProgressHUD hideHUDForView:self.photoView animated:YES];

                NSLog(@"faield to get the user profile information!");
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.photoView animated:YES];
            [SHAlertHelper showOkAlertWithMessage:message];
        }
    }onFailure:^(NSInteger statusCode, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [SHAlertHelper showOkAlertWithMessage:@"Failed to update the profile"];
    }];

}


- (void)removeInformation{
    
    [[UserInformation sharedInstance]removeInformation];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDAuthToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
