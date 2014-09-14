//
//  ShowTextViewController.m
//  CineMetro
//
//  Created by George Haristos on 10/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ShowTextViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ShowTextViewController ()

@end

@implementation ShowTextViewController
@synthesize text;
@synthesize movieTitle;
@synthesize textview;
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
    textview.text = text;
    [textview setFont:[UIFont systemFontOfSize:17]];
    // Do any additional setup after loading the view.
}

- (IBAction)shareButtonPressed:(id)sender {
    
    NSLog(@"%@",movieTitle);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Choose Action :" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share to Facebook",@"Share to Twitter", nil];
    alert.tag = 100;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100){
        if(buttonIndex == 1){ // facebook
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                NSString *fbtext = [NSString stringWithFormat:@"%@ \n\n %@",movieTitle,text];
                [fbSheetOBJ setInitialText:fbtext];
                [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
            }
            else{ // no facebook account
                    UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    noaccount.tag = 200;
                    [noaccount show];
            }
        }
        else if(buttonIndex == 2){ // twitter
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSString *twittertext = [NSString stringWithFormat:@"%@",text];
                [tweetSheetOBJ setInitialText:twittertext];
                [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
            }
            else{ // no twitter account
                    UIAlertView *noaccount = [[UIAlertView alloc]initWithTitle:@"No Twitter Account" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    noaccount.tag = 200;
                    [noaccount show];
            }
        }
       
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
