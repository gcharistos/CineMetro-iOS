//
//  RedDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"
#import <MapKit/MapKit.h>
@interface RedDetailsViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,MKMapViewDelegate>{
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
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end
