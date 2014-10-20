//
//  ProfileViewController.m
//  CineMetro
//
//  Created by George Haristos on 24/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize user;
@synthesize imageView;
@synthesize greenLinePoints;
@synthesize blueLinePoints;
@synthesize redLinePoints;
@synthesize pointsLabel;
@synthesize emailLabel;

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
    emailLabel.text = [user objectForKey:@"username"];
    NSString *points = [NSString stringWithFormat:@"%@",[user objectForKey:@"totalPoints"]];
    pointsLabel.text = points;
    NSString *redlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"redLine"]intValue]];
    redLinePoints.text = redlinepoints;
    NSString *greenlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"greenLine"]intValue]];
    greenLinePoints.text = greenlinepoints;
    NSString *bluelinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"blueLine"]intValue]];
    blueLinePoints.text = bluelinepoints;

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LogOutPressed:(id)sender {
    MainViewController *dest = (MainViewController *)[[self.navigationController viewControllers]objectAtIndex:0];
    [dest LogOut];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logged Out" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
