//
//  GreenDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 19/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"

@interface GreenDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    IBOutlet UIScrollView *scroller;
}

@property  NSInteger position;
@property (strong,nonatomic) RatingViewController *popViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
- (IBAction)twitterButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *actorsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *directorsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *directorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *info;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
