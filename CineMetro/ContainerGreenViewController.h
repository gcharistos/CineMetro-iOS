//
//  ContainerBlueViewController.h
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreenDetailsViewController.h"

@interface ContainerGreenViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property GreenDetailsViewController *parentController;
@property (strong, nonatomic) NSArray *pageImages;
- (void)goToNextView;
-(void)goToPreviousView;
@end
