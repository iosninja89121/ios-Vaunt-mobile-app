//
//  ViewController.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SplashViewController.h"
#import "ChannelSelectionViewController.h"
#import "UserInformation.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y + 150.0);
    [self.indicatorView startAnimating];
    [self.view addSubview:self.indicatorView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkLogin {
    NSDate *now = [NSDate date];
    NSDate *appLastStartTime = [[NSUserDefaults standardUserDefaults] objectForKey:kUDAppLastStartTime];

    NSString *authToken = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kUDAuthToken];

    [[NSUserDefaults standardUserDefaults] setObject:now forKey:kUDAppLastStartTime];
    if (appLastStartTime != nil) {
        NSTimeInterval systemUptime = [[NSProcessInfo processInfo] systemUptime];
        NSDate *systemLastStartTime = [NSDate dateWithTimeIntervalSinceNow:-systemUptime];
        
        if ([appLastStartTime compare:systemLastStartTime] == NSOrderedAscending) {
            [self goToFirstVC];
            return;
        }
    }
    
    if (authToken == nil || [authToken isEqualToString:@""]) {
        [self performSelector:@selector(goToFirstVC) withObject:nil afterDelay:3.0];
    } else {
        
        NSDictionary *verfiyParams = @{@"auth_token" : authToken};
        
        NSLog(@"Verify Auth Token Params - %@", verfiyParams);

        [[ServerConnect sharedManager] POST:kWSApiVerifyAuthToken withParams:verfiyParams onSuccess:^(id json) {
            NSLog(@"verify json data : %@", json);
            int returnCode = (int)[json[kWSApiResponseCode] integerValue];

            if (returnCode == SUCCESS_CODE) {
                NSDictionary* profileParams = @{@"auth_token" : authToken};
                [[ServerConnect sharedManager] POST:kWSApiProfile withParams:profileParams onSuccess:^(id json){
                    [[UserInformation sharedInstance] setAuthTokenKey:authToken];
                    [[UserInformation sharedInstance] setInformation:json];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] email] forKey:kUDEmail];
                    [[NSUserDefaults standardUserDefaults] setObject:[[UserInformation sharedInstance] authTokenKey] forKey:kUDAuthToken];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    [self performSegueWithIdentifier:@"segueSelectionFromSplash" sender:nil];
                } onFailure:^(NSInteger statusCode, id json){
                    [self goToFirstVC];
                }];
            } else {
                [self goToFirstVC];
            }
        } onFailure:^(NSInteger statusCode, id json) {
            [self goToFirstVC];
        }];
    }
}

- (void)goToFirstVC {
    [self removeInformation];
    [self performSegueWithIdentifier:@"segueFirst" sender:nil];
}

- (void)removeInformation{
    
    [[UserInformation sharedInstance]removeInformation];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDAuthToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
