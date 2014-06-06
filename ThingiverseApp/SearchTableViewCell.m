//
//  SearchTableViewCell.m
//  ThingiverseApp
//
//  Created by Danny on 6/6/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    self.searchCellImageView.clipsToBounds = YES;
    self.searchCellImageView.image = placeholder;
    NSLog(@"awake is happening");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
