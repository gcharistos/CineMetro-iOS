//
//  MapViewController.h
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
  @property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;

  - (IBAction)settingsButtonPressed:(id)sender;
-(IBAction)showHidePressed:(id)sender;
-(void)showUserLocation;
@end
