//
//  ChatCell.h
//  Vaunt
//
//  Created by Master on 7/6/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblSentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end
