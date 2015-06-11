//
//  RatingViewController.m
//  CineMetro
//
//  Created by George Haristos on 12/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RatingViewController.h"
#import "Reachability.h"
#import "MainViewController.h"
#import <Pop/POP.h>
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface RatingViewController ()

@end

@implementation RatingViewController
@synthesize cancelButton;
@synthesize okbutton;
BOOL rated;
NSMutableArray *points;
NSInteger row;
NSString *tableName;
NSString *linepoints;
float  selected;

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
    rated = false;
    [okbutton setTitle:NSLocalizedString(@"ok",@"word") forState:UIControlStateNormal];
    [okbutton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancelButton setTitle:NSLocalizedString(@"cancel",@"word") forState:UIControlStateNormal];
    if(IDIOM != IPAD){
        _ratingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30, 200, 250, 50)];
    }
    else{
        _ratingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30+250, 300, 250, 50)];

    }
    _ratingView.delegate = self;
    [self.view addSubview:_ratingView];

    

    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    NSString *string = [NSString stringWithFormat:@"%0.2f",score * 5 ];
    rated = true;
    selected  = [string floatValue];
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)okButtonPressed:(id)sender {
    if(rated){
        if([self checkForNetwork] == true){ // network is enabled
            [points replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:selected]];
            [user setObject:points forKey:tableName];
            int points = [[user objectForKey:linepoints]intValue];
            points = points + 1;
            float totalpoints = [[user objectForKey:@"totalPoints"]floatValue];
            totalpoints = totalpoints + selected ;
            [user setObject:[NSNumber numberWithInt:points] forKey:linepoints];
            [user setObject:[NSNumber numberWithFloat:totalpoints] forKey:@"totalPoints"];
            [user saveInBackground];
            UIAlertView *rate = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"thankyou",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
            rate.tag = 1;
            [rate show];
            }
        else { // no network
            [self presentConfirmation:NSLocalizedString(@"rateerror",@"word")];

        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {

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







-(void)initializeView:(NSInteger)counter :(NSString *)tablen :(NSMutableArray *)array :(NSString *)linepo{
    row = counter;
    tableName = tablen;
    points = array;
    linepoints = linepo;
    

}




@end
