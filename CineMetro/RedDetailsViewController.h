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
@interface RedDetailsViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    IBOutlet UIScrollView *scroller;
}
@property (strong,nonatomic) RatingViewController *popViewController;
@property NSDictionary *station;
@property NSInteger indexPath;
@property (weak, nonatomic) IBOutlet UILabel *theaterTitle;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
