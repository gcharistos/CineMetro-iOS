//
//  RedLineTableViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedLineTableViewController : UITableViewController <UITableViewDataSource ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
