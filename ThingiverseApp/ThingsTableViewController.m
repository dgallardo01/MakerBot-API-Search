//
//  ThingsTableViewController.m
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ThingsTableViewController.h"
#import "ViewController.h"
#import "NewThing.h"
#import "ThingsTableViewCell.h"
#import "thingDetailViewController.h"
#import "ThingiverseAPIClient.h"
#import "SearchDisplayTableViewController.h"

@interface ThingsTableViewController ()

@property (strong, nonatomic) NSArray *things;
@property (strong, nonatomic) NSOperationQueue *apiOperation;
@property (strong, nonatomic) ThingiverseAPIClient *thingiverseAPIClient;
- (IBAction)searchButtonTapped:(id)sender;

@end

@implementation ThingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.thingiverseAPIClient = [[ThingiverseAPIClient alloc]init];
    
    self.tableView.rowHeight = 300.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"thingCell"  bundle:nil]forCellReuseIdentifier:@"thingsCell"];
    self.apiOperation = [[NSOperationQueue alloc]init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"thingiverseAccessToken"];
    
    if(!accessToken){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    else if([self.things count] == 0){
        [self.thingiverseAPIClient getNewestThingsWithCompletion:^(NSArray *things) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.things = things;
                [self.tableView reloadData];
                NSLog(@"api called");
            });
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.things count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thingsCell" forIndexPath:indexPath];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"thingCell"  bundle:nil]forCellReuseIdentifier:@"thingsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"thingsCell"];
    }
    
    // Configure the cell...
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(ThingsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"thingCell"  bundle:nil]forCellReuseIdentifier:@"thingsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"thingCell"];
    }
    
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        NewThing *singleThing = [self.things objectAtIndex:indexPath.row];
        
        cell.thingNameLabel.text = singleThing.thingName;
        cell.thingImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", singleThing.thingThumbnail]]]];
        cell.thingCreatorLabel.text = singleThing.creatorName;
    }];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(ThingsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.thingImageView.image = [UIImage imageNamed:@"placeholder"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0f;
}


#pragma mark - Refresh

- (void) refresh:(UIRefreshControl *)refreshControl{
    [self.thingiverseAPIClient getNewestThingsWithCompletion:^(NSArray *things) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.things = things;
            [self.tableView reloadData];
            NSLog(@"refresh pulled");
        });
    }];
    
    [refreshControl endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    thingDetailViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"thingDetail"];
    
    NewThing *singleThing = [self.things objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        detailVC.detailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", singleThing.thingThumbnail]]]];
        detailVC.detailThingTitle.text = singleThing.thingName;
        detailVC.detailThingCreator.text = singleThing.creatorName;
    });
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (IBAction)searchButtonTapped:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchDisplayTableViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"searchVC2"];
    
//    [self.navigationController presentViewController:searchVC animated:NO completion:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


@end
