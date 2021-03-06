//
//  thingDetailViewController.m
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "thingDetailViewController.h"
#import "ThingiverseAPIClient.h"

@interface thingDetailViewController ()

- (IBAction)likeButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation thingDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.topItem.title = @"";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)likeButtonTapped:(id)sender {
    ThingiverseAPIClient *apiClient = [[ThingiverseAPIClient alloc] init];
    
    [apiClient likeAThing:self.detailThingID];
    [self.likeButton setTitle:@"Liked!" forState:UIControlStateNormal];
}


@end
