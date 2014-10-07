//
//  BlueDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 31/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "BlueDetailsViewController.h"
#import "ShowActorsViewController.h"
#import "MainViewController.h"
#import "ShowTextViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ContainerBlueViewController.h"

@interface BlueDetailsViewController ()

@end

@implementation BlueDetailsViewController
@synthesize station;
@synthesize tableview;
@synthesize title;
@synthesize indexPath;
@synthesize theaterTitle;
NSMutableArray *images;
NSArray *currentList;
NSMutableArray *points;
ContainerBlueViewController *dest;


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
    
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320,630)];
    images = [[NSMutableArray alloc]init];
    //set navigation bar title
    // self.navigationItem.title =[station objectForKey:@"Subtitle"];
    theaterTitle.text = [station objectForKey:@"Subtitle"];
    images = [station objectForKey:@"Images"];
    [self performSegueWithIdentifier:@"showPhotos2" sender:self];
    // Do any additional setup after loading the view.
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
        points = [NSMutableArray arrayWithArray:[user objectForKey:@"blueLineStations"]];
        NSLog(@"size : %i",[points count]);
        if([[points objectAtIndex:indexPath]intValue] != 0){
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ratedTrue",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            self.popViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
            
            [self.popViewController showInView:self.navigationController.view  withController:self withArray:points atIndexPath:indexPath withName:@"blueLineStations" withname:@"blueLine"  animated:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rateLogin",@"word") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
        [alert show];
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
