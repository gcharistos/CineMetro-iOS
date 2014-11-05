//
//  BlueLineTableViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "BlueLineTableViewController.h"
#import "BlueDetailsViewController.h"
#import "MainViewController.h"

@interface BlueLineTableViewController ()

@end

@implementation BlueLineTableViewController
@synthesize nameLabel;

NSMutableArray *titles;
NSArray *station;
NSInteger  selectedIndex ;



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
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar setTintColor:[UIColor blueColor]];

    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setTintColor:[UIColor blueColor]];

    titles = [[NSMutableArray alloc]init];
    selectedIndex = -1;
    NSString *title;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BlueLineStations" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    if([locale isEqualToString:@"el"]){
        [nameLabel setText:[dict objectForKey:@"GrName"]];
    }
    else if([locale isEqualToString:@"en"]){
        [nameLabel setText:[dict objectForKey:@"EnName"]];
    }
    station = anns; // initialize station variable
    for(int i=0;i<anns.count;i++){
        NSString *positionString = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),i+1];
        title = positionString;
        [titles addObject:title];
    }
    
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
    return titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *namelabel = (UILabel*) [cell viewWithTag:105];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:106];
    UILabel *stationNameLabel = (UILabel*) [cell viewWithTag:104];
    UIImage *image = [UIImage imageNamed:[[[station objectAtIndex:indexPath.row]objectForKey:@"Images"]objectAtIndex:0]];
    imageview.image = image;
    namelabel.text = [titles objectAtIndex:indexPath.row];
    if([locale isEqualToString:@"el"]){
        stationNameLabel.text = [[station objectAtIndex:indexPath.row]objectForKey:@"GrSubtitle"];
    }
    else if([locale isEqualToString:@"en"]){
        stationNameLabel.text = [[station objectAtIndex:indexPath.row]objectForKey:@"EnSubtitle"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detailSegue2" sender:nil];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailSegue2"]){
        BlueDetailsViewController *dest = segue.destinationViewController;
        dest.position = selectedIndex;
        
    }}


@end
