//
//  RedDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RedDetailsViewController.h"
#import <Social/Social.h>
#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MainViewController.h"
#import <Parse/Parse.h>
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "ZSAnnotation.h"
#import "MapViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad



@interface RedDetailsViewController ()
@property (strong, nonatomic)  UITextView *tempTextview;

@end

@implementation RedDetailsViewController
@synthesize station;
@synthesize title;
@synthesize tempTextview;
@synthesize indexPath;
@synthesize theaterTitle;
@synthesize containerView;
NSMutableArray *images;
MKMapView *mapview;
CGFloat heightOfText;
NSArray *currentList;
NSString *tempText;
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
   
    images = [[NSMutableArray alloc]init];

   
    images = [station objectForKey:@"Images"];
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
    if([locale isEqualToString:@"el"]){
        tempText  = [station objectForKey:@"GrText"];
    }
    else if([locale isEqualToString:@"en"]){
        tempText  = [station objectForKey:@"EnText"];
    }
   
    // ADD TEXT TO SCROLLVIEW
    heightOfText = [self heightOfTextViewWithString:tempText withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
    tempTextview = [[UITextView alloc]initWithFrame:CGRectMake(0,containerView.frame.origin.y+containerView.frame.size.height+40,self.view.frame.size.width-20,heightOfText)];
    tempTextview.text = tempText;
    [tempTextview setFont:[UIFont systemFontOfSize:18]];
    tempTextview.editable = NO;
    [tempTextview setTextAlignment:NSTextAlignmentCenter];
    tempTextview.selectable = NO;
    tempTextview.textColor = [UIColor whiteColor];
    tempTextview.backgroundColor = [UIColor clearColor];
    [scroller addSubview:tempTextview];

   //  -- END --
    // ADD RATE BUTTON TO SCROLLVIEW
    UIButton *ratebutton = [[UIButton alloc]initWithFrame:CGRectMake(10,tempTextview.frame.size.height+tempTextview.frame.origin.y+30,40, 40)];
    [ratebutton setImage:[UIImage imageNamed:@"star_off.png"] forState:UIControlStateNormal] ;
    [ratebutton addTarget:self action:@selector(rateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:ratebutton];
    // -- END --
    // ADD MAP BUTTON TO SCROLLVIEW
    UIButton *mapbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-30,tempTextview.frame.size.height+tempTextview.frame.origin.y+30,40, 40)];
    [mapbutton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal] ;
    [mapbutton addTarget:self action:@selector(mapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:mapbutton];
    // -- END --
    
    
    

    // ADD MAP TO SCROLLVIEW
    mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0,ratebutton.frame.origin.y+ratebutton.frame.size.height+50,self.view.frame.size.width,240)];
    mapview.userInteractionEnabled = NO;
    mapview.delegate = self;
    [scroller addSubview:mapview];
    // -- END --
    // ADD SHARE BUTTON TO SCROLLVIEW
    UIButton *fbbutton = [[UIButton alloc]initWithFrame:CGRectMake(5,10,40, 40)];
    [fbbutton setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal] ;
    [fbbutton addTarget:self action:@selector(facebookButton) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:fbbutton];
    // -- END --
    // ADD SHARE BUTTON TO SCROLLVIEW
    UIButton *twitterbutton = [[UIButton alloc]initWithFrame:CGRectMake(55,10,40, 40)];
    [twitterbutton setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal] ;
    [twitterbutton addTarget:self action:@selector(twitterButton) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:twitterbutton];
    // -- END --


    ZSAnnotation *myAnnotation = [[ZSAnnotation alloc] init];
    myAnnotation.type = ZSPinAnnotationTypeTag;
    myAnnotation.color = [UIColor redColor];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[station objectForKey:@"Latitude"]doubleValue];
    theCoordinate.longitude = [[station objectForKey:@"Longitude"]doubleValue];
    myAnnotation.coordinate = theCoordinate;
    myAnnotation.title = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),(int)indexPath+1];
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
    [mapview setRegion:region];
    


    // Do any additional setup after loading the view.
}



- (CGFloat)heightOfTextViewWithString:(NSString *)string
                             withFont:(UIFont *)font
                        andFixedWidth:(CGFloat)fixedWidth
{
    UITextView *tempTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, fixedWidth, 1)];
    tempTV.text = [string uppercaseString];
    tempTV.font = font;
    
    CGSize newSize = [tempTV sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tempTV.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tempTV.frame = newFrame;
    
    return tempTV.frame.size.height;
}

- (IBAction)mapButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showMapRed" sender:nil];
}









-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width,mapview.frame.origin.y+mapview.frame.size.height+80)];
}

//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    
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
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if(images.count == 0 && [identifier isEqualToString:@"showPhotos"]){
        return NO;
    }
    return YES;
}



- (IBAction)rateButtonPressed:(id)sender {
    if(user != nil){
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"redLineStations"]];
        if([[points objectAtIndex:indexPath]intValue] != 0){
            [self presentNotification:NSLocalizedString(@"ratedTrue",@"word")];


        }
        else{
            [self performSegueWithIdentifier:@"redStars" sender:nil];
        }
    }
    else {

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
     else if([segue.identifier isEqualToString:@"showMapRed"]){
        MapViewController *dest = segue.destinationViewController;
        [dest UploadLine:@"RedLineStations" :[UIColor redColor]];
        [dest selectPinFromMap:indexPath];
    }
     else if([segue.identifier isEqualToString:@"redStars"]){
         RatingViewController *dest = segue.destinationViewController;
         [dest initializeView:indexPath :@"redLineStations" :points :@"redLine"];
     }
   
}
-(void)viewDidDisappear:(BOOL)animated{
    images = nil;

}




@end
