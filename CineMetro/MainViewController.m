//
//  MainViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import <Pop/POP.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize word;
int loginStatus;
int flag;
NSArray *array;

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *retrieveUser = [userDefaults objectForKey:@"User"];
    array = [NSArray arrayWithObjects:NSLocalizedString(@"navigationTitle",@"word"),NSLocalizedString(@"linesTitle",@"word"),NSLocalizedString(@"aboutFestival",@"word"), nil];
    if(retrieveUser == nil && flag == 0){
        UIAlertView *welcomeMessage = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"welcome",@"word") message:nil delegate:self cancelButtonTitle:@"Offline" otherButtonTitles:NSLocalizedString(@"login", @"word"),NSLocalizedString(@"signup",@"word"),nil];
        welcomeMessage.tag = 100;
        [welcomeMessage show];    }
    else {
        MBProgressHUD *retrieveProcess = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        retrieveProcess.labelText = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"loginuser",@"word"),retrieveUser];
        retrieveProcess.mode = MBProgressHUDModeIndeterminate;
        [retrieveProcess show:YES];
        // retrieve current user
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:retrieveUser];
        [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            user = [PFUser currentUser];
            [retrieveProcess hide:YES];
        }];

    }
        

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.view.bounds.size.height == 568){ // iphone 5 - 5s
        return 118.0;
    }
    else if(self.view.bounds.size.height == 667){ // iphone 6
        return 151.0;
    }
    else if(self.view.bounds.size.height == 736){ // iphone 6 plus
        return 175.0;
    }
        
       return 88.0; // iphone 4 - 4s
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:105];
    label.text = [array objectAtIndex:indexPath.row];
    return cell;
}

//selected button from main menu 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"navigationSegue" sender:nil];
    }
    else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"linesSegue" sender:nil];

    }
    else if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"aboutFestivalSegue" sender:nil];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}





//log out button pressed . set user to nil
-(void)LogOut{
    user = nil;
    flag = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"User"];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)redirectToProfile{
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];

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

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"profileSegue"]){
        ProfileViewController *dest = segue.destinationViewController;
        dest.user = user;
    }
    else if([segue.identifier isEqualToString:@"ProfileLogin"]){
        LoginViewController *dest = segue.destinationViewController;
        dest.loginStatus = loginStatus;
    }
}


- (IBAction)profileButtonPressed:(id)sender {
    if(user == nil){
        UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"offline",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:NSLocalizedString(@"login",@"word"),NSLocalizedString(@"signup",@"word"),nil];
        nullUser.tag = 200;
        [nullUser show];
    }
    else{
        [self performSegueWithIdentifier:@"profileSegue" sender:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) // login
    {
        if(alertView.tag == 200){
           loginStatus = 1;
        }
        if([self checkForNetwork] == true){
          [self performSegueWithIdentifier:@"ProfileLogin" sender:nil];
        }
        else{
            UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"loginerror",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil,nil];
            nullUser.tag = 400;
            [nullUser show];
        }
    }
    else if(buttonIndex == 2){ // sign up
        if([self checkForNetwork] == true){
            [self performSegueWithIdentifier:@"createAccount" sender:nil];
        }
        else{
            UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"signuperror",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil,nil];
            nullUser.tag = 400;
            [nullUser show];
        }

    }
    else if(buttonIndex == 3){
        UILabel *label = [[UILabel alloc]init];
        label.text = @"Hello";
        CGFloat toValue = self.view.center.x;
        
        POPSpringAnimation *onscreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        onscreenAnimation.toValue = @(toValue);
        onscreenAnimation.springBounciness = 10.f;
        POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
        offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        offscreenAnimation.toValue = @(-toValue);
        offscreenAnimation.duration = 0.2f;
        [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [label.layer pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
        }];
        [label.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
        
    }
    
    
}


@end
