//
//  MenuViewCell.h
//  Vaunt
//
//  Created by PandaSoft on 8/13/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewCell : UITableViewCell

+ (CGFloat)cellHeight;

@property(nonatomic, weak) IBOutlet UIImageView* actionIcon;
@property(nonatomic, weak) IBOutlet UILabel* actionTitle;

@end
