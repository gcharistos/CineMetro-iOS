//
//  fbViewController.h
//  CineMetro
//
//  Created by George Haristos on 18/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface fbViewController : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *fbview;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)buttonpressed:(id)sender;

@end
