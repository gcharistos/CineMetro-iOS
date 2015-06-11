//
//  LinesCollectionViewController.m
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "LinesCollectionViewController.h"
#import "MainViewController.h"
#import "RedDetailsViewController.h"
#import "BlueDetailsViewController.h"
#import "GreenDetailsViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface LinesCollectionViewController ()

@end

@implementation LinesCollectionViewController
NSInteger  selectedIndex ;
NSArray *station;
NSMutableArray *titles;
UIColor *lineColor;
UIButton *previousButton;
UIButton *nextButton;
NSDictionary *db;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = -1;
    self.collectionView.delegate = self;

}


-(void)viewWillAppear:(BOOL)animated{
    selectedIndex = -1;
    titles = [[NSMutableArray alloc]init];
    NSString *title;
    NSString *path;
    if(self.pageIndex == 0){
      path = [[NSBundle mainBundle] pathForResource:@"RedLineStations" ofType:@"plist"];
        lineColor = [UIColor colorWithRed:(143/255.0) green:(1/255.0) blue:(1/255.0) alpha:1.0];
        self.collectionView.backgroundColor = lineColor;
    }
    else if(self.pageIndex == 1){
        path = [[NSBundle mainBundle] pathForResource:@"BlueLineStations" ofType:@"plist"];
        lineColor = [UIColor colorWithRed:(11/255.0) green:(63/255.0) blue:(100/255.0) alpha:1.0];
        self.collectionView.backgroundColor = lineColor;


    }
    else if(self.pageIndex == 2){
        path = [[NSBundle mainBundle] pathForResource:@"GreenLineStations" ofType:@"plist"];
        lineColor = [UIColor colorWithRed:(17/255.0) green:(85/255.0) blue:(51/255.0) alpha:1.0];
        self.collectionView.backgroundColor = lineColor;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    db = dict;
    NSArray *anns = [dict objectForKey:@"Stations"];
    station = anns; // initialize station variable
    
    [titles removeAllObjects];
    [self.collectionView reloadData];
    for(int i=0;i<anns.count;i++){
        NSString *positionString = [NSString stringWithFormat:@"%@ %i",NSLocalizedString(@"station",@"word"),i+1];
        title = positionString;
        [titles addObject:title];
    }
    [self.collectionView reloadData];
    
}



-(void)nextButtonTapped:(UITapGestureRecognizer *)sender{
    [self.parentcontroller goToNextView];
}
-(void)previousButtonTapped:(UITapGestureRecognizer *)sender{
    [self.parentcontroller goToPreviousView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UIImage *image;
    if(self.pageIndex != 2){
      image = [UIImage imageNamed:[[[station objectAtIndex:indexPath.row]objectForKey:@"Images"]objectAtIndex:0]];
    }
    else{
        NSArray *imagedictionary = [[station objectAtIndex:indexPath.row]objectForKey:@"Images"];
      image = [UIImage imageNamed:[[imagedictionary objectAtIndex:0]objectForKey:@"Image"]];
    }
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:105];
    UILabel *label = (UILabel *)[cell viewWithTag:106];
    if([locale isEqualToString:@"el"]){
         NSString *labelText = [NSString stringWithFormat:@"%@\n%@",[titles objectAtIndex:indexPath.row],[[station objectAtIndex:indexPath.row]objectForKey:@"GrSubtitle"]];
        label.text = labelText;
    }
    else if([locale isEqualToString:@"en"]){
        NSString *labelText = [NSString stringWithFormat:@"%@\n%@",[titles objectAtIndex:indexPath.row],[[station objectAtIndex:indexPath.row]objectForKey:@"EnSubtitle"]];
        label.text = labelText;
    }
    label.textColor = lineColor;
    imageview.image = image;
   // adjust cell width with frame width

    
    if ( IDIOM != IPAD ) {
                 cell.frame = CGRectMake(0,indexPath.row*185+100,self.view.frame.size.width,180);
    }

    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if([locale isEqualToString:@"el"]){
            NSString *labelText = [db objectForKey:@"GrName"];
            headerView.title.text = labelText;
            headerView.title.backgroundColor = lineColor;
            headerView.category.text = [db objectForKey:@"GrCategory"];
            headerView.category.backgroundColor = lineColor;
            headerView.category.layer.borderColor = [UIColor blackColor].CGColor;
            headerView.category.layer.borderWidth = 5.0;

        }
        else if([locale isEqualToString:@"en"]){
            NSString *labelText = [db objectForKey:@"EnName"];
            headerView.title.text = labelText;
            headerView.title.backgroundColor = lineColor;
            headerView.category.text = [db objectForKey:@"EnCategory"];
            headerView.category.backgroundColor = lineColor;
            headerView.category.layer.borderColor = [UIColor blackColor].CGColor;
            headerView.category.layer.borderWidth = 5.0;
        }
        
        
        


        reusableview = headerView;
    }
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.parentcontroller setStationAndIndex:indexPath.row : station ];
    if(self.pageIndex == 0){
        selectedIndex = indexPath.row;
        [self.parentcontroller performSegueWithIdentifier:@"detailSegue3" sender:nil];
    }
    else if(self.pageIndex == 1){
        selectedIndex = indexPath.row;
        [self.parentcontroller performSegueWithIdentifier:@"detailSegue4" sender:nil];
    }
    else if(self.pageIndex == 2){
        selectedIndex = indexPath.row;
        [self.parentcontroller performSegueWithIdentifier:@"detailSegue5" sender:nil];
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue5"]){
        GreenDetailsViewController *dest = segue.destinationViewController;
        dest.indexPath = selectedIndex;
    }
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
