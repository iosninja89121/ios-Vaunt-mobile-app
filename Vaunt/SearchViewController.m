//
//  SearchViewController.m
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "SearchViewController.h"
#import "MenuViewController.h"
#import "ChannelSelectionViewController.h"
#import "AppDelegate.h"
#import "DBUtil.h"
#import "ImageUtil.h"
#import "MBProgressHUD.h"
#import "VLCMovieViewController.h"
#import "VLCPlaybackController.h"
#import "VLCPlaybackNavigationController.h"
#import "ItemCell.h"

@interface SearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *sections;
    CGFloat heightForImage;
    UILabel *workingLabel;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)] isKindOfClass:[MenuViewController class]]) {
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        ChannelSelectionViewController *channelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChannelSelectionVC"];
        [vcArray removeObjectAtIndex:vcArray.count - 2];
        [vcArray insertObject:channelVC atIndex:vcArray.count - 1];
        self.navigationController.viewControllers = vcArray;
    }
    
    [self.tfKeyword becomeFirstResponder];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    heightForImage = ceilf(self.view.bounds.size.width * IMAGE_RATIO);
    
    workingLabel = [[UILabel alloc] init];
    workingLabel.numberOfLines = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self allowRotation:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
        //if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
        
        //}
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tfKeyword resignFirstResponder];
    
    sections = [[DBUtil sharedInstance] searchItems:self.tfKeyword.text];
    if (sections == nil || [sections count] == 0) {
        [self.lblNotFound setHidden:NO];
    } else {
        [self.lblNotFound setHidden:YES];
    }
    
    [self.tableView reloadData];
    
    return NO;
}

#pragma mark - Private Methods

- (CGFloat)getHeightForItem:(NSDictionary *)itemDict withIndex:(NSInteger)index {
    NSString *type = [itemDict valueForKey:@"type"];
    if ([type isEqualToString:@"coverImage"]) {
        if (index == 0) {
            return heightForImage;
        } else {
            return heightForImage + 60;
        }
    } else if ([type isEqualToString:@"title"]) {
        CGFloat heightForCell = 90;
        if ([itemDict objectForKey:@"titleDescription"] != nil) {
            workingLabel.frame = CGRectMake(10.0, 20.0, self.view.frame.size.width - 20.0, 16.0);
            workingLabel.text = [itemDict objectForKey:@"titleDescription"];
            workingLabel.font = [UIFont fontWithName:@"OpenSans" size:11.0];
            CGSize size = [workingLabel sizeThatFits:CGSizeMake(workingLabel.frame.size.width, CGFLOAT_MAX)];
            heightForCell += 20 + size.height;
        }
        if ([itemDict objectForKey:@"viewTrailer"] != nil) {
            heightForCell += 66;
        }
        if ([itemDict objectForKey:@"text"] != nil) {
            NSString *text = [itemDict valueForKey:@"text"];
            
            workingLabel.frame = CGRectMake(40.0, 30.0, self.view.frame.size.width - 80.0, 10.0);
            workingLabel.text = text;
            workingLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            CGSize size = [workingLabel sizeThatFits:CGSizeMake(workingLabel.frame.size.width, CGFLOAT_MAX)];
            
            heightForCell += 30.0 + size.height + 30.0;
        }
        
        return heightForCell;
    } else if ([type isEqualToString:@"videoCover"]) {
        return heightForImage + 30;
    } else if ([type isEqualToString:@"image"]) {
        return heightForImage + 30;
    }
    
    return 0;
}

- (void)cellLayout:(ItemCell *)cell forItem:(NSDictionary *)itemDict andIndexpath:(NSIndexPath *)indexPath {
    NSString *type = [itemDict valueForKey:@"type"];
    if ([type isEqualToString:@"coverImage"]) {
        cell.titleView.hidden = YES;
        cell.photoContainerView.hidden = NO;
        cell.btnPlay.hidden = YES;
        cell.lblImageText.hidden = YES;
        
        if (indexPath.section == 0) {
            cell.photoContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, heightForImage);
        } else {
            cell.photoContainerView.frame = CGRectMake(0, 60, self.view.frame.size.width, heightForImage);
        }
        
        UIImage *coverImage = [UIImage imageNamed:[itemDict valueForKey:@"coverImage"]];
        cell.imvPhoto.frame = [ImageUtil rectForImage:coverImage andVisibleWidth:self.view.frame.size.width];
        cell.imvPhoto.image = coverImage;
        
    } else if ([type isEqualToString:@"title"]) {
        cell.photoContainerView.hidden = YES;
        cell.titleView.hidden = NO;
        
        NSString *title = [itemDict valueForKey:@"title"];
        cell.lblTitle.frame = CGRectMake(40.0, 30.0, self.view.frame.size.width - 80.0, 30.0);
        cell.lblTitle.text = title;
        cell.separatorView.frame = CGRectMake(0.0, 68.0, title.length * 12.5 > 120.0 ? title.length * 12.5 : 120.0, 2.0);
        cell.separatorView.center = CGPointMake(cell.lblTitle.center.x, cell.separatorView.center.y);
        cell.imvArrow.frame = CGRectMake(0.0, 73.0, 20.0, 17.0);
        cell.imvArrow.center = CGPointMake(cell.lblTitle.center.x, cell.imvArrow.center.y);
        
        CGFloat offsetY = 90;
        if ([itemDict objectForKey:@"titleDescription"] != nil) {
            cell.lblTitleDescription.hidden = NO;
            cell.lblTitleDescription.frame = CGRectMake(10.0, offsetY + 20.0, self.view.frame.size.width - 20.0, 16.0);
            cell.lblTitleDescription.text = [itemDict objectForKey:@"titleDescription"];
            CGSize size = [cell.lblTitleDescription sizeThatFits:CGSizeMake(cell.lblTitleDescription.frame.size.width, CGFLOAT_MAX)];
            cell.lblTitleDescription.frame = CGRectMake(cell.lblTitleDescription.frame.origin.x,
                                                        cell.lblTitleDescription.frame.origin.y,
                                                        cell.lblTitleDescription.frame.size.width,
                                                        size.height);
            
            offsetY += 20.0 + cell.lblTitleDescription.frame.size.height;
        } else {
            cell.lblTitleDescription.hidden = YES;
        }
        
        if ([itemDict objectForKey:@"viewTrailer"] != nil) {
            cell.btnWatchNow.hidden = NO;
            cell.btnWatchNow.frame = CGRectMake(0.0, offsetY + 30.0, 110.0, 36.0);
            cell.btnWatchNow.layer.masksToBounds = YES;
            cell.btnWatchNow.layer.cornerRadius = 18.0;
            cell.btnWatchNow.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.btnWatchNow.layer.borderWidth = 1.0;
            cell.btnWatchNow.center = CGPointMake(cell.separatorView.center.x, cell.btnWatchNow.center.y);
            cell.btnWatchNow.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            [cell.btnWatchNow setTag:(1000 * (indexPath.section + 1)) + indexPath.row];
            
            offsetY += 66.0;
        } else {
            cell.btnWatchNow.hidden = YES;
        }
        
        if ([itemDict objectForKey:@"text"] != nil) {
            cell.lblText.hidden = NO;
            
            NSString *text = [itemDict valueForKey:@"text"];
            cell.lblText.frame = CGRectMake(40.0, offsetY + 30.0, self.view.frame.size.width - 80.0, 10.0);
            cell.lblText.text = text;
            CGSize size = [cell.lblText sizeThatFits:CGSizeMake(cell.lblText.frame.size.width, CGFLOAT_MAX)];
            cell.lblText.frame = CGRectMake(cell.lblText.frame.origin.x, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, size.height);
            
            offsetY += 30.0 + cell.lblText.frame.size.height + 30.0;
        } else {
            cell.lblText.hidden = YES;
        }
        
        cell.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, offsetY);
        
    } else if ([type isEqualToString:@"videoCover"]) {
        cell.titleView.hidden = YES;
        cell.photoContainerView.hidden = NO;
        cell.btnPlay.hidden = NO;
        cell.lblImageText.hidden = YES;
        
        cell.photoContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, heightForImage);
        
        UIImage *coverImage = [UIImage imageNamed:[itemDict valueForKey:@"videoCover"]];
        cell.imvPhoto.frame = [ImageUtil rectForImage:coverImage andVisibleWidth:self.view.frame.size.width];
        cell.imvPhoto.image = coverImage;
        
        cell.btnPlay.frame = CGRectMake(0, 0, 60, 60);
        cell.btnPlay.center = cell.imvPhoto.center;
        cell.btnPlay.tag = (1000 * (indexPath.section + 1)) + indexPath.row;
    } else if ([type isEqualToString:@"image"]) {
        cell.titleView.hidden = YES;
        cell.photoContainerView.hidden = NO;
        cell.btnPlay.hidden = YES;
        
        cell.photoContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width, heightForImage);
        
        UIImage *coverImage = [UIImage imageNamed:[itemDict valueForKey:@"filename"]];
        cell.imvPhoto.frame = [ImageUtil rectForImage:coverImage andVisibleWidth:self.view.frame.size.width];
        cell.imvPhoto.image = coverImage;
        
        NSString *text = [itemDict valueForKey:@"text"];
        if (text) {
            cell.lblImageText.hidden = NO;
            cell.lblImageText.frame = CGRectMake(24.0, 0, self.view.frame.size.width - 48.0, heightForImage);
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
            NSUInteger namePos = [text rangeOfString:@"\r\r"].location;
            if (namePos != NSNotFound) {
                namePos += 2;
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:241/255.0 green:80/255.0 blue:34/255.0 alpha:1.0] range:NSMakeRange(namePos, text.length - namePos)];
            }
            
            [cell.lblImageText setAttributedText:attString];
        } else {
            cell.lblImageText.hidden = YES;
        }
    }
}

#pragma mark -
#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NSArray *section = [sections objectAtIndex:sectionIndex];
    return section.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *section = [sections objectAtIndex:indexPath.section];
    NSDictionary *itemDict = [section objectAtIndex:indexPath.row];
    return [self getHeightForItem:itemDict withIndex:indexPath.section];
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
    static NSString *ItemCellIdentifier = @"ItemCell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier];
    if (cell == nil) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ItemCellIdentifier];
        [cell.btnWatchNow addTarget:self action:@selector(onbtnWatchNowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPlay addTarget:self action:@selector(onbtnPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    NSArray *section = [sections objectAtIndex:indexPath.section];
    NSDictionary *itemDict = [section objectAtIndex:indexPath.row];
    
    [self cellLayout: cell forItem:itemDict andIndexpath:indexPath];
    
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Private Methods

- (IBAction)onbtnWatchNowClicked:(id)sender {
    
    NSInteger tag = [sender tag];
    NSInteger sectionNum = tag / 1000 - 1;
    NSInteger rowNum = tag % 1000;
    NSArray *section = [sections objectAtIndex:sectionNum];
    NSDictionary *itemDict = [section objectAtIndex:rowNum];
    NSString *videoURL = [itemDict valueForKey:@"trailerVideoURL"];
    
    if (videoURL != nil) {
        NSLog(@"%@", videoURL);
        
        [self playVideo:[NSURL URLWithString:videoURL]];
    }
}

- (IBAction)onbtnPlayClicked:(id)sender {
    

    NSInteger tag = [sender tag];
    NSInteger sectionNum = tag / 1000 - 1;
    NSInteger rowNum = tag % 1000;
    NSArray *section = [sections objectAtIndex:sectionNum];
    NSDictionary *itemDict = [section objectAtIndex:rowNum];
    NSString *videoURL = [itemDict valueForKey:@"videoURL"];
    
    if (videoURL != nil) {
        NSLog(@"%@", videoURL);
        
        [self playVideo:[NSURL URLWithString:videoURL]];
    }
}

- (void)playVideo:(NSURL *)videoURL {
    VLCPlaybackController *playbackController = [VLCPlaybackController sharedInstance];
    
    VLCMovieViewController *movieViewController = [[VLCMovieViewController alloc] initWithNibName:nil bundle:nil];
    playbackController.delegate = movieViewController;
    UINavigationController *navCon = [[VLCPlaybackNavigationController alloc] initWithRootViewController:movieViewController];
    [movieViewController prepareForMediaPlayback:playbackController];
    navCon.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:navCon animated:true completion:nil];
    [playbackController setUrl:videoURL];
    [playbackController startPlayback];
    
    // Allow landscape mode
    [self allowRotation:YES];
}

- (void) moviePlayBackDonePressed:(NSNotification*)notification {
    [self allowRotation:NO];
    [_moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:_moviePlayer];
    
    
    if ([_moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [_moviePlayer.view removeFromSuperview];
    }
    _moviePlayer=nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    [self allowRotation:NO];
    [_moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    if ([_moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [_moviePlayer.view removeFromSuperview];
    }
}

- (void)allowRotation:(BOOL)allow
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = allow;
}

@end
