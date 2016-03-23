//
//  WatchViewController.m
//  Vaunt
//
//  Created by PandaSoft on 8/20/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "WatchViewController.h"
#import "DBUtil.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ImageUtil.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "VLCPlaybackController.h"
#import "VLCMovieViewController.h"
#import "VLCPlaybackNavigationController.h"
#import "AppDelegate.h"
#import "WatchListCell.h"
#import "LiveTrialViewController.h"

@interface WatchViewController ()
{
    NSMutableArray* sections;
    BOOL    vodWatchMode;

}
@end

#define CELL_PADDING 15
#define IMAGE_PADDING 15

@implementation WatchViewController
{
    CGFloat heightForImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    heightForImage = ceilf(self.view.bounds.size.width * PROFILE_IMAGE_RATIO);
    
    vodWatchMode = YES;
    
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView  = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toogleMenuBtn:(id)sender{
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)toogleWatchBtn:(id)sender{
    [self.watchListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton  setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    vodWatchMode = YES;
    
    [self.tableView reloadData];
}

- (IBAction)toogleContinueBtn:(id)sender{
    [self.watchListButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.continueButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    vodWatchMode = NO;

    [self.tableView reloadData];
}

- (void)downloadAndPlayVideoAtIndex:(NSInteger)index {
    
    NSMutableArray* arrayList;
    
    if (vodWatchMode){
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kVODWatchList];
    }else{
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kLIVEWatchList];
    }
    
    NSArray *section = (NSArray*)[arrayList objectAtIndex:index];
    NSString* videoURL;
    NSDictionary* itemDict;
    
    for (id item in section){
        itemDict = (NSDictionary*)item;
        NSString* typeString = (NSString*)[itemDict objectForKey:@"type"];
        
        if ([typeString isEqualToString:@"videoCover"]){
            videoURL = (NSString*)[itemDict objectForKey:@"videoURL"];
            break;
        }
    }

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
            
            [self playLiveVideo:writeURL andSection:itemDict];
        });
    } else {
        [self playLiveVideo:nil andSection:itemDict];
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
        self.watchListButton.userInteractionEnabled = NO;
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        self.tapGestureRecognizer.enabled = NO;                 // Enable the tap gesture Recognizer
        self.watchListButton.userInteractionEnabled = YES;
    }
    
    
}

#pragma mark -
#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nTotalCounts;
    NSMutableArray* arrayList;
    
    if (vodWatchMode){
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kVODWatchList];
    }else{
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kLIVEWatchList];
    }

    if (arrayList){
        nTotalCounts = [arrayList count];
    }else{
        nTotalCounts = 0;
    }
    
    if (!nTotalCounts){
        [self.tableView setHidden:YES];
        [self.emptyLabel setHidden:NO];
    }else{
        [self.tableView setHidden:NO];
        [self.emptyLabel setHidden:YES];
    }

    return nTotalCounts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
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
    
    WatchListCell* cell = (WatchListCell*)[tableView dequeueReusableCellWithIdentifier:@"WatchListCell" forIndexPath:indexPath];
    
    NSMutableArray* arrayList;
    
    if (vodWatchMode){
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kVODWatchList];
    }else{
        arrayList = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kLIVEWatchList];
    }

    NSArray *section = (NSArray*)[arrayList objectAtIndex:indexPath.row];
    
    for (id item in section){
        NSDictionary* itemDict = (NSDictionary*)item;
        NSString* typeString = (NSString*)[itemDict objectForKey:@"type"];
        
        if ([typeString isEqualToString:@"title"]){
            [cell.titleLabel setText:[itemDict objectForKey:@"title"]];
            [cell.descriptionLabel setText:[itemDict objectForKey:@"text"]]; 
        }else if ([typeString isEqualToString:@"videoCover"]){
            [cell loadImage:[itemDict objectForKey:@"videoCover"]];
        }
    }
    


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self downloadAndPlayVideoAtIndex:indexPath.row];
}




@end
