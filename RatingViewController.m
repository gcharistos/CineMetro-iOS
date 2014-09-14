//
//  RatingViewController.m
//  CineMetro
//
//  Created by George Haristos on 12/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "RatingViewController.h"
#import "GreenDetailsViewController.h"
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
BOOL rated;
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
    [self startAnimation:1];

}

-(void)star2Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    [self startAnimation:2];

}

-(void)star3Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    [self startAnimation:3];

}

-(void)star4Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    [self startAnimation:4];

}

-(void)star5Pressed:(UITapGestureRecognizer *)sender{
    rated = true;
    [self startAnimation:5];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showInView:(UIView *)aView  withController:(UIViewController *)controller animated:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // viewController = (GreenDetailsViewController *)controller;
        [aView addSubview:self.view];
        
        if (animated) {
            [self showAnimate];
        }
    });
    
    
}

- (IBAction)okButtonPressed:(id)sender {
    [self removeAnimate];
    if(rated){
      UIAlertView *rate = [[UIAlertView alloc]initWithTitle:@"Thank You" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [rate show];
    }

}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeAnimate];

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
