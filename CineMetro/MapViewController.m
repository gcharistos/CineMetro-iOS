//
//  MapViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SWRevealViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;
UIBarButtonItem *sidebarButton;
NSMutableArray *redPins ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    redPins = [[NSMutableArray alloc]init];
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(40.641142, 22.934721);
    point.title = @"1η Στάση";
    point.subtitle = @"Βαρδάρης";
    
    [self.mapView addAnnotation:point];
    [redPins addObject:point];
    // Add an annotation
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = CLLocationCoordinate2DMake(40.635650, 22.935431);
    point1.title = @"2η Στάση";
    point1.subtitle = @"Λιμάνι";
    
    [self.mapView addAnnotation:point1];
    [redPins addObject:point1];
    // Add an annotation
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = CLLocationCoordinate2DMake(40.630440, 22.942912);
    point2.title = @"3η Στάση";
    point2.subtitle = @"Λεωφόρος Νίκης";
    
    [self.mapView addAnnotation:point2];
    [redPins addObject:point2];

    // Add an annotation
    MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
    point3.coordinate = CLLocationCoordinate2DMake(40.632804,22.941331);
    point3.title = @"4η Στάση";
    point3.subtitle = @"Πλατεία Αριστοτέλους";
    
    [self.mapView addAnnotation:point3];
    [redPins addObject:point3];
    // Add an annotation
    MKPointAnnotation *point4 = [[MKPointAnnotation alloc] init];
    point4.coordinate = CLLocationCoordinate2DMake(40.632511,22.947489);
    point4.title = @"5η Στάση";
    point4.subtitle = @"Αγίας Σοφίας-Αλ.Σβώλου";
    
    [self.mapView addAnnotation:point4];
    [redPins addObject:point4];
    // Add an annotation
    MKPointAnnotation *point5 = [[MKPointAnnotation alloc] init];
    point5.coordinate = CLLocationCoordinate2DMake(40.62638,22.948306);
    point5.title = @"6η Στάση";
    point5.subtitle = @"Λευκός Πύργος";
    
    [self.mapView addAnnotation:point5];
    [redPins addObject:point5];



    //draw red line
    [self drawLine];
    
    // Change button color
   // _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
   // _sidebarButton.target = self.revealViewController;
   // _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Do any additional setup after loading the view.
}
- (void)drawLine {
   
    
    // create an array of coordinates from allPins
    CLLocationCoordinate2D coordinates[redPins.count];
    int i = 0;
    for (MKPointAnnotation *currentPin in redPins) {
        coordinates[i] = currentPin.coordinate;
        i++;
    }
    
    // create a polyline with all cooridnates
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:redPins.count];
    [self.mapView addOverlay:polyline];
    
    
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 7.0;
    
    return polylineView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
