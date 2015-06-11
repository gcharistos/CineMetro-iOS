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
#import "VCFloatingActionButton.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,floatMenuDelegate>
  @property (weak, nonatomic) IBOutlet MKMapView *mapview;

  - (IBAction)settingsButtonPressed:(id)sender;
-(void)showUserLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
-(void)UploadLine:(NSString *)name :(UIColor *)color;
-(void)selectPinFromMap:(NSInteger)index;
@end
