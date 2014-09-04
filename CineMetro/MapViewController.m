//
//  MapViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapDetailsViewController.h"
#import "ViewController1.h"


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapview;
UIBarButtonItem *sidebarButton;
NSMutableArray *redPins ;
MKPolyline *polyline;
int visibleLine;
NSDictionary *currentDB;

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
    visibleLine = -1;
    mapview.delegate = self;
    redPins = [[NSMutableArray alloc]init];
    //set region of map
    [self setRegion];

    
    
   
}


-(void)UploadRedLine{
    redPins = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RedLineStations" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    currentDB = dict;
    NSArray *anns = [dict objectForKey:@"Stations"];
    
    for(int i = 0; i < [anns count]; i++) {
        float realLatitude = [[[anns objectAtIndex:i] objectForKey:@"Latitude"] floatValue];
        float realLongitude = [[[anns objectAtIndex:i] objectForKey:@"Longitude"] floatValue];
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = realLatitude;
        theCoordinate.longitude = realLongitude;
        myAnnotation.coordinate = theCoordinate;
        myAnnotation.title = [[anns objectAtIndex:i] objectForKey:@"Title"];
        myAnnotation.subtitle = [[anns objectAtIndex:i] objectForKey:@"Subtitle"];
        [mapview addAnnotation:myAnnotation];
        [redPins addObject:myAnnotation];
    }
    
    //draw red line
    [self drawLine:redPins];
    
}
- (void)drawLine:(NSMutableArray *)pins {
   
    
    // create an array of coordinates from allPins
    CLLocationCoordinate2D coordinates[pins.count];
    int i = 0;
    for (MKPointAnnotation *currentPin in pins) {
        coordinates[i] = currentPin.coordinate;
        i++;
    }
    
    // create a polyline with all cooridnates
    polyline = [MKPolyline polylineWithCoordinates:coordinates count:pins.count];
    [self.mapview addOverlay:polyline];
    
    
    
}
//set polyline appearance
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    NSString *colorDB = [currentDB objectForKey:@"Color"];
    if([colorDB isEqualToString:@"red"]){
       polylineView.strokeColor = [UIColor redColor];
    }
    polylineView.lineWidth = 7.0;
    
    return polylineView;
}

//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRegion{
    CLLocationCoordinate2D coord = {40.641142,22.934721};
    MKCoordinateSpan span = {0.05,0.05};
    MKCoordinateRegion region = {coord, span};
    [self.mapview setRegion:region];
}



-(void)showUserLocation{
    if([CLLocationManager locationServicesEnabled]){
      mapview.showsUserLocation = YES;
    }
    else{
        UIAlertView *disabled = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [disabled show];
    }

}

//if annotation info button pressed go to details
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  //  [self performSegueWithIdentifier:@"showDetails" sender:nil];
    MKPointAnnotation *annotationTapped = (MKPointAnnotation *)view.annotation;
    self.popViewController = [[ViewController1 alloc] initWithNibName:@"ViewController1" bundle:nil];
    
    [self.popViewController showInView:self.view withAnnotation:annotationTapped withController:self animated:YES];
    
}

- (IBAction)settingsButtonPressed:(id)sender {
    UIAlertView *settingsAlert = [[UIAlertView alloc]initWithTitle:@"Διαλέξτε Γραμμή  :" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Red Line",@"Green Line",@"Blue Line",@"Orange Line", nil];
    [settingsAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1 ){
        visibleLine = 1;
        [self UploadRedLine];
    }
    else if(buttonIndex != 0) {
        [mapview removeAnnotations:redPins];
        [mapview removeOverlay:polyline];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetails"]){
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
