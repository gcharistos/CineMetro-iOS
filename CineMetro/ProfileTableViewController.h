//
//  ProfileTableViewController.h
//  CineMetro
//
//  Created by George Haristos on 25/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileTableViewController : UITableViewController
@property (weak,nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *redPoints;
@property (weak, nonatomic) IBOutlet UILabel *bluePoints;
@property (weak, nonatomic) IBOutlet UILabel *greenPoints;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)LogoutPressed:(id)sender;

@end
