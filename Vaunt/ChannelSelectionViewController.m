//
//  ChannelSelectionViewController.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ChannelSelectionViewController.h"
#import "MenuViewController.h"
#import "MBProgressHUD.h"
#import "ChannelCell.h"
#import "AppDelegate.h"
#import "VLCPlaybackController.h"
#import "VLCMovieViewController.h"
#import "VLCPlaybackNavigationController.h"
#import "LiveTrialViewController.h"
#import "CourtSideViewController.h"
#import "DBUtil.h"



@interface ChannelSelectionViewController ()
{
    NSArray *channels;
    NSDictionary *videosURLs;
    CGFloat heightForImage;
}

@end

@implementation ChannelSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    channels = @[   @{@"title" : @"Sports: Courtside"},
                    @{@"title" : @"Models: Runway"},
                    @{@"title" : @"Comedy: Kevin Hart", @"liveProfileIndex" : @KEVIN_HART_PROFILE_INDEX},
                    @{@"title" : @"Sports: World Premiere"},
                    @{@"title" : @"Music: Chris Brown", @"liveProfileIndex" : @CHRIS_BROWN_PROFILE_INDEX},
                    @{@"title" : @"Lifestyle: Kendall Jenner", @"liveProfileIndex" : @KENDAL_JENNAR_PROFILE_INDEX},
                    @{@"title" : @"Music: Nicki Minaj"},
                    @{@"title" : @"Fitness: Jen Selter", @"liveProfileIndex" : @JEN_SELTER_PROFILE_INDEX},
                    @{@"title" : @"Lifestyle: Amber Rose", @"liveProfileIndex" : @AMBER_ROSE_PROFILE_INDEX}];

    videosURLs = @{@"Sports: World Premiere"    :   @"https://d1chi1h6fkjwod.cloudfront.net/videos/Neymar+-+The+Boy+From+Santos%E2%84%A2+(Trailer)+By+Daichidapr0+-HD-.mp4"};
    
    heightForImage = ceilf(self.view.bounds.size.width * 0.646);
    
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

- (IBAction)onbtnMenuClicked:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)onbtnSearchClicked:(id)sender {
    
}

- (IBAction)onbtnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return channels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return heightForImage + 55;
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
    
    ChannelCell* cell = (ChannelCell*)[tableView dequeueReusableCellWithIdentifier:@"ChannelIdentifier" forIndexPath:indexPath];

    NSDictionary *channel = [channels objectAtIndex:indexPath.row];
    
    cell.lblContinue.hidden = YES;
    cell.lblPreview.hidden = YES;
    cell.imgArrow.hidden = NO;
    cell.topView.backgroundColor = [UIColor blackColor];
    
    NSString* imageName = [[channel objectForKey:@"title"] stringByReplacingOccurrencesOfString:@":" withString:@" -"];
    [cell loadImage:imageName];
    
    cell.layer.borderWidth = 0;
    
    cell.lblChannelName.text = [channel objectForKey:@"title"];
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    // decide if we need to display the LIVE label
    cell.imgLive.hidden = YES;
    if ([channel objectForKey:@"liveProfileIndex"]) {
        NSInteger profileIndex = [[channel objectForKey:@"liveProfileIndex"] integerValue];
        NSDictionary *section = [[DBUtil sharedInstance].liveProfiles objectAtIndex:profileIndex];
        BOOL isOnline = [[section objectForKey:@"isOnline"] boolValue];
        NSString *videoURL = [section objectForKey:@"videoURL"];
        
        if (isOnline && videoURL && [videoURL length] > 0) {
            // we can assume live if user is online and the live video exists.
            cell.imgLive.hidden = NO;
        }
    }
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *channel = [channels objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        CourtSideViewController *courtSideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtSideVC"];
        [courtSideVC setChannelIndex:0];
        [self.navigationController pushViewController:courtSideVC animated:YES];

    } else if (indexPath.row == 1) {
        CourtSideViewController *courtSideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtSideVC"];
        [courtSideVC setChannelIndex:1];
        [self.navigationController pushViewController:courtSideVC animated:YES];
    
    }else if (indexPath.row == 3) {
        CourtSideViewController *courtSideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtSideVC"];
        [courtSideVC setChannelIndex:2];
        [self.navigationController pushViewController:courtSideVC animated:YES];
    } else if ([channel objectForKey:@"liveProfileIndex"]) {
        NSInteger profileIndex = [[channel objectForKey:@"liveProfileIndex"] integerValue];
        [self downloadAndPlayLiveVideoAtIndex:profileIndex];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - Private Methods

- (void)downloadAndPlayVideoAtIndex:(NSInteger)index {
    NSString *channelName = [[channels objectAtIndex:index] objectForKey:@"title"];
    NSString *videoURL = [videosURLs objectForKey:channelName];
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

- (void)downloadAndPlayLiveVideoAtIndex:(NSInteger)index {
    NSDictionary *section = [[DBUtil sharedInstance].liveProfiles objectAtIndex:index];
    NSString *videoURL = [section objectForKey:@"videoURL"];
    if (videoURL != nil && [videoURL length] != 0) {
//        NSLog(@"%@", videoURL);
//        
//        if ([[videoURL substringToIndex:4] isEqualToString:@"rtmp"] || [[videoURL substringFromIndex:[videoURL length] - 4] isEqualToString:@"m3u8"]) {
//            [self playVideo:[NSURL URLWithString:videoURL]];
//            return;
//        }
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"live.mp4"];
//        NSURL *writeURL = [NSURL fileURLWithPath:path];
//        
//        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
//            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        }
//        
//        /* File doesn't exist. Save the image at the path */
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.labelText = @"Connecting to Live Stream...";
//        //hud.labelColor = [UIColor orangeColor];
//        hud.labelFont = [UIFont fontWithName:@"OpenSans" size:16];
//        //hud.labelFont = [UIFont systemFontOfSize:16];
//        hud.margin = 20.f;
//        hud.yOffset = 0.f;
//        hud.removeFromSuperViewOnHide = YES;
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoURL]];
//            [data writeToURL:writeURL atomically:YES];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            [self playLiveVideo:writeURL andSection:section];
//        });
        [self playLiveVideo:[NSURL URLWithString:videoURL] andSection:section];
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



@end
