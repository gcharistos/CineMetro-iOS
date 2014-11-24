//
//  GreenDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 19/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "GreenDetailsViewController.h"
#import "MainViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ContainerGreenViewController.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"

@interface GreenDetailsViewController ()

@end

@implementation GreenDetailsViewController
@synthesize station;
@synthesize title;
@synthesize indexPath;
@synthesize theaterTitle;
@synthesize mapview;
NSMutableArray *images;
NSArray *currentList;
NSMutableArray *points;
ContainerGreenViewController *dest;


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
    
    
        images = [[NSMutableArray alloc]init];
    //set navigation bar title
    // self.navigationItem.title =[station objectForKey:@"Subtitle"];
   
    images = [station objectForKey:@"Images"];
    mapview.delegate = self;
    mapview.showsUserLocation = YES;
    mapview.userInteractionEnabled = NO;
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[station objectForKey:@"Latitude"]doubleValue];
    theCoordinate.longitude = [[station objectForKey:@"Longitude"]doubleValue];
    myAnnotation.coordinate = theCoordinate;
    myAnnotation.title =[NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),indexPath+1];
    if([locale isEqualToString:@"el"]){
        theaterTitle.text = [station objectForKey:@"GrSubtitle"];
        myAnnotation.subtitle = [station objectForKey:@"GrSubtitle"];

    }
    else if([locale isEqualToString:@"en"]){
        theaterTitle.text = [station objectForKey:@"EnSubtitle"];
        myAnnotation.subtitle = [station objectForKey:@"EnSubtitle"];

    }
    [mapview addAnnotation:myAnnotation];
    MKCoordinateSpan span = {0.05,0.05};
    MKCoordinateRegion region = {theCoordinate, span};
    if([CLLocationManager locationServicesEnabled]){
        MKCoordinateRegion innerregion;
        MKCoordinateSpan innerspan = {0.10,0.10};
        
        //find rect that encloses all coords
        float maxLat = -200;
        float maxLong = -200;
        float minLat = MAXFLOAT;
        float minLong = MAXFLOAT;
        for (int i=0 ; i < 2 ; i++) {
            CLLocationCoordinate2D location;
            if(i == 0){
                location = myAnnotation.coordinate;
            }
            else if(i == 1){
                location = mapview.userLocation.location.coordinate;
            }
            
            if (location.latitude < minLat) {
                minLat = location.latitude;
            }
            
            if (location.longitude < minLong) {
                minLong = location.longitude;
            }
            
            if (location.latitude > maxLat) {
                maxLat = location.latitude;
            }
            
            if (location.longitude > maxLong) {
                maxLong = location.longitude;
            }
        }
        
        //Center point
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5);
        innerregion.center = center;
        innerregion.span = innerspan;
        [mapview setRegion:innerregion];
        
    }
    else{
        [mapview setRegion:region];
    }

    [mapview selectAnnotation:myAnnotation animated:YES];
    [self performSegueWithIdentifier:@"showPhotos2" sender:self];
    // Do any additional setup after loading the view.
}

//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    annotationView.canShowCallout = YES;
   
        annotationView.image = [UIImage imageNamed:@"greenPin.png"];
        
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [button setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
    
    annotationView.rightCalloutAccessoryView = button;
    annotationView.rightCalloutAccessoryView.tag = 200;
    return annotationView;
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



-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    
    [scroller setContentSize:CGSizeMake(320,1330)];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if(images.count == 0 && [identifier isEqualToString:@"showPhotos2"]){
        return NO;
    }
    return YES;
}

- (IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"sharemessage",@"word") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"word") destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
    actionsheet.tag = 100;
    [actionsheet showInView:self.view];
}

- (IBAction)rateButtonPressed:(id)sender {
    if(user != nil){
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"greenLineStations"]];
        if([[points objectAtIndex:indexPath]intValue] != 0){
            [self presentNotification:NSLocalizedString(@"ratedTrue",@"word")];

//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ratedTrue",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
//            [alert show];
        }
        else{
            self.popViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
            
            [self.popViewController showInView:self.navigationController.view  withController:self withArray:points atIndexPath:indexPath withName:@"greenLineStations" withname:@"greenLine"  animated:YES];
        }
    }
    else {
        [self presentNotification:NSLocalizedString(@"rateLogin",@"word")];

//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rateLogin",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
//        [alert show];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 100){
        if(buttonIndex == 0){
            [self facebookButton];
        }
        else if(buttonIndex == 1){
            [self twitterButton];
        }
    }
}

- (void)twitterButton {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *twittertext = [NSString stringWithFormat:@"#CineMetro #line3station%li\n",(long)indexPath+1];
        [tweetSheetOBJ setInitialText:twittertext];
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else{ // no twitter account
        UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"notwitter",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        noaccount.tag = 200;
        [noaccount show];
    }
}

- (void)facebookButton {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *fbtext = [NSString stringWithFormat:@"#CineMetro #line3station%li\n",(long)indexPath+1];
        [fbSheetOBJ setInitialText:fbtext];
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else{ // no facebook account
        UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"nofacebook",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        noaccount.tag = 200;
        [noaccount show];
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPhotos2"]){
        dest = segue.destinationViewController;
        if(images.count != 0){
            dest.pageImages = [[NSArray alloc]initWithArray:images];
            dest.parentController = self;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)viewDidDisappear:(BOOL)animated{
    images = nil;
    
}

- (IBAction)backButtonPressed:(id)sender {
    [dest goToPreviousView];
}

- (IBAction)forwardButtonPressed:(id)sender {
    [dest goToNextView];
}
@end

