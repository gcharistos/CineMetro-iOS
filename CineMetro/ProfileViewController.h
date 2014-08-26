//
//  ProfileViewController.h
//  CineMetro
//
//  Created by George Haristos on 24/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ProfileViewController : UIViewController
@property (weak,nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLinePoints;
@property (weak, nonatomic) IBOutlet UILabel *greenLinePoints;

@end
