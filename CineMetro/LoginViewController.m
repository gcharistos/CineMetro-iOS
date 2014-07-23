//
//  LoginViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize emailTextField;
@synthesize passwordTextField;
PFUser *appUser;

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
    //[super viewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([emailTextField isFirstResponder] && [touch view] != emailTextField) {
        [emailTextField resignFirstResponder];
    }
    else if ([passwordTextField isFirstResponder] && [touch view] != passwordTextField) {
        [passwordTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        MainViewController *dest = (MainViewController *)([navController viewControllers][0]);
     //   MainViewController *dest = segue.destinationViewController;
        dest.user = appUser;
        // [self presentViewController:dest animated:YES completion:NULL];
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:emailTextField.text
                                 password:passwordTextField.text
                                    block:^(PFUser *user, NSError *error){
                                        
                                        if(user){
                                            UIAlertView *alertView = nil;
                                            
                                                                                            // Create an alert view to tell the user
                                                alertView = [[UIAlertView alloc] initWithTitle:@"Successfull Login"
                                                                                       message:nil
                                                                                      delegate:self
                                                                             cancelButtonTitle:nil
                                                                             otherButtonTitles:@"Ok", nil];
                                            // Show the alert view
                                            [alertView show];
                                            appUser = user;
                          //                  NSLog(appUser.username);
                                            [self performSegueWithIdentifier:@"loginSegue" sender:self];
                                        }
                                        else{
                                            UIAlertView *alertView = nil;
                                            
                                            // Create an alert view to tell the user
                                            alertView = [[UIAlertView alloc] initWithTitle:@"Wrong Username Or Password"
                                                                                   message:nil
                                                                                  delegate:self
                                                                         cancelButtonTitle:nil
                                                                         otherButtonTitles:@"Ok", nil];
                                            // Show the alert view
                                            [alertView show];

                                        }
                                    }];
}
@end
