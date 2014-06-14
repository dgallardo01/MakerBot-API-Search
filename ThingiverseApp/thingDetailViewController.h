//
//  thingDetailViewController.h
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface thingDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailThingTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailThingCreator;
@property (weak, nonatomic) IBOutlet UIImageView *detailBGImageView;
@property (strong, nonatomic) NSNumber *detailThingID;

@end
