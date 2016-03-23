//
//  WatchListCell.h
//  Vaunt
//
//  Created by PandaSoft on 9/10/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchListCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView* photoView;
@property(nonatomic, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, weak) IBOutlet UILabel* descriptionLabel;

- (void)loadImage:(NSString *)imgName;

@end
