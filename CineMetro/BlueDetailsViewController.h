//
//  BlueDetailsViewController.h
//  CineMetro
//
//  Created by George Haristos on 31/7/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewController.h"
#import <MapKit/MapKit.h>

@interface BlueDetailsViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,MKMapViewDelegate>{
    IBOutlet UIScrollView *scroller;
}

@property  NSInteger position;
@property (strong,nonatomic) RatingViewController *popViewController;
- (IBAction)rateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *actorsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *directorsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *directorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *info;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end

