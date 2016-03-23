//
//  SelectionViewController.m
//  Vaunt
//
//  Created by Master on 7/5/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLive;
@property (weak, nonatomic) IBOutlet UIButton *btnOnDemand;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.btnLive.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnOnDemand.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.btnOnDemand.layer.borderColor = [UIColor colorWithRed:(214.0/255.0) green:(90.0/255.0) blue:(39.0/255.0) alpha:1.0].CGColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
