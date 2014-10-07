//
//  BlueDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 31/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"

@interface BlueDetailsViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate>{
    IBOutlet UIScrollView *scroller;

}
@property NSDictionary *station;
@property NSInteger indexPath;
@property (strong,nonatomic) RatingViewController *popViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;
@property (weak, nonatomic) IBOutlet UILabel *previousYear;
@property (weak, nonatomic) IBOutlet UILabel *nextYear;
@property (weak, nonatomic) IBOutlet UILabel *currentYear;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;
@end
