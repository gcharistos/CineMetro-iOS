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
#import <POP.h>
#import "MBProgressHUD.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize loginStatus;
@synthesize okbutton;
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
    [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];

  
 
    
   


    // Do any additional setup after loading the view.
}


-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width,600)];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hideKeyboard:(id)sender {
    [emailTextField resignFirstResponder];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        MainViewController *dest = (MainViewController *)([navController viewControllers][0]);
        user = appUser;
        [dest saveProfile];
        [dest showLogIn];
       

        
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    if([passwordTextField.text length] == 0 || [emailTextField.text length] == 0){
        [self presentNotification:NSLocalizedString(@"fillcreateAccount",@"word")];

        return;
        
    }
    MBProgressHUD *loginAccount = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loginAccount.mode = MBProgressHUDModeIndeterminate;
    [loginAccount show:YES];

    [PFUser logInWithUsernameInBackground:emailTextField.text
                                 password:passwordTextField.text
                                    block:^(PFUser *auser, NSError *error){
                                        
                                        if(auser){

                                            // Show the alert view
                                            appUser = auser;
                                            
                                            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                                            
                                        }
                                        else{
                                            UIAlertView *alertView = nil;
                                          
                                            [self presentErrorMessage:NSLocalizedString(@"wronguser",@"word")];
                                            [loginAccount hide:YES];

                                            // Show the alert view
                                            [alertView show];

                                        }
                                    }];
}

- (IBAction)signupPressed:(id)sender {
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
}
@end
