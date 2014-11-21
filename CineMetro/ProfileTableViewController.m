//
//  ProfileTableViewController.m
//  CineMetro
//
//  Created by George Haristos on 25/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "MainViewController.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController
@synthesize user;
@synthesize redPoints;
@synthesize greenPoints;
@synthesize bluePoints;
@synthesize pointsLabel;
@synthesize emailLabel;
@synthesize logoutButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];
    UIFont * font = [UIFont boldSystemFontOfSize:20];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [logoutButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    emailLabel.text = [user objectForKey:@"username"];
    pointsLabel.text = [NSString stringWithFormat:@"%@",[user objectForKey:@"totalPoints"]];
    NSString *redlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"redLine"]intValue]];
    redPoints.text = redlinepoints;
    NSString *greenlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"greenLine"]intValue]];
    greenPoints.text = greenlinepoints;
    NSString *bluelinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"blueLine"]intValue]];
    bluePoints.text = bluelinepoints;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0 || section == 1){
        return 1;
    }
    return  3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LogoutPressed:(id)sender {
    MainViewController *dest = (MainViewController *)[[self.navigationController viewControllers]objectAtIndex:0];
    [dest LogOut];

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logged Out" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [dest showLogout];
}
@end
