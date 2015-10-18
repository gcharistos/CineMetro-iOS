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
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"
#import "RadioButton.h"
#import "ZSAnnotation.h"
#import "MapViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@interface GreenDetailsViewController ()
@property (strong, nonatomic)  UITextView *tempTextview;

@end

@implementation GreenDetailsViewController
@synthesize station;
@synthesize title;
@synthesize indexPath;
@synthesize tempTextview;
@synthesize theaterTitle;
@synthesize imageview;
MKMapView *mapview;
NSMutableArray *images;
NSString *tempText;
CGFloat heightOfText;
NSArray *currentList;
NSMutableArray *points;
NSMutableArray *buttons;
UIButton *mapbutton;
UIButton *sharebutton;
UIButton *ratebutton;



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
    
    
    
    buttons = [NSMutableArray arrayWithCapacity:10];
    CGRect btnRect;
    if(IDIOM == IPAD){
        btnRect = CGRectMake(100,200, 100, 30);
        
    }
    else{
       btnRect = CGRectMake(25,180, 100, 30);
    }
    int tagFlag = 0;
    for (NSDictionary * optionTitle in images) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.y += 40;
        [btn setTitle:[optionTitle objectForKey:@"year"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [scroller addSubview:btn];
        btn.tag =  tagFlag;
        tagFlag = tagFlag + 1;
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    
    [buttons[0] setSelected:YES]; // Making the first button initially selected

    imageview.image = (UIImage *)[UIImage imageNamed:[[images objectAtIndex:0]objectForKey:@"Image"]];
        // Do any additional setup after loading the view.
}



- (IBAction)mapButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showMapGreen" sender:nil];
}

-(void)viewDidAppear:(BOOL)animated{
        // ADD TEXT TO SCROLLVIEW
        if(tempTextview !=nil){
           [tempTextview removeFromSuperview];
        }
        if([locale isEqualToString:@"el"]){
            tempText = [[images objectAtIndex:0]objectForKey:@"GrText"];
        }
        else if([locale isEqualToString:@"en"]){
            tempText = [[images objectAtIndex:0]objectForKey:@"EnText"];
            
        }
        heightOfText = [self heightOfTextViewWithString:tempText withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
        
        tempTextview = [[UITextView alloc]initWithFrame:CGRectMake(0,imageview.frame.origin.y+imageview.frame.size.height+40,self.view.frame.size.width,heightOfText)];
        tempTextview.text = tempText;
        [tempTextview setFont:[UIFont systemFontOfSize:18]];
        [tempTextview setTextAlignment:NSTextAlignmentCenter];
        tempTextview.editable = NO;
        tempTextview.hidden = NO;
        tempTextview.selectable = NO;
        tempTextview.textColor = [UIColor whiteColor];
        tempTextview.backgroundColor = [UIColor clearColor];
        [scroller addSubview:tempTextview];
        //END
        if(ratebutton != nil){
            [ratebutton removeFromSuperview];
        }
        //  -- END --
        // ADD RATE BUTTON TO SCROLLVIEW
        ratebutton = [[UIButton alloc]initWithFrame:CGRectMake(10,tempTextview.frame.size.height+tempTextview.frame.origin.y+30,40, 40)];
        [ratebutton setImage:[UIImage imageNamed:@"star_off.png"] forState:UIControlStateNormal] ;
        [ratebutton addTarget:self action:@selector(rateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:ratebutton];
        // -- END --
        if(mapbutton != nil){
            [mapbutton removeFromSuperview];
        }
        // ADD MAP BUTTON TO SCROLLVIEW
        mapbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-30,tempTextview.frame.size.height+tempTextview.frame.origin.y+30,40, 40)];
        [mapbutton addTarget:self action:@selector(mapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mapbutton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal] ;
        [scroller addSubview:mapbutton];
        // -- END --
        if(mapview != nil){
            [mapview removeFromSuperview];
        }
        // ADD MAP TO SCROLLVIEW
        mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0,ratebutton.frame.origin.y+ratebutton.frame.size.height+50,self.view.frame.size.width,240)];
        mapview.userInteractionEnabled = NO;
        mapview.delegate = self;
        [scroller addSubview:mapview];
        // -- END --
        // ADD SHARE BUTTON TO SCROLLVIEW
      //  UIButton *fbbutton = [[UIButton alloc]initWithFrame:CGRectMake(5,10,40, 40)];
       // [fbbutton setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal] ;
       // [fbbutton addTarget:self action:@selector(facebookButton) forControlEvents:UIControlEventTouchUpInside];
       // [scroller addSubview:fbbutton];
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
        myAnnotation.color = [UIColor greenColor];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [[station objectForKey:@"Latitude"]doubleValue];
        theCoordinate.longitude = [[station objectForKey:@"Longitude"]doubleValue];
        myAnnotation.coordinate = theCoordinate;
        myAnnotation.title =[NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),(int)indexPath+1];
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


-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        imageview.image = [UIImage imageNamed:[[images objectAtIndex:sender.tag]objectForKey:@"Image"]];
        [tempTextview removeFromSuperview];
        // ADD TEXT TO SCROLLVIEW
        if([locale isEqualToString:@"el"]){
            tempText = [[images objectAtIndex:sender.tag]objectForKey:@"GrText"];
        }
        else if([locale isEqualToString:@"en"]){
            tempText = [[images objectAtIndex:sender.tag]objectForKey:@"EnText"];
            
        }
        heightOfText = [self heightOfTextViewWithString:tempText withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
        tempTextview = [[UITextView alloc]initWithFrame:CGRectMake(0,imageview.frame.origin.y+imageview.frame.size.height+40,self.view.frame.size.width,heightOfText)];
        tempTextview.text = tempText;
        [tempTextview setFont:[UIFont systemFontOfSize:18]];
        [tempTextview setTextAlignment:NSTextAlignmentCenter];
        tempTextview.editable = NO;
        tempTextview.selectable = NO;
        tempTextview.textColor = [UIColor whiteColor];
        tempTextview.backgroundColor = [UIColor clearColor];
        [scroller addSubview:tempTextview];
        [ratebutton removeFromSuperview];
        // ADD RATE BUTTON TO SCROLLVIEW
        ratebutton.frame =  CGRectMake(10,tempTextview.frame.size.height+tempTextview.frame.origin.y+10,40, 40);
        [scroller addSubview:ratebutton];
        [mapbutton removeFromSuperview];
        // -- END --
        // ADD MAP BUTTON TO SCROLLVIEW
        mapbutton.frame = CGRectMake(self.view.frame.size.width/2.0-30,tempTextview.frame.size.height+tempTextview.frame.origin.y+10,40, 40);
        [sharebutton removeFromSuperview];
        [scroller addSubview:mapbutton];
        // -- END --
        // ADD SHARE BUTTON TO SCROLLVIEW
        sharebutton.frame = CGRectMake(self.view.frame.size.width-50,tempTextview.frame.size.height+tempTextview.frame.origin.y+10,40, 40);
        
        [scroller addSubview:sharebutton];
        // -- END --
        [mapview removeFromSuperview];
        // ADD MAP TO SCROLLVIEW
        mapview.frame = CGRectMake(0,ratebutton.frame.origin.y+ratebutton.frame.size.height+30,self.view.frame.size.width,240);
        [scroller addSubview:mapview];
        // -- END --

    }
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
    return pinView;}




-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width,mapview.frame.size.height+mapview.frame.origin.y+40)];
}






- (IBAction)rateButtonPressed:(id)sender {
    if(user != nil){
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"greenLineStations"]];
        if([[points objectAtIndex:indexPath]floatValue] != 0){
            [self presentNotification:NSLocalizedString(@"ratedTrue",@"word")];

        }
        else{
            [self performSegueWithIdentifier:@"greenStars" sender:nil];
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
     if([segue.identifier isEqualToString:@"showMapGreen"]){
        MapViewController *dest = segue.destinationViewController;
        [dest UploadLine:@"GreenLineStations" :[UIColor greenColor]];
        [dest selectPinFromMap:indexPath];
    }
     else if([segue.identifier isEqualToString:@"greenStars"]){
         RatingViewController *dest = segue.destinationViewController;
         [dest initializeView:indexPath :@"greenLineStations" :points :@"greenLine"];
     }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)viewDidDisappear:(BOOL)animated{
    images = nil;

}


@end

