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
@synthesize profilePhoto;
@synthesize emailTextField;
@synthesize addImageButton;
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
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeProfilePhoto:)];
    [profilePhoto addGestureRecognizer:gesture];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bw_background.jpg"]];

        // Do any additional setup after loading the view.
}

-(void)changeProfilePhoto:(UITapGestureRecognizer *)sender{
    //Simulator doesn't have camera . print error message
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errorMessage",@"Message")
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"ok",@"Message")
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return; // end process
        
    }
    NSLog(@"SSSSSS");
    
    
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
    
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

// pick photo from camera and initialize cameraPhoto variable
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    profilePhoto.image = chosenImage;    
    profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2;
    profilePhoto.clipsToBounds = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)takePhoto:(id)sender {
    
    //Simulator doesn't have camera . print error message
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errorMessage",@"Message")
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"ok",@"Message")
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return; // end process
        
    }
    
    
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"createSegue"]){
        user = appUser;
    }

}


- (IBAction)createButtonPressed:(UIButton *)sender {
    PFUser *user = [[PFUser alloc]init];
    user.username = emailTextField.text;
    user.password = passwordTextField.text;
    NSData *imageData = UIImageJPEGRepresentation(profilePhoto.image, 0.05f);
    NSString *filename = [NSString stringWithFormat:@"file.jpg"];
    NSArray *redArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    NSArray *greenArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [user setObject:imageFile forKey:@"profileImage"];
    [user setObject:@0 forKey:@"redLine"];
    [user setObject:@0 forKey:@"GreenLine"];
    [user setObject:@0 forKey:@"blueLine"];
    [user setObject:redArray forKey:@"redLineStations"];
    [user setObject:greenArray  forKey:@"greenLineStations"];

    
    BOOL validateEmail = [self validateEmailWithString:emailTextField.text];
    
    if(validateEmail == NO ){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Email Not Valid"
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    if([passwordTextField.text length] == 0){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Password field is Empty"
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;

    }
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"User"];
    [query whereKey:@"username" equalTo:user.username];
    NSArray *results = [query findObjects:nil];
    if([results count] != 0){
        NSLog(@"EXISTS");
        return;
    }
    
    MBProgressHUD *createAccount = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    createAccount.labelText = @"Creating Account";
    createAccount.mode = MBProgressHUDModeIndeterminate;
    [createAccount show:YES];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [createAccount hide:YES];
         if (error) // Something went wrong
         {
                          // Display an alert view to show the error message
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:@"Username Already Exists Or Internet Connection not Enabled"
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

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
