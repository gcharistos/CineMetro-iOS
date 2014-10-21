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
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <POP.h>
#import <AddressBook/AddressBook.h>



@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapview;
@synthesize tableview;
@synthesize hideButton;
UIBarButtonItem *sidebarButton;
NSMutableArray *redPins ;
NSMutableArray *overlays;
BOOL showDirections;
id<MKOverlay> polyline;
NSInteger visibleLine;
NSArray *currentDB;
UIColor *lineColor;
NSMutableArray *distances;
CLLocationManager *locationManager;


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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    distances = [[NSMutableArray alloc]init];
    [hideButton setTitle:NSLocalizedString(@"hideList",@"word") forState:UIControlStateNormal];
    visibleLine = -1;
    mapview.delegate = self;
    redPins = [[NSMutableArray alloc]init];
    overlays = [[NSMutableArray alloc]init];
    showDirections = NO;
    //set region of map
    [self setRegion];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


//method animates tableview whether user wants to show/hide it .
-(IBAction)showHidePressed:(id)sender {
    if(tableview.hidden){
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [tableview.layer addAnimation:animation forKey:nil];
        [hideButton setTitle:NSLocalizedString(@"hideList",@"word") forState:UIControlStateNormal];
        tableview.hidden = NO;
    }
    else {
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0]setTitle:@"Show"];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [tableview.layer addAnimation:animation forKey:nil];
        [hideButton setTitle:NSLocalizedString(@"showList",@"word") forState:UIControlStateNormal];

        tableview.hidden = YES;
    }
}



-(void)UploadLine:(NSString *)name :(UIColor *)color{
    MBProgressHUD *progresshud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progresshud.labelText = @"Calculating Distances";
    progresshud.mode = MBProgressHUDModeIndeterminate;
    [progresshud show:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    currentDB = anns;
    
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
    [tableview reloadData];
    [self setRegion];
    lineColor = color;
    [self showUserLocation];
    [self getDirections];
    [progresshud hide:YES];

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
                 showDirections = false;
             } else {
                 showDirections = true;
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
    if(visibleLine == 1){
        annotationView.image = [UIImage imageNamed:@"redPin.png"];
    }
    else if(visibleLine == 2){
        annotationView.image = [UIImage imageNamed:@"bluePin.png"];

    }
    else if(visibleLine == 3){
        annotationView.image = [UIImage imageNamed:@"greenPin.png"];

    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = button;
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
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *disabled = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"enablelocation",@"word") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        [disabled show];
        return;
    }
    else if(![self checkForNetwork]){
        UIAlertView *disabled = [[UIAlertView alloc]initWithTitle:@"Please enable internet connection for user location view" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        [disabled show];
        return;

    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ){
        mapview.showsUserLocation = YES;
        [locationManager startUpdatingLocation];
    }
    else{
        [locationManager requestWhenInUseAuthorization];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    int flag = 0;
    for(int i=0;i<redPins.count;i++){
        MKPointAnnotation *theAnnotation = [redPins objectAtIndex:i];
        CLLocation *pinlocation = [[CLLocation alloc]initWithLatitude:theAnnotation.coordinate.latitude longitude:theAnnotation.coordinate.longitude];
        CLLocationDistance distance = [pinlocation distanceFromLocation:mapview.userLocation.location];
        if(distance == -1){
            flag = 1;
            [distances removeAllObjects];
            break;
        }
        NSString *string = [NSString stringWithFormat:@"%4.0f m",distance];
        [distances addObject:[NSString stringWithFormat:@"%@",string]];
        
    }
    if(flag == 0){
      [locationManager stopUpdatingLocation];
      [tableview reloadData];
    }

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
        mapview.showsUserLocation = YES;
        [locationManager startUpdatingLocation];
    }
    
   
    
    
}
    
    



//if annotation info button pressed go to details
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *annotationTapped = (MKPointAnnotation *)view.annotation;
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:annotationTapped.coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc]initWithPlacemark:placemark];
    destination.name = annotationTapped.title;
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
 
    
}

- (IBAction)settingsButtonPressed:(id)sender {
    UIAlertView *settingsAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"chooseL",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"word") otherButtonTitles:NSLocalizedString(@"red", @"word"),NSLocalizedString(@"blue",@"word"),NSLocalizedString(@"green",@"word"), nil];
    settingsAlert.tag = 100;
    [settingsAlert show];
}

-(void)removeObjectsFromMap{
    //remove annotations from map
    [mapview removeAnnotations:redPins];
    // remove all annotations from array
    [redPins removeAllObjects];
    //after delete , reload tableview
    [tableview reloadData];
    
    //remove all overlays from map
    [mapview removeOverlays:overlays];
    
    //remove all overlays from array
    [overlays removeAllObjects];
    
    //remove all distances
    [distances removeAllObjects];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
       if(alertView.tag == 100){
        if(buttonIndex == 1 ){
            //if user pressed the same line and route is visible exit
            if(visibleLine == 1){
                return;
            }
            visibleLine  = buttonIndex;
            [self removeObjectsFromMap];
            [self UploadLine:@"RedLineStations" :[UIColor redColor]];
        }
        else if(buttonIndex == 2){
            if(visibleLine == 2){
                return;
            }
            visibleLine  = buttonIndex;
            [self removeObjectsFromMap];
            [self UploadLine:@"BlueLineStations" :[UIColor blueColor]];

        }
        else if(buttonIndex == 3) {
            if(visibleLine == 3){
                return;
            }
            visibleLine  = buttonIndex;
            [self removeObjectsFromMap];
            [self UploadLine:@"GreenLineStations" :[UIColor greenColor]];

        }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return redPins.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(redPins.count != 0){
        tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableview.backgroundView = nil;
        return 1;
    }
    else{
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = NSLocalizedString(@"emptytable",@"word");
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.backgroundColor = [UIColor orangeColor];
        
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   // cell.backgroundColor = lineColor;
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:105];
    UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:106];
    titleLabel.text = [[currentDB objectAtIndex:indexPath.row]objectForKey:@"Title"];
    [titleLabel setTextColor:lineColor];
   // titleLabel.textColor =[UIColor whiteColor];
    subtitleLabel.text = [[currentDB objectAtIndex:indexPath.row]objectForKey:@"Subtitle"];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:107];
    if(distances.count !=0){
      distanceLabel.text = [distances objectAtIndex:indexPath.row];
    }
   // subtitleLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mapview selectAnnotation:[redPins objectAtIndex:indexPath.row] animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
