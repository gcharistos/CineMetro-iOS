//
//  RatingViewController.h
//  CineMetro
//
//  Created by George Haristos on 12/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface RatingViewController : UIViewController<UIGestureRecognizerDelegate,StarRatingViewDelegate,UIAlertViewDelegate>



- (IBAction)okButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *okbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic)  TQStarRatingView *ratingView;
-(void)initializeView:(NSInteger)counter :(NSString *)tablen :(NSMutableArray *)array :(NSString *)linepo;

@end
