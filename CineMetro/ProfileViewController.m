//
//  ProfileViewController.m
//  CineMetro
//
//  Created by George Haristos on 24/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize user;
@synthesize greenLinePoints;
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
    NSString *points = [NSString stringWithFormat:@"%i",[[user objectForKey:@"points"]intValue]];
    pointsLabel.text = points;
    NSString *redlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"redLine"]intValue]];
    redLinePoints.text = redlinepoints;
    NSString *greenlinepoints = [NSString stringWithFormat:@"%i",[[user objectForKey:@"GreenLine"]intValue]];
    greenLinePoints.text = greenlinepoints;
    // Do any additional setup after loading the view.
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

@end
