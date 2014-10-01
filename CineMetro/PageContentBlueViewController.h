//
//  PageContentBlueViewController.h
//  CineMetro
//
//  Created by George Haristos on 2/10/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentBlueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@end
