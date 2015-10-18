//
//  LinesCollectionViewController.h
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinesPageViewController.h"
#import "HeaderCollectionView.h"

@interface LinesCollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property NSUInteger pageIndex;
@property LinesPageViewController *parentcontroller;
@end
