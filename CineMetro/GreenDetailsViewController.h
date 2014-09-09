//
//  GreenDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 19/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property  NSInteger position;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@end
