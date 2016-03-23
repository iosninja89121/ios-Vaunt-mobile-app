//
//  ProfileListViewController.m
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ProfileListViewController.h"
#import "MenuViewController.h"
#import "LiveTrialViewController.h"
#import "ImageUtil.h"
#import "ChannelCell.h"
#import "MBProgressHUD.h"
#import "ChannelSelectionViewController.h"
#import "VLCMovieViewController.h"
#import "VLCPlaybackNavigationController.h"
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


#import "DBUtil.h"

@interface ProfileListViewController () {
    NSArray *sections;
    CGFloat heightForImage;
}

@end

#define CELL_PADDING 15
#define IMAGE_PADDING 15

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (![[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)] isKindOfClass:[ChannelSelectionViewController class]]) {
//        ChannelSelectionViewController *channelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChannelSelectionVC"];
//        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        [vcArray removeObjectAtIndex:vcArray.count - 2];
//        [vcArray insertObject:channelVC atIndex:vcArray.count - 1];
//        self.navigationController.viewControllers = vcArray;
//    }
    
    sections = [[DBUtil sharedInstance] liveProfiles];
    heightForImage = ceilf(self.view.bounds.size.width * PROFILE_IMAGE_RATIO);
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    self.revealViewController.rightViewRevealWidth      = self.view.frame.size.width * SIDEBAR_WIDTH_RATE;
    self.revealViewController.rearViewRevealWidth       = self.view.frame.size.width * SIDEBAR_WIDTH_RATE;
    self.revealViewController.rightViewRevealOverdraw   = self.view.frame.size.width * (1.0f - SIDEBAR_WIDTH_RATE);
    self.revealViewController.rearViewRevealOverdraw    = self.view.frame.size.width * (1.0f - SIDEBAR_WIDTH_RATE);
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(rightRevealToggle:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
    
    self.revealViewController.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self allowRotation:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onbtnMenuClicked:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

#pragma mark -
#pragma mark - TableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sections count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getHeightForSection:[sections objectAtIndex:indexPath.row] withIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIView *contentView = [cell.contentView viewWithTag:100];
    if (contentView != nil) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    contentView = [self getViewFromSection:[sections objectAtIndex:indexPath.row] withIndex:indexPath.row];
    [cell.contentView addSubview:contentView];
    
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self downloadAndPlayVideoAtIndex:indexPath.row];
}

#pragma mark - Private Methods

- (CGFloat)getHeightForSection:(NSDictionary *)section withIndex:(NSInteger)index {

    CGFloat widthForImage = heightForImage;
    
    BOOL isMA = [[section objectForKey:@"isMA"] boolValue];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(widthForImage + CELL_PADDING + IMAGE_PADDING,
                                                                  CELL_PADDING,
                                                                  self.view.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - (CELL_PADDING),
                                                                  10)];
    lblTitle.text = [[section objectForKey:@"title"] uppercaseString];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
    lblTitle.numberOfLines = 0;
    CGSize size = [lblTitle sizeThatFits:CGSizeMake(lblTitle.frame.size.width, CGFLOAT_MAX)];
    lblTitle.frame = CGRectMake(lblTitle.frame.origin.x, lblTitle.frame.origin.y, size.width, size.height + 4.33);
    
    if (lblTitle.frame.size.width > self.view.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - (CELL_PADDING + 60 + (isMA ? 25 : 0))) {
        CGRect frame = lblTitle.frame;
        frame.size.height += 30;
        lblTitle.frame = frame;
    }
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(widthForImage + CELL_PADDING + IMAGE_PADDING,
                                                                 lblTitle.frame.origin.y + lblTitle.frame.size.height + 10,
                                                                 self.view.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - CELL_PADDING,
                                                                 25)];
    lblText.text = [section objectForKey:@"text"];
    lblText.textColor = [UIColor whiteColor];
    lblText.font = [UIFont fontWithName:@"OpenSans" size:10.0];
    lblText.numberOfLines = 0;
    size = [lblText sizeThatFits:CGSizeMake(lblText.frame.size.width, CGFLOAT_MAX)];
    lblText.frame = CGRectMake(lblText.frame.origin.x, lblText.frame.origin.y, size.width, size.height);
    
    if (lblText.frame.origin.y + lblText.frame.size.height > heightForImage + CELL_PADDING) {
        return lblText.frame.origin.y + lblText.frame.size.height + CELL_PADDING;
    } else {
        return heightForImage + CELL_PADDING * 2;
    }
}

- (UIView *)getViewFromSection:(NSDictionary *)section withIndex:(NSInteger)index {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 0.0)];
    containerView.tag = 100;
    

    NSString* imageURL       = (NSString*)[section valueForKey:@"CoverImage"];
    NSString* urlTextEscaped = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    CGFloat widthForImage = heightForImage;
    UIImageView *imvCover = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_PADDING, CELL_PADDING, widthForImage, heightForImage)];

    [imvCover setImageWithURL: [NSURL URLWithString:urlTextEscaped] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    imvCover.clipsToBounds = YES;
    imvCover.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:imvCover];

    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(containerView.frame.size.width - CELL_PADDING - 60,
                                                                   CELL_PADDING, 60, 25)];
    lblStatus.textAlignment = NSTextAlignmentRight;
    lblStatus.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    if ([[section objectForKey:@"isOnline"] boolValue]) {
        lblStatus.text = @"Online";
        lblStatus.textColor = [UIColor greenColor];
    } else {
        lblStatus.text = @"Offline";
        lblStatus.textColor = [UIColor colorWithRed:241.f/255.f green:95.f/255.f blue:42.f/255.f alpha:1];
    }
    [containerView addSubview:lblStatus];
    
    BOOL isMA = [[section objectForKey:@"isMA"] boolValue];
    UIImageView *imvMA = [[UIImageView alloc] initWithFrame:CGRectMake(lblStatus.frame.origin.x - 25,
                                                                       CELL_PADDING,
                                                                       25, 25)];
    [imvMA setHidden:!isMA];
    imvMA.contentMode = UIViewContentModeScaleAspectFit;
    imvMA.image = [UIImage imageNamed:@"ma.png"];
    [containerView addSubview:imvMA];

    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(widthForImage + CELL_PADDING + IMAGE_PADDING,
                                                                  CELL_PADDING,
                                                                  containerView.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - (CELL_PADDING),
                                                                  25)];
    lblTitle.text = [[section objectForKey:@"title"] uppercaseString];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
    lblTitle.numberOfLines = 0;
    CGSize size = [lblTitle sizeThatFits:CGSizeMake(lblTitle.frame.size.width, CGFLOAT_MAX)];
    lblTitle.frame = CGRectMake(lblTitle.frame.origin.x, lblTitle.frame.origin.y, size.width, size.height + 4.33);
    [containerView addSubview:lblTitle];
    
    CGFloat textOffset = lblTitle.frame.origin.y + lblTitle.frame.size.height + 10;
    if (lblTitle.frame.size.width > containerView.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - (CELL_PADDING + lblStatus.frame.size.width + (isMA ? imvMA.frame.size.width : 0))) {
        CGRect frame = lblStatus.frame;
        frame.origin.y = lblTitle.frame.origin.y + lblTitle.frame.size.height + 5;
        lblStatus.frame = frame;
        
        frame = imvMA.frame;
        frame.origin.y = lblTitle.frame.origin.y + lblTitle.frame.size.height + 5;
        imvMA.frame = frame;
        
        textOffset += 30;
    }
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(widthForImage + CELL_PADDING + IMAGE_PADDING,
                                                                 textOffset,
                                                                 containerView.frame.size.width - (widthForImage + CELL_PADDING + IMAGE_PADDING) - CELL_PADDING,
                                                                 25)];
    lblText.text = [section objectForKey:@"text"];
    lblText.textColor = [UIColor whiteColor];
    lblText.font = [UIFont fontWithName:@"OpenSans" size:10.0];
    lblText.numberOfLines = 0;
    size = [lblText sizeThatFits:CGSizeMake(lblText.frame.size.width, CGFLOAT_MAX)];
    lblText.frame = CGRectMake(lblText.frame.origin.x, lblText.frame.origin.y, size.width, size.height);
    [containerView addSubview:lblText];
    
    return containerView;
}

- (void)downloadAndPlayVideoAtIndex:(NSInteger)index {
    NSDictionary *section = [sections objectAtIndex:index];
    NSString *videoURL = [section objectForKey:@"videoURL"];
    if (videoURL != nil && [videoURL length] != 0) {
        NSLog(@"%@", videoURL);
        
        if ([[videoURL substringToIndex:4] isEqualToString:@"rtmp"] || [[videoURL substringFromIndex:[videoURL length] - 4] isEqualToString:@"m3u8"]) {
            [self playVideo:[NSURL URLWithString:videoURL]];
            return;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"live.mp4"];
        NSURL *writeURL = [NSURL fileURLWithPath:path];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
        /* File doesn't exist. Save the image at the path */
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Connecting to Live Stream...";
        //hud.labelColor = [UIColor orangeColor];
        hud.labelFont = [UIFont fontWithName:@"OpenSans" size:16];
        //hud.labelFont = [UIFont systemFontOfSize:16];
        hud.margin = 20.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoURL]];
            [data writeToURL:writeURL atomically:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self playLiveVideo:writeURL andSection:section];
        });
    } else {
        [self playLiveVideo:nil andSection:section];
    }
}

- (void)playLiveVideo:(NSURL *)videoURL andSection:(NSDictionary *)section {
    LiveTrialViewController *liveTrailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveTrialVC"];
    [liveTrailVC setSection:section];
    [liveTrailVC setVideoURL:videoURL];
    [self.navigationController pushViewController:liveTrailVC animated:YES];    
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

- (void)allowRotation:(BOOL)allow
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = allow;
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionRight) {               // Menu will get revealed
        self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
        self.tableView.userInteractionEnabled = NO;
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        self.tapGestureRecognizer.enabled = NO;                 // Enable the tap gesture Recognizer
        self.tableView.userInteractionEnabled = YES;
    }
}

@end
