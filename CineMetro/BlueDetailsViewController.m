//
//  BlueDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 31/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "BlueDetailsViewController.h"
#import "MainViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"

@interface BlueDetailsViewController ()
@property NSInteger position1;

@end

@implementation BlueDetailsViewController
@synthesize position1;
@synthesize position;
@synthesize info;
@synthesize infoLabel;
@synthesize movieTitle;
@synthesize actorsLabel;
@synthesize mapview;
@synthesize directorsLabel;
NSMutableArray *images;
NSArray *currentList;
NSArray *titles;
NSArray *actors;
NSArray *directors;
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

    UIBarButtonItem *ratebutton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"rate",@"word") style:UIBarButtonItemStyleBordered target:self action:@selector(rateButtonPressed:)];
    
    UIBarButtonItem *sharebutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Upload"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareButtonPressed:)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:ratebutton,sharebutton, nil];
    
    
    images = [[NSMutableArray alloc]init];
    actorsLabel.text = NSLocalizedString(@"actors",@"word");
    directorsLabel.text = NSLocalizedString(@"director",@"word");
    infoLabel.text = NSLocalizedString(@"info",@"word");
    position1 = position;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BlueLineStations" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    currentList = anns;
    actors = [[currentList objectAtIndex:position1]objectForKey:@"Actors"];
    directors  = [[currentList objectAtIndex:position1]objectForKey:@"Directors"];
   // [info setTextColor:[UIColor whiteColor]];
    images = [[anns objectAtIndex:position1]objectForKey:@"Images"];
    titles = [[NSArray alloc]initWithObjects:NSLocalizedString(@"factors",@"word"),NSLocalizedString(@"info",@"word"), nil];
    
    mapview.delegate = self;
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[[anns objectAtIndex:position1] objectForKey:@"Latitude"]doubleValue];
    theCoordinate.longitude = [[[anns objectAtIndex:position1] objectForKey:@"Longitude"]doubleValue];
    myAnnotation.coordinate = theCoordinate;
    myAnnotation.title = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),(int)position1+1];
    if([locale isEqualToString:@"el"]){
        info.text = [[currentList objectAtIndex:position1]objectForKey:@"GrText"];
        movieTitle.text = [[currentList objectAtIndex:position1]objectForKey:@"GrSubtitle"];
        myAnnotation.subtitle = [[anns objectAtIndex:position1] objectForKey:@"GrSubtitle"];

    }
    else if([locale isEqualToString:@"en"]){
        info.text = [[currentList objectAtIndex:position1]objectForKey:@"EnText"];
        movieTitle.text = [[currentList objectAtIndex:position1]objectForKey:@"EnSubtitle"];
        myAnnotation.subtitle = [[anns objectAtIndex:position1] objectForKey:@"EnSubtitle"];

    }
    [info setFont:[UIFont systemFontOfSize:18]];

    [mapview addAnnotation:myAnnotation];
    MKCoordinateSpan span = {0.05,0.05};
    MKCoordinateRegion region = {theCoordinate, span};
    [mapview setRegion:region];
    [mapview selectAnnotation:myAnnotation animated:YES];
    
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
    
    
    // Do any additional setup after loading the view.
}



//set custom annotation view to support callout accessory control mode
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
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


-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320,1550)];
}


- (IBAction)rateButtonPressed:(id)sender {
    if(user != nil){
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"blueLineStations"]];
        if([[points objectAtIndex:position1]intValue] != 0){
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ratedTrue",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            self.popViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
            
            [self.popViewController showInView:self.navigationController.view  withController:self withArray:points atIndexPath:position1 withName:@"blueLineStations" withname:@"blueLine"  animated:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rateLogin",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"sharemessage",@"word") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"word") destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
    actionsheet.tag = 100;
    [actionsheet showInView:self.view];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if(images.count == 0 && [identifier isEqualToString:@"showPhotos"]){
        return NO;
    }
    return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.actorsCollectionView){
        return actors.count;
    }
    return directors.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(collectionView == self.actorsCollectionView){
        static NSString *identifer = @"Cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:106];
        UILabel *label = (UILabel *)[cell viewWithTag:107];
        imageview.image = [UIImage imageNamed:[[actors objectAtIndex:indexPath.row]objectForKey:@"Icon"]];
        if([locale isEqualToString:@"el"]){
            label.text = [[actors objectAtIndex:indexPath.row]objectForKey:@"GrName"];

            
        }
        else if([locale isEqualToString:@"en"]){
            label.text = [[actors objectAtIndex:indexPath.row]objectForKey:@"EnName"];

            
        }
    }
    else if(collectionView == self.directorsCollectionView){
        static NSString *identifer = @"cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:104];
        UILabel *label = (UILabel *)[cell viewWithTag:105];
        imageview.image = [UIImage imageNamed:[[directors objectAtIndex:indexPath.row]objectForKey:@"Icon"]];
        if([locale isEqualToString:@"el"]){
            label.text = [[directors objectAtIndex:indexPath.row]objectForKey:@"GrName"];
            
            
        }
        else if([locale isEqualToString:@"en"]){
            label.text = [[directors objectAtIndex:indexPath.row]objectForKey:@"EnName"];
            
            
        }
    }
    return cell;
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



- (void)twitterButton {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *twittertext = [NSString stringWithFormat:@"#CineMetro #line2station%li\n",(long)position1+1];
        [tweetSheetOBJ setInitialText:twittertext];
        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
    else{ // no twitter account
        UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"notwitter",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        noaccount.tag = 200;
        [noaccount show];
    }
}

- (void)facebookButton{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *fbtext = [NSString stringWithFormat:@"#CineMetro #line2station%li\n",(long)position1+1];
        [fbSheetOBJ setInitialText:fbtext];
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else{ // no facebook account
        UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"nofacebook",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        noaccount.tag = 200;
        [noaccount show];
    }
    
}
@end
