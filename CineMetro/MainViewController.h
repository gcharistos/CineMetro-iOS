//
//  MainViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CDRTranslucentSideBar.h"
PFUser *user;
int flag;
NSString *locale;
int counter;
@interface MainViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,CDRTranslucentSideBarDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong) NSString *word;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
-(void)LogOut;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
-(void) saveProfile;
-(void)showLogout;
-(void)showLogIn;
-(void)showCreateAccount;
- (IBAction)navigationButtonPressed:(id)sender;
- (IBAction)linesButtonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)sidebarButtonPressed:(id)sender;
@end
