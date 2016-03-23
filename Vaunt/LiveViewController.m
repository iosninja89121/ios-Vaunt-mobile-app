//
//  LiveViewController.m
//  Vaunt
//
//  Created by Master on 7/2/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "LiveViewController.h"
#import "ChatCell.h"
#import "ChatMessage.h"
#import "DBUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UserInformation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LiveViewController () <UITextFieldDelegate>
{
    NSMutableArray *chatHistory;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarMargin;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[self.section objectForKey:@"isOnline"] boolValue]) {
        [self playVideo];
    }
    
    if (!self.videoURL) {
        [self.imageView setImageWithURL:[NSURL URLWithString:[self.section objectForKey:@"BigImage"]] placeholderImage:nil options:SDWebImageProgressiveDownload usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    chatHistory = [[NSMutableArray alloc] init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didReceivePNMessage:) name:kPNDidReceiveMessageNotification object:nil];
    
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.txtMessage setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _moviePlayer.view.frame = CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height);
    
    self.lblSubscribe.text = [self.section objectForKey:@"subscribeText"];
    self.lblSubscribe.font = [UIFont fontWithName:@"OpenSans" size:12.0];
    self.lblSubscribe.numberOfLines = 0;
    CGSize size = [self.lblSubscribe sizeThatFits:CGSizeMake(self.lblSubscribe.frame.size.width, CGFLOAT_MAX)];
    self.lblSubscribe.frame = CGRectMake(self.lblSubscribe.frame.origin.x, self.lblSubscribe.frame.origin.y, size.width, size.height);
    
    self.lblLive.text = [self.section objectForKey:@"liveText"];
    self.lblLive.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12.0];
    self.lblLive.numberOfLines = 0;
    size = [self.lblLive sizeThatFits:CGSizeMake(self.lblLive.frame.size.width, CGFLOAT_MAX)];
    self.lblLive.frame = CGRectMake(self.lblLive.frame.origin.x, self.lblLive.frame.origin.y, size.width, size.height);
    
    self.lblViewersCount.text = [self.section objectForKey:@"viewers"];
    
    self.countView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:nil name:kPNDidReceiveMessageNotification object:nil];
    
    [center removeObserver:nil name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:nil name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)onbtnBackClicked:(id)sender {
    [_moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [_moviePlayer.view removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playVideo {
    if (!self.videoURL)
        return;
    
    // Play the video from the link
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    [_moviePlayer play];
    [self.videoView addSubview:_moviePlayer.view];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    [_moviePlayer play];
}

#pragma mark -
#pragma mark - TableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIView *contentView = [cell.contentView viewWithTag:100];
    if (contentView != nil) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    contentView = [self getViewFromIndex:indexPath.row withCellWidth:cell.bounds.size.width];
    [cell.contentView addSubview:contentView];
    
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getDimensionForIndex:indexPath.row].height;
}

#pragma mark - Private Methods
- (UIView *)getViewFromIndex:(NSInteger)index withCellWidth:(CGFloat)cellWidth {
    NSInteger count = chatHistory.count;
    ChatMessage *chatMsg = [chatHistory objectAtIndex:count - index - 1];
    
    CGSize cellSize = [self getDimensionForIndex:index];
    CGFloat offset = [self messageLabelWidthDiff:index];
    CGFloat parentViewXCoord = offset - 68;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                                                     cellWidth, 0.0)];
    containerView.tag = 100;
    
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(parentViewXCoord, 5,
                                                                  cellSize.width - parentViewXCoord,
                                                                  cellSize.height - 10)];
    parentView.backgroundColor = [UIColor colorWithRed:62.f/255.f green:62.f/255.f blue:62.f/255.f alpha:1];
    parentView.layer.cornerRadius = 5;
    parentView.layer.masksToBounds = YES;
    [containerView addSubview:parentView];
    
    UIImageView *imvAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    CALayer *imageLayer = imvAvatar.layer;
    [imageLayer setCornerRadius:imvAvatar.frame.size.width / 2];
    [imageLayer setBorderWidth:0.0];
    [imageLayer setMasksToBounds:YES];
    
    imvAvatar.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURL *avatarURL = [NSURL URLWithString:chatMsg.avatar];
    [imvAvatar sd_setImageWithURL:avatarURL placeholderImage:[Utils blankAvatarImage] options:0 progress:nil completed:nil];
    [parentView addSubview:imvAvatar];
    
    UILabel *lblSentTime = [[UILabel alloc] initWithFrame:CGRectMake(parentView.frame.size.width - 8 - 64,
                                                                     5, 64, 15)];
    
    NSInteger timeToken = [chatMsg.sentTime integerValue];
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timeToken / 1000.0];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateformatter stringFromDate:time];
    
    lblSentTime.text = [NSString stringWithFormat:@"sent: %@", timeString];
    lblSentTime.textAlignment = NSTextAlignmentRight;
    lblSentTime.font = [UIFont fontWithName:@"OpenSans" size:10];
    lblSentTime.textColor = [UIColor whiteColor];
    [parentView addSubview:lblSentTime];
    
    UILabel *lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(50, 5,
                                                                    lblSentTime.frame.origin.x - 50,
                                                                     15)];
    lblUsername.text = chatMsg.sender;
    lblUsername.textColor = [UIColor colorWithRed:241.f/255.f green:95.f/255.f blue:42.f/255.f alpha:1];
    lblUsername.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:10];
    [parentView addSubview:lblUsername];
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60, 20,
                                                                    cellSize.width - offset,
                                                                    cellSize.height - 38)];
    lblMessage.text = chatMsg.message;
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
    lblMessage.numberOfLines = 0;
    [parentView addSubview:lblMessage];
    
    return containerView;
}

- (CGSize)getDimensionForIndex:(NSInteger)index  {
    CGFloat offset = [self messageLabelWidthDiff:index];
    
    NSInteger count = chatHistory.count;
    ChatMessage *chatMsg = [chatHistory objectAtIndex:count - index - 1];
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 300.f / 375.f - offset, 0)];
    lblMessage.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
    lblMessage.numberOfLines = 0;
    lblMessage.text = chatMsg.message;
    CGSize size = [lblMessage sizeThatFits:CGSizeMake(self.view.frame.size.width * 300.f / 375.f - offset, CGFLOAT_MAX)];
    //return CGSizeMake(size.width + offset, size.height + 38);
    if (size.width < 100) {
        size.width = 100;
    }
    return CGSizeMake(size.width + offset, size.height + 38);
}

- (CGFloat)messageLabelWidthDiff:(NSInteger)index {
    CGFloat offset = 68;
    if (index % 2 == 1) {
        offset = 78;
    }
    return offset;
}

#pragma mark - Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.bottomBarMargin.constant = keyboardRect.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        [self.txtMessage layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.bottomBarMargin.constant = 5;
    [UIView animateWithDuration:0.2 animations:^{
        [self.txtMessage layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - PubNub Chat
- (void)addMessage:(ChatMessage *)chatMsg {
    [chatHistory insertObject:chatMsg atIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:[chatHistory count] - 1 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)didReceivePNMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    ChatMessage *chatMessage = [userInfo objectForKey:kNUChatMessage];

    //[chatMessage setAvatar:@"4feetunda.png"];
    
    [self addMessage:chatMessage];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.txtMessage == textField) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        ChatMessage *chatMessage = [[ChatMessage alloc] init];
        chatMessage.sender = [[NSUserDefaults standardUserDefaults] objectForKey:kUDEmail];
        chatMessage.message = [textField text];
        chatMessage.avatar = [UserInformation sharedInstance].avatarImage;
        
        NSDictionary *userInfo = @{kNUChatMessage: chatMessage};
        [center postNotificationName:kPNPublishMessageNotification object:nil userInfo:userInfo];
        
        [textField resignFirstResponder];
        [textField setText:@""];
    }
    
    return YES;
}



@end
