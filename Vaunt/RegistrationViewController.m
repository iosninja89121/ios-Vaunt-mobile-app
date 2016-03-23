//
//  RegistrationViewController.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Utils.h"
#import <NSHash/NSString+NSHash.h>
#import "SelectAvatarViewController.h"
#import "UserInformation.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view. vaunt_back_button_white
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    //[button setImage:[UIImage imageNamed:@"vaunt_back_button_white"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(onbtnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // Set TextField layout and placeholder color
    for (int i = 0; i < 6; i++) {
        UITextField *textField;
        if (i == 0)
            textField = self.txtFFirstName;
        else if (i == 1)
            textField = self.txtFLastName;
        else if (i == 2)
            textField = self.txtFEmail;
        else if (i == 3)
            textField = self.txtFPassword;
        else if (i == 4)
            textField = self.txtFConfirmPassword;
        else if (i == 5)
            textField = self.txtFZipCode;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        [textField setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* - (IBAction)onbtnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
} */

- (IBAction)onbtnRegisterClicked:(id)sender {

    NSString *firstName = [self.txtFFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lastName = [self.txtFLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [self.txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.txtFPassword.text;
    NSString *confirmPassword = self.txtFConfirmPassword.text;
    NSString *zipCode = [self.txtFZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
    
    if ([password isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if (password.length < 8 || confirmPassword.length < 8) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Passwords must be at least 8 characters long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Passwords do not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
    
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSString *deviceUid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSMutableDictionary* registrationParams = [[NSMutableDictionary alloc]init];
    [registrationParams setObject:[kWSApiSharedKey SHA256]  forKey:USERINFO_HASH_KEY];
    [registrationParams setObject:firstName                 forKey:USERINFO_FIRSTNAME_KEY];
    [registrationParams setObject:lastName                  forKey:USERINFO_LASTNAME_KEY];
    [registrationParams setObject:email                     forKey:USERINFO_EMAIL_KEY];
    [registrationParams setObject:password                  forKey:USERINFO_PASSWORD_KEY];
    [registrationParams setObject:zipCode                   forKey:USERINFO_ZIPCODE_KEY];
    [registrationParams setObject:deviceToken               forKey:USERINFO_DEVICETOKEN_KEY];
    [registrationParams setObject:deviceModel               forKey:USERINFO_DEVICEMODEL_KEY];
    [registrationParams setObject:deviceUid                 forKey:USERINFO_DEVICEUID_KEY];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ServerConnect sharedManager] POST:kWSApiRegister withParams:(NSDictionary*)registrationParams onSuccess:^(id json){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int returnCode = (int)[json[kWSApiResponseCode] integerValue];
        NSString *message = json[kWSApiResponseMessage];

        if (returnCode == SUCCESS_CODE) {
            NSString* authToken = (NSString*)[json[kWSApiResponseData] objectForKey:kUDAuthToken];
            
            [[UserInformation sharedInstance] setAuthTokenKey:authToken];
            [[UserInformation sharedInstance] setEmail:[registrationParams objectForKey:USERINFO_EMAIL_KEY]];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] email] forKey:kUDEmail];
            [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] authTokenKey] forKey:kUDAuthToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            SelectAvatarViewController *selectAvatarVC = (SelectAvatarViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"selectAvatarVC"];
            [self.navigationController pushViewController:selectAvatarVC animated:YES];

        } else {
            [SHAlertHelper showOkAlertWithMessage:message];
        }
        
    }onFailure:^(NSInteger statusCode, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
}

- (IBAction)onbtnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
