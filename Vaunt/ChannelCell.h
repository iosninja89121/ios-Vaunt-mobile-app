//
//  ChannelCell.h
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblChannelName;
@property (weak, nonatomic) IBOutlet UILabel *lblContinue;
@property (weak, nonatomic) IBOutlet UILabel *lblPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFade;
@property (weak, nonatomic) IBOutlet UIImageView *imgLive;

@property (assign, nonatomic) BOOL isLoading;

- (void)loadImage:(NSString*)imgName;


@end
