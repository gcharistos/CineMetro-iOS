//
//  BlueDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 31/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"

@interface BlueDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>{
    IBOutlet UIScrollView *scroller;

}
@property NSDictionary *station;
@property NSInteger indexPath;
@property (strong,nonatomic) RatingViewController *popViewController;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end
