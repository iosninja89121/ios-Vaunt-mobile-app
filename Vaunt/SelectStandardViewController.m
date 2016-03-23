//
//  SelectStandardViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/14/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SelectStandardViewController.h"

@interface SelectStandardViewController ()

@end

@implementation SelectStandardViewController
{
    NSArray* standardPortfolio;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    standardPortfolio = [NSArray arrayWithObjects:@"standard1", @"standard2", @"standard3", @"standard4", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toogleBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return standardPortfolio.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* fileName = @"";
    
    switch (indexPath.row) {
        case 0:
            fileName = @"standard1.png";
            break;
        case 1:
            fileName = @"standard2.png";
            break;
        case 2:
            fileName = @"standard3.png";
            break;
        case 3:
            fileName = @"standard4.png";
            break;
        default:
            break;
    }
    
    UIImage* image = [UIImage imageNamed:fileName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImageName=@"portfolio.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:savedImageName];;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [standardPortfolio objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIView* selectedView = [[UIView alloc]init];
    
    selectedView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
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
