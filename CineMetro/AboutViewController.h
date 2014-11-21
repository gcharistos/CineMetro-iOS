//
//  AboutViewController.h
//  CineMetro
//
//  Created by George Haristos on 22/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LicenseViewController.h"

@interface AboutViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView *scroller;

}
@property (strong,nonatomic) LicenseViewController *popViewController;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextview;


- (IBAction)mbprogresshudPressed:(id)sender;

- (IBAction)reachabilityPressed:(id)sender;
- (IBAction)contactPressed:(id)sender;
- (IBAction)ratebuttonPressed:(id)sender;


@end
