//
//  LoginViewController.m
//  Vaunt
//
//  Created by Kuznetsov Andrey on 01/08/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import <NSHash/NSString+NSHash.h>
#import "UserInformation.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set TextField layout and placeholder color
    for (int i = 0; i < 2; i++) {
        UITextField *textField;
        if (i == 0)
            textField = self.txtFEmail;
        else if (i == 1)
            textField = self.txtFPassword;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        [textField setValue:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    }

    NSString* userEMail = [[UserInformation sharedInstance] email];
    
    if (userEMail){
        [self.txtFEmail setText:userEMail];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toogleBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onbtnLoginClicked:(id)sender {
    NSString *email = [self.txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = self.txtFPassword.text;
    
    if ([email isEqualToString:@""] || ![Utils validateEmail:email]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([password isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if (password.length < 8) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Password must be at least 8 characters long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUDPushDeviceToken];
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSString *deviceUid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *loginParams = @{USERINFO_EMAIL_KEY                : email,
                                  USERINFO_HASHEDPASSWORK_KEY       : [password SHA256],
                                  USERINFO_DEVICETOKEN_KEY          : deviceToken,
                                  USERINFO_DEVICEMODEL_KEY          : deviceModel,
                                  USERINFO_DEVICEUID_KEY            : deviceUid};
    
    NSLog(@"Login Params - %@", loginParams);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ServerConnect sharedManager] POST:kWSApiLogin withParams:loginParams onSuccess:^(id json) {
        NSLog(@"log in web service result : %@", json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        int returnCode = (int)[json[kWSApiResponseCode] integerValue];

        if (returnCode == SUCCESS_CODE) {
            
            NSString* authToken = (NSString*)[json[kWSApiResponseData] objectForKey:kUDAuthToken];
            NSDictionary* profileParams = @{@"auth_token" : authToken};

            [[ServerConnect sharedManager] POST:kWSApiProfile withParams:profileParams onSuccess:^(id json){
                [[UserInformation sharedInstance] setAuthTokenKey:authToken];
                [[UserInformation sharedInstance] setInformation:json];
                
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] email] forKey:kUDEmail];
                [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] authTokenKey] forKey:kUDAuthToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self performSegueWithIdentifier:@"segueSelection" sender:nil];
            } onFailure:^(NSInteger statusCode, id json){
                NSLog(@"faield to get the user profile information!");
            }];
        } else {
            NSString *message = (NSString*)json[kWSApiResponseMessage];
            [SHAlertHelper showOkAlertWithMessage:message];
        }
    } onFailure:^(NSInteger statusCode, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

@end
