//
//  MapViewController.m
//  CineMetro
//
//  Created by George Haristos on 5/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "MapDetailsViewController.h"
#import "ViewController1.h"
#import <AddressBook/AddressBook.h>



@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapview;
UIBarButtonItem *sidebarButton;
NSMutableArray *redPins ;
NSMutableArray *overlays;
id<MKOverlay> polyline;
int visibleLine;
NSDictionary *currentDB;
UIColor *lineColor;

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
    overlays = [[NSMutableArray alloc]init];
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
    BOOL check = [self checkForNetwork];
    if(!check || ![CLLocationManager locationServicesEnabled]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enable Location Services and Internet Connection to Show Route for Line" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        lineColor = [UIColor redColor];
        [self getDirections];
    }
    
}

//  ************ ONLY WHEN USER ENABLES INTERNET CONNECTION ************ //

- (void)getDirections
{
    for(int i=0 ;i<redPins.count-1;i++){
        MKDirectionsRequest *request =
        [[MKDirectionsRequest alloc] init];
        request.transportType =MKDirectionsTransportTypeWalking;
        MKPointAnnotation *ann = (MKPointAnnotation *)[redPins objectAtIndex:i];
        MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:ann.coordinate addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc]initWithPlacemark:placemark];
        request.source = item;
        MKPointAnnotation *ann1 = (MKPointAnnotation *)[redPins objectAtIndex:i+1];
        MKPlacemark *placemark1 = [[MKPlacemark alloc]initWithCoordinate:ann1.coordinate addressDictionary:nil];
        MKMapItem *item1 = [[MKMapItem alloc]initWithPlacemark:placemark1];
        request.destination = item1;
        request.requestsAlternateRoutes = NO;
        MKDirections *directions =
        [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             if (error) {
                 // Handle error
             } else {
                 [self showRoute:response];
             }
         }];
    }
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [mapview
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = lineColor;
    renderer.lineWidth = 5.0;
    [overlays addObject:overlay];
    return renderer;
}



//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Method set initial Region for preview
-(void)setRegion{
    CLLocationCoordinate2D coord = {40.641142,22.934721};
    MKCoordinateSpan span = {0.05,0.05};
    MKCoordinateRegion region = {coord, span};
    [self.mapview setRegion:region];
}


//Method checks if user location services are enabled then show user location to map
-(void)showUserLocation{
    if([CLLocationManager locationServicesEnabled]){
      mapview.showsUserLocation = YES;
    }
    else{
        UIAlertView *disabled = [[UIAlertView alloc]initWithTitle:@"Please Enable Location Services to Show Current Location" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        //remove each overlay from map
        for(int i=0;i<overlays.count;i++){
            [mapview removeOverlay:[overlays objectAtIndex:i]];
        }
        //remove all overlays from array
        [overlays removeAllObjects];
    }
    
}

- (BOOL)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    BOOL status;
    switch (myStatus) {
        case NotReachable:{
            status = false;
            break;
        }
        case ReachableViaWWAN:{
            status = true;
            break;
        }
        case ReachableViaWiFi:{
            status = true;
            break;
        }
        default:
            status = false;
            break;
    }
    return  status;
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
