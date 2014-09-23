//
//  RatingViewController.m
//  CineMetro
//
//  Created by George Haristos on 12/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RatingViewController.h"
#import "GreenDetailsViewController.h"
#import "Reachability.h"
#import "MainViewController.h"
#import <Pop/POP.h>

@interface RatingViewController ()

@end

@implementation RatingViewController
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize stars;
@synthesize cancelButton;
@synthesize okbutton;
BOOL rated;
NSMutableArray *points;
NSInteger row;
NSString *tableName;
int  selected;
GreenDetailsViewController *viewController;

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
    rated = false;
   // [star1 setUserInteractionEnabled:YES];
    [okbutton setTitle:NSLocalizedString(@"ok",@"word") forState:UIControlStateNormal];
    [cancelButton setTitle:NSLocalizedString(@"cancel",@"word") forState:UIControlStateNormal];
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(star1Pressed:)];
     UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(star2Pressed:)];
     UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(star3Pressed:)];
    UITapGestureRecognizer *recognizer4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(star4Pressed:)];
     UITapGestureRecognizer *recognizer5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(star5Pressed:)];
    [star1 addGestureRecognizer:recognizer1];
    [star2 addGestureRecognizer:recognizer2];
    [star3 addGestureRecognizer:recognizer3];
    [star4 addGestureRecognizer:recognizer4];
    [star5 addGestureRecognizer:recognizer5];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)star1Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    selected = 1;
    [self startAnimation:1];

}

-(void)star2Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    selected = 2;
    [self startAnimation:2];

}

-(void)star3Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    selected = 3;
    [self startAnimation:3];

}

-(void)star4Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    selected = 4;
    [self startAnimation:4];

}

-(void)star5Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    selected = 5;
    [self startAnimation:5];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showInView:(UIView *)aView  withController:(UIViewController *)controller withArray:(NSArray *)array atIndexPath:(NSInteger)indexPath withName:(NSString *)name withBackground:(UIImage *)image  animated:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // viewController = (GreenDetailsViewController *)controller;
        [aView addSubview:self.view];
        points = [[NSMutableArray alloc]initWithArray:array];
        row = indexPath;
        tableName = name;
        if (animated) {
            [self showAnimate];
        }
    });
    
    
}


- (IBAction)okButtonPressed:(id)sender {
    [self removeAnimate];
    if(rated){
        if([self checkForNetwork] == true){ // network is enabled
              [points replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:selected]];
              [user setObject:points forKey:tableName];
              [user saveInBackground];
                

              UIAlertView *rate = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"thankyou",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
              [rate show];
        }
        else { // no network
            UIAlertView *noNetwork = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rateerror",@"word") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"word") otherButtonTitles:nil, nil];
            [noNetwork show];
        }
    }

}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeAnimate];

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






- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

-(void)startAnimation:(int)counter{
    for(int i = 0;i<counter;i++){
        UIImageView *star = [stars objectAtIndex:i];
        CGFloat toValue = star.center.x;
        
        POPSpringAnimation *onscreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        onscreenAnimation.toValue = @(toValue);
        onscreenAnimation.springBounciness = 10.f;
        POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
        offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        offscreenAnimation.toValue = @(-toValue);
        offscreenAnimation.duration = 0.2f;
        [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            star.image = [UIImage imageNamed:@"star_on.png"];
            [star.layer pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
        }];
        [star.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
        
    }
    for(int i=counter;i<stars.count;i++){
        UIImageView *star = [stars objectAtIndex:i];
        CGFloat toValue = star.center.x;
        
        POPSpringAnimation *onscreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        onscreenAnimation.toValue = @(toValue);
        onscreenAnimation.springBounciness = 10.f;
        POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
        offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        offscreenAnimation.toValue = @(-toValue);
        offscreenAnimation.duration = 0.2f;
        [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            star.image = [UIImage imageNamed:@"star_off.png"];
            [star.layer pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
        }];
        [star.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    }

}




@end
