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
#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "ZSAnnotation.h"
#import "MapViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface BlueDetailsViewController ()
@property NSInteger position1;
@property (strong, nonatomic)  UITextView *tempTextview;

@end

@implementation BlueDetailsViewController
@synthesize position1;
@synthesize position;
@synthesize info;
@synthesize tempTextview;
@synthesize infoLabel;
@synthesize movieTitle;
@synthesize actorsLabel;
MKMapView *mapview;
NSMutableArray *images;
NSArray *currentList;
NSArray *titles;
CGFloat heightOfText;
NSArray *actors;
NSString *tempText;
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
    [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];
    
    
    images = [[NSMutableArray alloc]init];
    actorsLabel.text = NSLocalizedString(@"actors",@"word");
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
    [self performSegueWithIdentifier:@"showPhotos" sender:self];

    if([locale isEqualToString:@"el"]){
        tempText = [[currentList objectAtIndex:position1]objectForKey:@"GrText"];
        
    }
    else if([locale isEqualToString:@"en"]){
        tempText = [[currentList objectAtIndex:position1]objectForKey:@"EnText"];
        
    }

    // ADD TEXT TO SCROLLVIEW
    heightOfText = [self heightOfTextViewWithString:tempText withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
    tempTextview = [[UITextView alloc]initWithFrame:CGRectMake(0,infoLabel.frame.origin.y+infoLabel.frame.size.height+40,self.view.frame.size.width-20,heightOfText)];
    tempTextview.text = tempText;
    [tempTextview setFont:[UIFont systemFontOfSize:18]];
    tempTextview.editable = NO;
    tempTextview.selectable = NO;
    [tempTextview setTextAlignment:NSTextAlignmentLeft];
    tempTextview.textColor = [UIColor whiteColor];
    tempTextview.backgroundColor = [UIColor clearColor];
    [scroller addSubview:tempTextview];
    // -- END --
    //ADD DIRECTOR NAME
    NSString *directortext;
    if([locale isEqualToString:@"el"]){
        directortext = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"director",@"word"),[directors[0] objectForKey:@"GrName"]];
        
    }
    else if([locale isEqualToString:@"en"]){
      directortext = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"director",@"word"),[directors[0] objectForKey:@"EnName"]];
    }
    
    heightOfText = [self heightOfTextViewWithString:directortext withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(20,tempTextview.frame.origin.y+tempTextview.frame.size.height,self.view.frame.size.width,heightOfText)];
    textview.text = directortext;
    [textview setFont:[UIFont systemFontOfSize:18]];
    textview.editable = NO;
    textview.textAlignment =NSTextAlignmentJustified;
    textview.scrollEnabled = NO;
    textview.selectable = NO;
    textview.textColor = [UIColor whiteColor];
    textview.backgroundColor = [UIColor clearColor];
    [scroller addSubview:textview];
    //END
    //ADD ACTORS NAME
    NSString *actorstext = [NSString stringWithFormat:@"%@ : ",NSLocalizedString(@"actors",@"word")];
    for(int i=0;i<actors.count;i++){
        if([locale isEqualToString:@"el"]){
            NSString *name = [NSString stringWithFormat:@"%@ ",[actors[i] objectForKey:@"GrName"]];
            actorstext = [actorstext stringByAppendingString:name];
            if(i< actors.count-1){
                actorstext = [actorstext stringByAppendingString:@","];
            }
        }
        else if([locale isEqualToString:@"en"]){
            NSString *name = [NSString stringWithFormat:@"%@ ",[actors[i] objectForKey:@"EnName"]];
            actorstext = [actorstext stringByAppendingString:name];
            if(i< actors.count-1){
                actorstext = [actorstext stringByAppendingString:@","];
            }
        }
    }
    heightOfText = [self heightOfTextViewWithString:actorstext withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
    UITextView *textview1 = [[UITextView alloc]initWithFrame:CGRectMake(20,textview.frame.origin.y+textview.frame.size.height+10,self.view.frame.size.width-20,heightOfText)];
    textview1.text = actorstext;
    [textview1 setFont:[UIFont systemFontOfSize:18]];
    textview1.editable = NO;
    textview1.scrollEnabled = NO;
    textview1.selectable = NO;
    textview1.textColor = [UIColor whiteColor];
    textview1.backgroundColor = [UIColor clearColor];
    [scroller addSubview:textview1];
    // END
    // ADD COLLECTION OF DIRECTOR/ACTORS IMAGES-NAMES
    self.factorsCollectionView.frame = CGRectMake(0,textview1.frame.origin.y+textview1.frame.size.height+40, self.view.frame.size.width,180);
    //END
    // ADD RATE BUTTON TO SCROLLVIEW
    UIButton *ratebutton = [[UIButton alloc]initWithFrame:CGRectMake(10,self.factorsCollectionView.frame.size.height+self.factorsCollectionView.frame.origin.y+50,40, 40)];
    [ratebutton setImage:[UIImage imageNamed:@"star_off.png"] forState:UIControlStateNormal] ;
    [ratebutton addTarget:self action:@selector(rateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:ratebutton];
    // -- END --
    // ADD MAP BUTTON TO SCROLLVIEW
    UIButton *mapbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-30,self.factorsCollectionView.frame.size.height+self.factorsCollectionView.frame.origin.y+50,40, 40)];
     [mapbutton addTarget:self action:@selector(mapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapbutton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal] ;
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

   
    mapview.delegate = self;
    mapview.userInteractionEnabled = NO;

    ZSAnnotation *myAnnotation = [[ZSAnnotation alloc] init];
    myAnnotation.type = ZSPinAnnotationTypeTag;
    myAnnotation.color = [UIColor blueColor];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[[anns objectAtIndex:position1] objectForKey:@"Latitude"]doubleValue];
    theCoordinate.longitude = [[[anns objectAtIndex:position1] objectForKey:@"Longitude"]doubleValue];
    myAnnotation.coordinate = theCoordinate;
    myAnnotation.title = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),(int)position1+1];
    if([locale isEqualToString:@"el"]){
        movieTitle.text = [[currentList objectAtIndex:position1]objectForKey:@"GrSubtitle"];
        myAnnotation.subtitle = [[anns objectAtIndex:position1] objectForKey:@"GrSubtitle"];

    }
    else if([locale isEqualToString:@"en"]){
        movieTitle.text = [[currentList objectAtIndex:position1]objectForKey:@"EnSubtitle"];
        myAnnotation.subtitle = [[anns objectAtIndex:position1] objectForKey:@"EnSubtitle"];

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
    [self performSegueWithIdentifier:@"showMapBlue" sender:nil];
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



-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width,mapview.frame.origin.y+mapview.frame.size.height+40)];
    
}


- (IBAction)rateButtonPressed:(id)sender {
    if(user != nil){
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"blueLineStations"]];
        if([[points objectAtIndex:position1]intValue] != 0){
            [self presentNotification:NSLocalizedString(@"ratedTrue",@"word")];

        }
        else{
            [self performSegueWithIdentifier:@"blueStars" sender:nil];
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
    
    return directors.count+actors.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
        static NSString *identifer = @"Cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:106];
        UILabel *label = (UILabel *)[cell viewWithTag:107];
        if(indexPath.row == 0){
            imageview.image = [UIImage imageNamed:[[directors objectAtIndex:indexPath.row]objectForKey:@"Icon"]];
            if([locale isEqualToString:@"el"]){
                label.text = [[directors objectAtIndex:indexPath.row]objectForKey:@"GrName"];
                
                
            }
            else if([locale isEqualToString:@"en"]){
                label.text = [[directors objectAtIndex:indexPath.row]objectForKey:@"EnName"];
                
                
            }
        }
        else{
            int tempCount = indexPath.row-1;
            

            imageview.image = [UIImage imageNamed:[[actors objectAtIndex:tempCount]objectForKey:@"Icon"]];
            if([locale isEqualToString:@"el"]){
                label.text = [[actors objectAtIndex:tempCount]objectForKey:@"GrName"];

                
            }
            else if([locale isEqualToString:@"en"]){
                label.text = [[actors objectAtIndex:tempCount]objectForKey:@"EnName"];

                
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
    else if([segue.identifier isEqualToString:@"showMapBlue"]){
        MapViewController *dest = segue.destinationViewController;
        [dest UploadLine:@"BlueLineStations" :[UIColor blueColor]];
        [dest selectPinFromMap:position];
    }
    else if([segue.identifier isEqualToString:@"blueStars"]){
        RatingViewController *dest = segue.destinationViewController;
        [dest initializeView:position :@"blueLineStations" :points :@"blueLine"];
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

- (IBAction)showFactorPressed:(id)sender {
    [self.factorsCollectionView reloadData];
}
@end
