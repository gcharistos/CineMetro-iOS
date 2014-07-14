//
//  MainViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MainViewController : UIViewController
@property (nonatomic,strong)  PFUser *user;
@property (nonatomic,strong) NSString *word;
@end
