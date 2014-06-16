//
//  SearchDisplayTableViewController.m
//  ThingiverseApp
//
//  Created by Danny on 6/4/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "SearchDisplayTableViewController.h"
#import "NewThing.h"
#import "ThingiverseAPIClient.h"
#import "thingDetailViewController.h"
#import "SearchTableViewCell.h"
#import "ImageFilter.h"

@interface SearchDisplayTableViewController ()

@property (strong, nonatomic) NSArray *things;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) ThingiverseAPIClient *apiClient;
@property (strong, nonatomic) ImageFilter *imageFilter;

@end

@implementation SearchDisplayTableViewController

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
    
    self.apiClient = [[ThingiverseAPIClient alloc]init];
    self.imageFilter = [ImageFilter new];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    
    searchBar.delegate =self;
    searchBar.placeholder = @"search for a thing";
    [searchBar becomeFirstResponder];
    
    self.navigationItem.titleView = searchBar;
    
    self.things = [[NSArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"searchTableviewCell"  bundle:nil]forCellReuseIdentifier:@"searchCell"];
    
    self.tableView.rowHeight = 80.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"searchTableviewCell"  bundle:nil]forCellReuseIdentifier:@"searchCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    }
    
    // Configure the cell...
    if ([self.things count] >0) {
        NewThing *singleThing = [self.things objectAtIndex:indexPath.row];
        cell.searchCellLabel.text = singleThing.thingName;
        //        cell.detailTextLabel.text = singleThing.creatorName;
        cell.searchCellImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", singleThing.thingThumbnail]]]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    thingDetailViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"thingDetail"];
    
    if ([self.things count] >0) {
        NewThing *singleThing = [self.things objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            detailVC.detailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", singleThing.thingThumbnail]]]];
            detailVC.detailBGImageView.image = [self.imageFilter filterImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", singleThing.thingThumbnail]]]]];
            detailVC.detailThingTitle.text = singleThing.thingName;
            detailVC.detailThingCreator.text = singleThing.creatorName;
            
        });
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Search Bar delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *pattern = @"\\s";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSString *newSearchText = [regex stringByReplacingMatchesInString:searchText options:0 range:NSMakeRange(0, [searchText length]) withTemplate:@"+"];
    [self.apiClient searchforThing:newSearchText withCompletion:^(NSArray *things) {
        self.things = things;
        if ([self.things count]>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSLog(@"api reload tableivew");
            });
        }
    }];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    searchBar.showsCancelButton = YES;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    self.things = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    [self.navigationItem setHidesBackButton:NO animated:YES];

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

@end
