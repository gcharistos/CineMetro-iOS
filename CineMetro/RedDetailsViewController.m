//
//  RedDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 30/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RedDetailsViewController.h"
#import "ViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface RedDetailsViewController ()

@end

@implementation RedDetailsViewController
@synthesize station;
@synthesize textview;
@synthesize tableview;
@synthesize title;
@synthesize indexPath;
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
    images = [[NSMutableArray alloc]init];
    //set navigation bar title
   // self.navigationItem.title =[station objectForKey:@"Subtitle"];
    theaterTitle.text = [station objectForKey:@"Subtitle"];
    textview.text  = [station objectForKey:@"text"];
    [textview setFont:[UIFont systemFontOfSize:17]];
    images = [station objectForKey:@"Images"];
    [self performSegueWithIdentifier:@"showPhotos" sender:self];


    // Do any additional setup after loading the view.
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
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ratedTrue",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            self.popViewController = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil];
            
            [self.popViewController showInView:self.navigationController.view  withController:self withArray:points atIndexPath:indexPath withName:@"redLineStations" animated:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Log In to Rate" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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



@end
