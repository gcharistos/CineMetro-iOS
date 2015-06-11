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
#import "MainViewController.h"
#import <AddressBook/AddressBook.h>
#import "GreenDetailsViewController.h"
#import "BlueDetailsViewController.h"
#import "RedDetailsViewController.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "MapTableViewCell.h"
#import "ZSPinAnnotation.h"
#import "ZSAnnotation.h"
#import "VCFloatingActionButton.h"


@interface MapViewController ()
@property (nonatomic,strong) UILongPressGestureRecognizer *gesture;
@property (strong, nonatomic) VCFloatingActionButton *addButton;
@property (strong,nonatomic) MBProgressHUD *progresshud;

@end

@implementation MapViewController
@synthesize mapview;
@synthesize tableview;
@synthesize addButton;
@synthesize progresshud;
@synthesize gesture;
UIBarButtonItem *sidebarButton;
NSMutableArray *pins ;
NSMutableArray *overlays;
BOOL showDirections;
id<MKOverlay> polyline;
NSInteger visibleLine;
NSArray *currentDB;
UIColor *lineColor;
NSMutableArray *distances;
CLLocationManager *locationManager;
int selectedIndex;
Reachability* reachability;
NSTimer *timer;

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
    
    [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];
    

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    distances = [[NSMutableArray alloc]init];
    visibleLine = -1;
    mapview.delegate = self;
    pins = [[NSMutableArray alloc]init];
    overlays = [[NSMutableArray alloc]init];
    showDirections = false;
    //set region of map
    tableview.hidden = YES;
    gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    gesture.minimumPressDuration = 1.0f;
    gesture.allowableMovement = 100.0f;
    
    [mapview addGestureRecognizer:gesture];
    [self setRegion];
   
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    CGRect floatFrame = CGRectMake(mapview.frame.size.width-44-20, mapview.frame.size.height-20-44, 44, 44);
    
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus"] andPressedImage:[UIImage imageNamed:@"cross"] withScrollview:nil];
    
    
    addButton.labelArray = @[NSLocalizedString(@"red", @"word"),NSLocalizedString(@"blue", @"word"),NSLocalizedString(@"green", @"word")];
    addButton.hideWhileScrolling = NO;
    addButton.delegate = self;
   
    [mapview addSubview:addButton];
    
}

-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    if(row+1 == 1 ){
        //if user pressed the same line and route is visible exit
        if(visibleLine == 1){
            return;
        }
        visibleLine  = row+1;
        [self removeObjectsFromMap];
        
        [self UploadLine:@"RedLineStations" :[UIColor redColor]];
    }
    else if(row+1 == 2){
        if(visibleLine == 2){
            return;
        }
        visibleLine  = row+1;
        [self removeObjectsFromMap];
        [self UploadLine:@"BlueLineStations" :[UIColor blueColor]];
        
    }
    else if(row+1 == 3) {
        if(visibleLine == 3){
            return;
        }
        visibleLine  = row+1;
        [self removeObjectsFromMap];
        [self UploadLine:@"GreenLineStations" :[UIColor greenColor]];
        
    }
//    else if(row+1 == 4) {
//        if(visibleLine == 4){
//            return;
//        }
//        visibleLine  = row+1;
//        [self removeObjectsFromMap];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Line :D" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }

}



// show or hide tableview list
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:gesture]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            [self showHidePressed];
        }
    }
}

//method animates tableview whether user wants to show/hide it .
-(void)showHidePressed {
    if(visibleLine == -1){ // empty table
        [self presentNotification:NSLocalizedString(@"emptytable",@"word")];


        return;
    }
    if(tableview.hidden){
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [tableview.layer addAnimation:animation forKey:nil];
        tableview.hidden = NO;
    }
    else {
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0]setTitle:@"Show"];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [tableview.layer addAnimation:animation forKey:nil];

        tableview.hidden = YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return pins.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     MapTableViewCell *cell;
    NSString *identifier = @"Cell";
    cell = [tableview dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.title.text =[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"station",@"word"),(int)indexPath.row+1];
    if([locale isEqualToString:@"el"]){
        cell.subtitle.text = [[currentDB objectAtIndex:indexPath.row] objectForKey:@"GrSubtitle"];
    }
    else if([locale isEqualToString:@"en"]){
        cell.subtitle.text = [[currentDB objectAtIndex:indexPath.row] objectForKey:@"EnSubtitle"];
    }
    cell.subtitle.textColor = lineColor;
    return cell;
}





-(void)UploadLine:(NSString *)name :(UIColor *)color{
    progresshud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progresshud.labelText = NSLocalizedString(@"calculatedistances",@"word");
    progresshud.mode = MBProgressHUDModeIndeterminate;
    [progresshud show:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    currentDB = anns;
    
    for(int i = 0; i < [anns count]; i++) {
        float realLatitude = [[[anns objectAtIndex:i] objectForKey:@"Latitude"] floatValue];
        float realLongitude = [[[anns objectAtIndex:i] objectForKey:@"Longitude"] floatValue];
        ZSAnnotation *myAnnotation = [[ZSAnnotation alloc] init];
        myAnnotation.type = ZSPinAnnotationTypeTag;
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = realLatitude;
        theCoordinate.longitude = realLongitude;
        myAnnotation.coordinate = theCoordinate;
        myAnnotation.color = color;
        myAnnotation.title = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),i+1];
        if([locale isEqualToString:@"el"]){
            myAnnotation.subtitle = [[anns objectAtIndex:i] objectForKey:@"GrSubtitle"];
        }
        else if([locale isEqualToString:@"en"]){
            myAnnotation.subtitle = [[anns objectAtIndex:i] objectForKey:@"EnSubtitle"];
        }
        [mapview addAnnotation:myAnnotation];
        [pins addObject:myAnnotation];
    }
    [tableview reloadData];
    [self setRegion];
    lineColor = color;
    [self showUserLocation];
    [self getDirections];
}

-(void)calculateAgainDistances{
    progresshud.labelText = NSLocalizedString(@"calculatedistances",@"word");
    [progresshud show:YES];
    [self showUserLocation];
    [self getDirections];
}




//  ************ ONLY WHEN USER ENABLES INTERNET CONNECTION ************ //

- (void)getDirections
{
    for(int i=0 ;i<pins.count-1;i++){
        MKDirectionsRequest *request =
        [[MKDirectionsRequest alloc] init];
        request.transportType =MKDirectionsTransportTypeWalking;
        MKPointAnnotation *ann = (MKPointAnnotation *)[pins objectAtIndex:i];
        MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:ann.coordinate addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc]initWithPlacemark:placemark];
        request.source = item;
        MKPointAnnotation *ann1 = (MKPointAnnotation *)[pins objectAtIndex:i+1];
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
                 [progresshud hide:YES];

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
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"StandardIdentifier";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[mapview dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = ZSPinAnnotationTypeTagStroke;
    pinView.annotationColor = a.color;
    pinView.canShowCallout = YES;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [button setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
    pinView.rightCalloutAccessoryView = button;
    pinView.rightCalloutAccessoryView.tag = 200;
    return pinView;
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
        [self presentNotification:NSLocalizedString(@"enablelocation",@"word")];
        [progresshud hide:YES];
        return;
    }
    else if(![self checkForNetwork]){
        [self presentNotification:NSLocalizedString(@"enableInternetConnection",@"word")];
        [progresshud hide:YES];


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
        
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        return;

    }
    if (![[UIDevice currentDevice].systemVersion hasPrefix:@"7"]) { // if your device is not iOS 7
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ){
            mapview.showsUserLocation = YES;
            [locationManager startUpdatingLocation];
        }
        else{
            [locationManager requestWhenInUseAuthorization];
        }

    }
    else {
        mapview.showsUserLocation = YES;
        [locationManager startUpdatingLocation];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    int flag = 0;
    for(int i=0;i<pins.count;i++){
        MKPointAnnotation *theAnnotation = [pins objectAtIndex:i];
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
        timer = [[NSTimer alloc]init];
       timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                         target:self
                                       selector:@selector(showUserLocation)
                                       userInfo:nil
                                        repeats:NO];
    }

}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");}
    else if     (remoteHostStatus == ReachableViaWiFi)  {[reachability stopNotifier];[self calculateAgainDistances]; }
    else if     (remoteHostStatus == ReachableViaWWAN) {[reachability stopNotifier];[self calculateAgainDistances];}
    
    //    if (self.hasInet) {
    //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Net avail" message:@"" delegate:self cancelButtonTitle:OK_EN otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
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
    
       //directions button pressed
        MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:annotationTapped.coordinate addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc]initWithPlacemark:placemark];
        destination.name = annotationTapped.subtitle;
        [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    
    
}

- (IBAction)settingsButtonPressed:(id)sender {

    UIAlertView *settingsAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"chooseL",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"word") otherButtonTitles:NSLocalizedString(@"red", @"word"),NSLocalizedString(@"blue",@"word"),NSLocalizedString(@"green",@"word"),NSLocalizedString(@"noline",@"word"), nil];
    settingsAlert.tag = 100;
    [settingsAlert show];
}

-(void)removeObjectsFromMap{
    //remove annotations from map
    [mapview removeAnnotations:pins];
    // remove all annotations from array
    [pins removeAllObjects];
    //after delete , reload tableview
    [tableview reloadData];
    //remove all overlays from map
    [mapview removeOverlays:overlays];
    
    //remove all overlays from array
    [overlays removeAllObjects];
    
    //remove all distances
    [distances removeAllObjects];
    
    //stop timer for location update
    [timer invalidate];
    timer = nil;

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
            alertView.hidden = YES;
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

-(void)selectPinFromMap:(NSInteger)index{
    [mapview selectAnnotation:[pins objectAtIndex:index] animated:YES];

}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [mapview selectAnnotation:[pins objectAtIndex:indexPath.row] animated:YES];
    //info button pressed
        selectedIndex =(int)indexPath.row;
        if(visibleLine == 1){
            [self performSegueWithIdentifier:@"redLine" sender:nil];
        }
        else if(visibleLine == 2){
            [self performSegueWithIdentifier:@"blueLine" sender:nil];
            
        }
        else if(visibleLine == 3){
            [self performSegueWithIdentifier:@"greenLine" sender:nil];
            
        }
    

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"redLine"]){
        RedDetailsViewController *dest = segue.destinationViewController;
        dest.station = [currentDB objectAtIndex:selectedIndex];
        dest.indexPath = selectedIndex;
    }
    else if([segue.identifier isEqualToString:@"blueLine"]){
        BlueDetailsViewController *dest = segue.destinationViewController;
        dest.position = selectedIndex;
    }
    else if([segue.identifier isEqualToString:@"greenLine"]){
        GreenDetailsViewController *dest = segue.destinationViewController;
        dest.station = [currentDB objectAtIndex:selectedIndex];
        dest.indexPath = selectedIndex;
    }
    
}
//remove timer for location update . remove reachability notification
-(void)viewDidDisappear:(BOOL)animated{
    if(timer !=nil){
      [timer invalidate];
      timer = nil;
      [reachability stopNotifier];
      reachability = nil;
    }
}



@end
