//
//  BlueLineTableViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "BlueLineTableViewController.h"
#import "BlueDetailsViewController.h"

@interface BlueLineTableViewController ()

@end

@implementation BlueLineTableViewController
@synthesize lineName;
NSInteger  selectedIndex ;
NSArray *station;
NSMutableArray *titles;


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
    selectedIndex = -1;
    titles = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BlueLineStations" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    station = anns;
    for(int i=0;i<anns.count;i++){
        NSString  *title = [[anns objectAtIndex:i]objectForKey:@"Title"];
        [titles addObject:title];
    }
    [lineName setText:[dict objectForKey:@"Name"]];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
         return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return station.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *namelabel = (UILabel*) [cell viewWithTag:104];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:105];
    UILabel *stationNameLabel = (UILabel*) [cell viewWithTag:106];
    NSArray *imagedictionary = [[station objectAtIndex:indexPath.row]objectForKey:@"Images"];
    NSLog(@"%@",[[imagedictionary objectAtIndex:0]objectForKey:@"Image"]);
    imageview.image = [UIImage imageNamed:[[imagedictionary objectAtIndex:0]objectForKey:@"Image"]];
    namelabel.text = [titles objectAtIndex:indexPath.row];
    stationNameLabel.text = [[station objectAtIndex:indexPath.row]objectForKey:@"Subtitle"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    if([segue.identifier isEqualToString:@"detailSegue"]){
        BlueDetailsViewController *dest = segue.destinationViewController;
        dest.station = [station objectAtIndex:selectedIndex];
        dest.indexPath = selectedIndex;
    }
}


@end
