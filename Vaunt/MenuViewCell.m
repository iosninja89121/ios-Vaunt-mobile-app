//
//  MenuViewCell.m
//  Vaunt
//
//  Created by PandaSoft on 8/13/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "MenuViewCell.h"

@interface MenuViewCell(Private)
+(MenuViewCell *)_cellFromNib;
@end

@implementation MenuViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actionTitle.font = [UIFont fontWithName:@"Open Sans" size:20.0];
}

+(CGFloat)cellHeight{
    static CGFloat sHeight = 0.0f;
    if (sHeight == 0.0f) {
        sHeight = [[self _cellFromNib] frame].size.height;
    }

    return sHeight;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation MenuViewCell (Private)
+ (MenuViewCell*)_cellFromNib {
    NSArray* array;
    
    array = [[NSBundle mainBundle] loadNibNamed:@"MenuViewCell" owner:nil options:nil];
    
    MenuViewCell* cell = (MenuViewCell*)[array lastObject];
    
    return cell;
}

@end