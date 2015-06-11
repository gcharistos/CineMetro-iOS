//
//  GreenDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 19/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RatingViewController.h"
#import <MapKit/MapKit.h>

@interface GreenDetailsViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    IBOutlet UIScrollView *scroller;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property NSDictionary *station;
@property NSInteger indexPath;
@property (strong,nonatomic) RatingViewController *popViewController;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;

@end
