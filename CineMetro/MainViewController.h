//
//  MainViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
PFUser *user;
int flag;
int counter;
@interface MainViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)profileButtonPressed:(id)sender;
@property (nonatomic,strong) NSString *word;
-(void)redirectToProfile;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
-(void)LogOut;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
-(void) saveProfile;
@end
