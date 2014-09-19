//
//  RedDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"
@interface RedDetailsViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate>{
    IBOutlet UIScrollView *scroller;
}
@property NSDictionary *station;
@property NSInteger indexPath;
@property (strong,nonatomic) RatingViewController *popViewController;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)twitterButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
