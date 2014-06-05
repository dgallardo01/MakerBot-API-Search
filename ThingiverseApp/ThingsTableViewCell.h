//
//  ThingsTableViewCell.h
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thingImageView;

@property (weak, nonatomic) IBOutlet UILabel *thingNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *thingCreatorLabel;


@end
