//
//  ContainerBlueViewController.h
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerBlueViewController : UIViewController<UIPageViewControllerDataSource>
- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@end
