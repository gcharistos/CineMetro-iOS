//
//  MainViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
int flag;
@interface MainViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,strong)  PFUser *user;
- (IBAction)profileButtonPressed:(id)sender;
@property (nonatomic,strong) NSString *word;
-(void)redirectToProfile;
@end
