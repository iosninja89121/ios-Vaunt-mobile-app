//
//  ProfileViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/18/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utils.h"
#import "UserInformation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    NSArray* menuItems;
    UIActionSheet *cameraPopup;
    UIImagePickerController *imagePicker;
    NSArray *cameraPhotoType;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuItems = @[@"profile_image", @"profile_firstname", @"profile_lastname", @"profile_accountname", @"profile_email", @"profile_zipcode"];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
    self.firstNameTxt.leftView = paddingView;
    self.firstNameTxt.leftViewMode = UITextFieldViewModeAlways;
    [self.firstNameTxt setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];

    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
    self.lastNameTxt.leftView = paddingView1;
    self.lastNameTxt.leftViewMode = UITextFieldViewModeAlways;
    [self.lastNameTxt setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
    self.accountNameTxt.leftView = paddingView2;
    self.accountNameTxt.leftViewMode = UITextFieldViewModeAlways;
    [self.accountNameTxt setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
    self.emailTxt.leftView = paddingView3;
    self.emailTxt.leftViewMode = UITextFieldViewModeAlways;
    [self.emailTxt setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
    self.zipCodeTxt.leftView = paddingView4;
    self.zipCodeTxt.leftViewMode = UITextFieldViewModeAlways;
    [self.zipCodeTxt setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width / 2;
    self.avatarView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.avatarView.clipsToBounds = YES;
    
    self.percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(0, 0, self.avatarView.frame.size.width, self.avatarView.frame.size.height)];
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
    
    [self.avatarView addSubview:self.percentageDoughnut];
    
    cameraPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                   @"Take a Photo",
                   @"Select one from Camera Roll",
                   nil];
    cameraPopup.tag = 1;
    
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!imagePicker){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        cameraPhotoType = imagePicker.mediaTypes;
    }

    if (!self.avatarView.image){
        NSString* avatarImageURL = [[UserInformation sharedInstance] avatarImage];
        
        NSLog(@"avatar image URL : %@", avatarImageURL);
        
        if ([avatarImageURL isEqual:[NSNull null]]){
            [self.avatarView setImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        }else{
            [self.avatarView setImageWithURL:[NSURL URLWithString:avatarImageURL] placeholderImage:nil options:SDWebImageProgressiveDownload usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
    }
    
    
    NSString* userEMail     = [[UserInformation sharedInstance] email];
    NSString* userFirstName = [[UserInformation sharedInstance] firstName];
    NSString* userLastName  = [[UserInformation sharedInstance] lastName];
    NSString* userZipCode   = [[UserInformation sharedInstance] zipCode];
    NSString* userAccountName  = [[UserInformation sharedInstance] userAccountName];
    
    [self.firstNameTxt setText:userFirstName];
    [self.lastNameTxt setText: userLastName];
    [self.accountNameTxt setText:userAccountName];
    [self.emailTxt setText:userEMail];
    [self.zipCodeTxt setText:userZipCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toogleUpdate:(id)sender{

    NSString *firstName = [self.firstNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lastName = [self.lastNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [self.emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *accountName = [self.accountNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *zipCode = [self.zipCodeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([firstName isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([lastName isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([email isEqualToString:@""] || ![Utils validateEmail:email]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    if ([accountName isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter valid account name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([zipCode isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter zip code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUDPushDeviceToken];
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    
    UIImage* userAvatarImg = self.avatarView.image;
    if (!userAvatarImg){
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please select avatar image!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [self.firstNameTxt resignFirstResponder];
    [self.lastNameTxt  resignFirstResponder];
    [self.accountNameTxt resignFirstResponder];
    
    
    
    NSMutableDictionary* updateParams = [[NSMutableDictionary alloc]init];

    NSString *authToken = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kUDAuthToken];

    [updateParams setObject:authToken                 forKey:kUDAuthToken];
    [updateParams setObject:firstName                 forKey:USERINFO_FIRSTNAME_KEY];
    [updateParams setObject:lastName                  forKey:USERINFO_LASTNAME_KEY];
    [updateParams setObject:accountName               forKey:USERINFO_USERNAME_KEY];
    [updateParams setObject:zipCode                   forKey:USERINFO_ZIPCODE_KEY];
    

    NSMutableArray *imageData = [[NSMutableArray alloc] init];
    
    NSData *avatarData = UIImageJPEGRepresentation(userAvatarImg, 1.0);
    NSDictionary *avatar = @{@"fileType": @"image", @"name": @"avatar", @"fileName": @"avatar.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
    [imageData addObject:avatar];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ServerConnect sharedManager] UploadFiles:kWSApiUpdate withData:imageData withParams:(NSDictionary*)updateParams onSuccess:^(id json){
        
        int returnCode = (int)[json[kWSApiResponseCode] integerValue];
        NSString *message = json[kWSApiResponseMessage];
        
        NSLog(@"update profile data : %@", json);
        
        if (returnCode == SUCCESS_CODE) {
            
            NSDictionary* profileParams = @{@"auth_token" : authToken};
            
            [[ServerConnect sharedManager] POST:kWSApiProfile withParams:profileParams onSuccess:^(id json){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[UserInformation sharedInstance] setAuthTokenKey:authToken];
                [[UserInformation sharedInstance] setInformation:json];
                
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] email] forKey:kUDEmail];
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] authTokenKey] forKey:kUDAuthToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } onFailure:^(NSInteger statusCode, id json){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSLog(@"faield to get the user profile information!");
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SHAlertHelper showOkAlertWithMessage:message];
        }
    }onFailure:^(NSInteger statusCode, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SHAlertHelper showOkAlertWithMessage:@"Failed to update the profile"];
    }];
}

- (IBAction)toogleMenuBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)toggleChangeAvatar:(id)sender{
    [cameraPopup showInView:[UIApplication sharedApplication].keyWindow];
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

- (void)saveImage:(UIImage *)image
{
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    CGRect cropRect = CGRectMake((imageWidth / 2 - CROPIMAGE_SIZE_WIDTH /2), (imageHeight / 2 - CROPIMAGE_SIZE_HEIGHT /2), CROPIMAGE_SIZE_WIDTH, CROPIMAGE_SIZE_HEIGHT);
    
    UIImage* croppedImage = [self getSubImageFrom:image WithRect:cropRect];
    
    [self.avatarView setImage:croppedImage];
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

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
