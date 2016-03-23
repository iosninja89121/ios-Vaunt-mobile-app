//
//  SelectAvatarViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/14/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "UserInformation.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SelectAvatarViewController ()
- (void)saveImage:(UIImage*)image;

@end

@implementation SelectAvatarViewController
{
    UIImagePickerController *imagePicker;
    NSArray *cameraPhotoType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Circular portfolio view.
    self.portfolioView.layer.cornerRadius = self.portfolioView.frame.size.width / 2;
    self.portfolioView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.portfolioView.clipsToBounds = YES;
    
    self.cameraPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                        @"Take a Picture",
                        @"Select a photo from Cameral Roll",
                        //@"Select a standard portfolio",
                        nil];
    self.cameraPopup.tag = 1;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
    self.userNameTextField.leftView = paddingView;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.userNameTextField setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSString* accountName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAccountName];
    
    if (accountName){
        [self.userNameTextField setText:accountName];
    }
    
    self.percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(0, 0, self.portfolioView.frame.size.width, self.portfolioView.frame.size.height)];
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
    
    [self.portfolioView addSubview:self.percentageDoughnut];
    
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!imagePicker){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        cameraPhotoType = imagePicker.mediaTypes;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImage:(UIImage *)image
{
    [self.portfolioView setImage:image];
}

- (IBAction)toogleSelectAvatar:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.cameraPopup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)toogleBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toogleShowLogIn:(id)sender
{
    
    NSString *userAccountName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([userAccountName isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter user name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    UIImage *userAvatarImg  = (UIImage*)self.portfolioView.image;
    if (!userAvatarImg){
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please select user avatar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSMutableArray *imageData = [[NSMutableArray alloc] init];
    
    NSData *avatarData = UIImageJPEGRepresentation(userAvatarImg, 1.0);
    NSDictionary *avatar = @{@"fileType": @"image", @"name": @"avatar", @"fileName": @"avatar.jpg", @"data": avatarData, @"mimeType": @"image/jpg"};
    [imageData addObject:avatar];


    NSDictionary* updateParams = @{kUDAuthToken : [[UserInformation sharedInstance]authTokenKey], USERINFO_USERNAME_KEY:userAccountName};
    
    NSLog(@"update Params: %@", updateParams);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ServerConnect sharedManager] UploadFiles:kWSApiUpdate withData:imageData withParams:updateParams onSuccess:^(id json){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        int returnCode = (int)[json[kWSApiResponseCode] integerValue];
        NSString *message = json[kWSApiResponseMessage];

        if (returnCode == SUCCESS_CODE) {
            [self performSegueWithIdentifier:@"segueLoginFromAvatar" sender:nil];
        } else {
            [SHAlertHelper showOkAlertWithMessage:message];
        }
   }onFailure:^(NSInteger statusCode, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];

    chosenImage = info[UIImagePickerControllerEditedImage];
    self.portfolioView.image = chosenImage;
    
    [self saveImage:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];

    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
//                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    imagePicker.mediaTypes = cameraPhotoType;
//                    [self presentViewController:imagePicker animated:YES completion:NULL];

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


#pragma mark - percentage delegate
- (UIView*)viewForCenterOfPercentageDoughnutView:(MCPercentageDoughnutView *)pecentageDoughnutView
                                  withCenterView:(UIView *)centerView {
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zaridan.jpg"]];
    //    imageView.frame = centerView.bounds;
    
    return nil;
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
