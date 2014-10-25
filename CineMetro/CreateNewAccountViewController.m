//
//  CreateNewAccountViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "CreateNewAccountViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface CreateNewAccountViewController ()

@end

@implementation CreateNewAccountViewController
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        MainViewController *dest = (MainViewController *)([navController viewControllers][0]);
        user = appUser;
        [dest saveProfile];

    }

}


- (IBAction)createButtonPressed:(UIButton *)sender {
    PFUser *user = [[PFUser alloc]init];
    user.username = emailTextField.text;
    user.password = passwordTextField.text;
    NSArray *redArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    NSArray *blueArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    NSArray *greenArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
   
    [user setObject:@0 forKey:@"redLine"];
    [user setObject:@0 forKey:@"greenLine"];
    [user setObject:@0 forKey:@"blueLine"];
    [user setObject:@0 forKey:@"totalPoints"];
    [user setObject:redArray forKey:@"redLineStations"];
    [user setObject:greenArray  forKey:@"greenLineStations"];
    [user setObject:blueArray forKey:@"blueLineStations"];
    
    
    if([passwordTextField.text length] == 0 || [emailTextField.text length] == 0){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fillcreateAccount",@"word")
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:NSLocalizedString(@"ok",@"word"), nil];
        [alertView show];
        return;
        
    }
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"User"];
    [query whereKey:@"username" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error)
    {
        if([objects count] != 0){
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"usernameExists",@"word")
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:NSLocalizedString(@"ok",@"word"), nil];
            [alertView show];

            return;
        }

                        
    }];
    
    MBProgressHUD *createAccount = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    createAccount.labelText = NSLocalizedString(@"createAccount",@"word");
    createAccount.mode = MBProgressHUDModeIndeterminate;
    [createAccount show:YES];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [createAccount hide:YES];
         if (error) // Something went wrong
         {
                          // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"internetProblem",@"word")
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             
            
             return;
         }
         else{
             appUser = user;
            
             // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"successfullCreate",@"word")
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"ok",@"word"), nil];
             [alertView show];

             [self performSegueWithIdentifier:@"createSegue" sender:self];
         }
         
     }];
}




@end
