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
    PFFile *image = [user objectForKey:@"profileImage"];
    //profile image exists  . retrieve it from parse database
    if(image != nil){
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            if (!error) {
                imageView.image = [UIImage imageWithData:data];

                }
        }];

        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = YES;
    }
    
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
    flag = -1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
