//
//  MenuViewController.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "MenuViewController.h"
#import "ChannelSelectionViewController.h"
#import "CourtSideViewController.h"
#import "ProfileListViewController.h"
#import "ModelingViewController.h"

@interface MenuViewController ()
{
    NSArray *menuItems;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    //[button setImage:[UIImage imageNamed:@"vaunt_next_button_white"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(onbtnNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    menuItems = @[@"Live", @"Sports", @"Music", @"Comedy", @"Lifestyle", @"Film", @"Fashion", @"Models", @"Store"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtnNextClicked:(id)sender {
    ChannelSelectionViewController *channelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChannelSelectionVC"];
    [self.navigationController pushViewController:channelVC animated:YES];
}

#pragma mark -
#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    
    label.text = [menuItems objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
        label.textColor = [UIColor whiteColor];
    else
        label.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProfileListViewController *profileListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileListVC"];
        [self.navigationController pushViewController:profileListVC animated:YES];
    } else if (indexPath.row == 1) {
        CourtSideViewController *courtSideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtSideVC"];
        [self.navigationController pushViewController:courtSideVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
