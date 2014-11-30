//
//  RedDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RedDetailsViewController.h"
#import "ViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MainViewController.h"
#import <Parse/Parse.h>
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "LicenseViewController.h"



@interface RedDetailsViewController ()

@end

@implementation RedDetailsViewController
@synthesize station;
@synthesize infoLabel;
@synthesize textview;
@synthesize tableview;
@synthesize title;
@synthesize indexPath;
@synthesize mapview;
@synthesize theaterTitle;
NSMutableArray *images;
NSArray *currentList;
NSMutableArray *points;


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
   
    textview.scrollEnabled = NO;
    infoLabel.text = NSLocalizedString(@"info",@"word");
    images = [[NSMutableArray alloc]init];
    //set navigation bar title
   // self.navigationItem.title =[station objectForKey:@"Subtitle"];
    mapview.userInteractionEnabled = NO;

   
    images = [station objectForKey:@"Images"];
    mapview.delegate = self;

    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[station objectForKey:@"Latitude"]doubleValue];
    theCoordinate.longitude = [[station objectForKey:@"Longitude"]doubleValue];
    myAnnotation.coordinate = theCoordinate;
    myAnnotation.title = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),indexPath+1];
    if([locale isEqualToString:@"el"]){
        theaterTitle.text = [station objectForKey:@"GrSubtitle"];
        textview.text  = [station objectForKey:@"GrText"];
        myAnnotation.subtitle = [station objectForKey:@"GrSubtitle"];
    }
    else if([locale isEqualToString:@"en"]){
        theaterTitle.text = [station objectForKey:@"EnSubtitle"];
        textview.text  = [station objectForKey:@"EnText"];
        myAnnotation.subtitle = [station objectForKey:@"EnSubtitle"];
    }
    [textview setFont:[UIFont systemFontOfSize:18]];
    textview.textColor = [UIColor whiteColor];
  
    [mapview addAnnotation:myAnnotation];
    MKCoordinateSpan span = {0.05,0.05};
    MKCoordinateRegion region = {theCoordinate, span};
    if([CLLocationManager locationServicesEnabled]){
        mapview.showsUserLocation = YES;


    }
    else{
        [mapview setRegion:region];
    }
    [self performSegueWithIdentifier:@"showPhotos" sender:self];


    // Do any additional setup after loading the view.
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    //span.latitudeDelta = 0.005;
    //span.longitudeDelta = 0.005;
    span.latitudeDelta = 0.9;
    span.longitudeDelta = 0.9;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}







-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320,950)];
}

//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    annotationView.canShowCallout = YES;
    
    annotationView.image = [UIImage imageNamed:@"redPin.png"];
    
    
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








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if(images.count == 0 && [identifier isEqualToString:@"showPhotos"]){
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
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"redLineStations"]];
        if([[points objectAtIndex:indexPath]intValue] != 0){
            [self presentNotification:NSLocalizedString(@"ratedTrue",@"word")];

//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ratedTrue",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
//            [alert show];
        }
        else{
            self.popViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
            
            [self.popViewController showInView:self.navigationController.view  withController:self withArray:points atIndexPath:indexPath withName:@"redLineStations" withname:@"redLine"  animated:YES];
        }
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rateLogin",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
//        [alert show];
        [self presentNotification:NSLocalizedString(@"rateLogin",@"word")];

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
        NSString *twittertext = [NSString stringWithFormat:@"#CineMetro #line1station%li\n",(long)indexPath+1];
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
        NSString *fbtext = [NSString stringWithFormat:@"#CineMetro #line1station%li\n",(long)indexPath+1];
        [fbSheetOBJ setInitialText:fbtext];
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else{ // no facebook account
        UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"nofacebook",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        noaccount.tag = 200;
        [noaccount show];
    }
    
}









#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPhotos"]){
        ViewController *dest = segue.destinationViewController;
        if(images.count != 0){
            dest.pageImages = [[NSArray alloc]initWithArray:images];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)viewDidDisappear:(BOOL)animated{
    images = nil;
   // [[[self childViewControllers]objectAtIndex:0] removeFromParentViewController];

}



- (IBAction)moreButtonPressed:(id)sender {
    self.popViewControllerText = [[LicenseViewController alloc] initWithNibName:@"LicenseViewController" bundle:nil];
    
    [self.popViewControllerText showInView:self.navigationController.view  withController:self  withText:textview.text withColor:scroller.backgroundColor withTextColor:[UIColor whiteColor] animated:YES];
}
@end
