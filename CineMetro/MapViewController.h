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
#import "ViewController1.h"
@interface MapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
  @property (weak, nonatomic) IBOutlet MKMapView *mapview;
  @property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
  @property (strong, nonatomic) ViewController1 *popViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

  - (IBAction)settingsButtonPressed:(id)sender;
-(void)showUserLocation;
@end
