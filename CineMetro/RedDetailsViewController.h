//
//  RedDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RedDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>
@property NSDictionary *station;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;

@end
