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
#import "Reachability.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize user;
@synthesize word;
int loginStatus;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackground.jpg"]];
    if(user == nil){
        UIAlertView *welcomeMessage = [[UIAlertView alloc]initWithTitle:@"Welcome to CineMetro" message:nil delegate:self cancelButtonTitle:@"Offline" otherButtonTitles:@"Log In",@"Sign Up",nil];
        welcomeMessage.tag = 100;
        [welcomeMessage show];
    }

    // Do any additional setup after loading the view.
}

-(void)LogOut{
//log out button pressed . set user to nil
        NSLog(@"YES");
        user = nil;
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
        UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:@"Oops !!" message:@"You Are Currently Offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Log In",@"Sign Up",nil];
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
            UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:@"Oops !!" message:@"You don't have Internet Connection.Please Enable it to Log In " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            nullUser.tag = 400;
            [nullUser show];
        }
    }
    else if(buttonIndex == 2){ // sign up
        if([self checkForNetwork] == true){
            [self performSegueWithIdentifier:@"createAccount" sender:nil];
        }
        else{
            UIAlertView *nullUser = [[UIAlertView alloc]initWithTitle:@"Oops !!" message:@"You don't have Internet Connection.Please Enable it to Sign Up " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            nullUser.tag = 400;
            [nullUser show];
        }

    }
    
    
}
@end
