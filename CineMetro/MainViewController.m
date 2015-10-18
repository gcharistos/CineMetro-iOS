//
//  MainViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "ProfileTableViewController.h"
#import <Pop/POP.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "CDRTranslucentSideBar.h"
#import "LinesPageViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@end

@implementation MainViewController
@synthesize word;
BOOL startFlag;
NSArray *array;
int flag;

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
    
        [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];
    flag = 0;
    
    // Create SideBar and Set Properties
    self.sideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
    self.sideBar.sideBarWidth = 200;
    self.sideBar.delegate = self;
    self.sideBar.tag = 0;
    
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    
    // Create Content of SideBar
    UITableView *tableView = [[UITableView alloc] init];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    v.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:v];
    [tableView setTableFooterView:v];
    
    //If you create UITableViewController and set datasource or delegate to it, don't forget to add childcontroller to this viewController.
    //[[self addChildViewController: @"your view controller"];
    tableView.dataSource = self;
    tableView.delegate = self;
    // Set ContentView in SideBar
    [self.sideBar setContentViewInSideBar:tableView];
    
   

    locale = [[[NSBundle mainBundle] preferredLocalizations]objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *retrieveUser = [userDefaults objectForKey:@"User"];
    NSString *flagstatus = [userDefaults objectForKey:@"flag"];
    counter++; // plus plus counter variable
    array = [NSArray arrayWithObjects:NSLocalizedString(@"navigationTitle",@"word"),NSLocalizedString(@"linesTitle",@"word"),NSLocalizedString(@"aboutFestival",@"word"), nil];
    if(retrieveUser == nil){
        [self.navigationController presentNotification:NSLocalizedString(@"offline",@"word")];

    }
    else  {
        if([flagstatus isEqualToString:@"false"] || counter == 1){
            MBProgressHUD *retrieveProcess = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            retrieveProcess.labelText = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"loginuser",@"word"),retrieveUser];
            retrieveProcess.mode = MBProgressHUDModeIndeterminate;
            [retrieveProcess show:YES];
            flag = 1;
            // retrieve current user
            PFQuery *userQuery = [PFUser query];
            userQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
            [userQuery whereKey:@"username" equalTo:retrieveUser];
            [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                user = [PFUser currentUser];
                [retrieveProcess hide:YES];
                [self.navigationController presentConfirmation:retrieveProcess.labelText];
                [userDefaults setObject:@"true" forKey:@"flag"];
            }];
        }
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeLaunchMap"]){
        // app already launched once ,then not show tutorial page
    }
    else{
        [self performSegueWithIdentifier:@"tutorialSegue" sender:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstTimeLaunchMap"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        

}

#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
        // Right SideBar
        else {
           
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
    }
    
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    [self.sideBar handlePanGestureToShow:recognizer inViewController:self];
    
    // if you have only one sidebar, do like following
    
    // self.sideBar.isCurrentPanGestureTarget = YES;
    //[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)showLogout{
    [self.navigationController presentConfirmation:NSLocalizedString(@"logoutMessage",@"word")];
    
}

-(void)showLogIn{
    [self.navigationController presentConfirmation:NSLocalizedString(@"successfullLogin",@"word")];
}
-(void)showCreateAccount{
    [self presentConfirmation:NSLocalizedString(@"successfullCreate",@"word")];
    
}

- (IBAction)navigationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"navigationSegue" sender:nil];

}

- (IBAction)linesButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"linesSegue" sender:nil];

}

- (IBAction)aboutButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"aboutSegue" sender:nil];

}

- (IBAction)sidebarButtonPressed:(id)sender {
    if(flag == 0){
       [self.sideBar showInViewController:self];
        flag = 1;
    }
    else{
       [self.sideBar dismissAnimated:YES];
        flag = 0;
    }
}

// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // StatuBar Height
        return 20;
    }
    else if (section == 1) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
        clearView.backgroundColor = [UIColor clearColor];
        return clearView;
    }
    else if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.bounds.size.width - 15, 44)];
        UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44, tableView.bounds.size.width, 0.5f)];
        separatorLineView.backgroundColor = [UIColor blackColor];
        [headerView addSubview:separatorLineView];
        label.text = @"SideBar";
        [label setFont:[UIFont boldSystemFontOfSize:20]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.textColor = [UIColor colorWithRed:(143/255.0) green:(1/255.0) blue:(1/255.0) alpha:1.0];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    }
    else if (indexPath.section == 1) {
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.section == 0) {
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"profile",@"word");
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self profileButtonPressed];
    }
}





//log out button pressed . set user to nil
-(void)LogOut{
    user = nil;
    flag = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"User"];
    [userDefaults setObject:@"false" forKey:@"flag"];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    BOOL status;
    switch (myStatus) {
        case NotReachable:{
            status = false;
            break;
        }
        case ReachableViaWWAN:{
            status = true;
            break;
        }
        case ReachableViaWiFi:{
            status = true;
            break;
        }
        default:
            status = false;
            break;
    }
    return  status;
}

-(void) saveProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.username forKey:@"User"];
    [userDefaults setObject:@"true" forKey:@"flag"];
    flag = 1;

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"profileSegue"]){
        ProfileTableViewController *dest = segue.destinationViewController;
        dest.user = user;
    }
    else if([segue.identifier isEqualToString:@"linesSegue" ]){
        LinesPageViewController *dest = segue.destinationViewController;
        [dest initializeView];
    }
   
}


- (IBAction)profileButtonPressed{
    if(user == nil){
        if([self checkForNetwork] == true){
            [self performSegueWithIdentifier:@"ProfileLogin" sender:nil];
        }
        else{
            [self presentErrorMessage:NSLocalizedString(@"loginerror",@"word")];
            
            
        }
    }
    else{
        [self performSegueWithIdentifier:@"profileSegue" sender:nil];
    }
}


#pragma mark -
#pragma mark - CDSideBarController delegate

- (void)menuButtonClicked:(int)index
{
    // Execute what ever you want
}




@end
