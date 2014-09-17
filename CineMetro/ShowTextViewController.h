//
//  ShowTextViewController.h
//  CineMetro
//
//  Created by George Haristos on 10/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTextViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (nonatomic,weak) NSString *movieTitle;
@property (nonatomic,weak) NSString *text;
@end
