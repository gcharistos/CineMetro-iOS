//
//  CreateNewAccountViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "CreateNewAccountViewController.h"
#import <Parse/Parse.h>

@interface CreateNewAccountViewController ()

@end

@implementation CreateNewAccountViewController
@synthesize emailTextField;
@synthesize passwordTextField;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//hide keyboard
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)createButtonPressed:(UIButton *)sender {
    PFUser *user = [[PFUser alloc]init];
    user.username = emailTextField.text;
    user.password = passwordTextField.text;
    BOOL validateEmail = [self validateEmailWithString:emailTextField.text];
    
    if(validateEmail == NO){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Email Not Valid"
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error) // Something went wrong
         {
             if([emailTextField.text length] == 0 || [passwordTextField.text length] == 0){
                 // Display an alert view to show the error message
                 UIAlertView *alertView =
                 [[UIAlertView alloc] initWithTitle:@"Username Or Password Field Is Empty"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Ok", nil];
                 [alertView show];
                 
                 
                 return;

             }
             // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:@"Username Already Exists"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             
            
             return;
         }
         else{
             // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:@"Successful Registration"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             
             [self performSegueWithIdentifier:@"createSegue" sender:self];
         }
         
     }];
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
