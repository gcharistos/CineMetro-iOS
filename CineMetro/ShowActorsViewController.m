//
//  ShowActorsViewController.m
//  CineMetro
//
//  Created by George Haristos on 11/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "ShowActorsViewController.h"
#import "HeaderView.h"

@interface ShowActorsViewController ()

@end

@implementation ShowActorsViewController
@synthesize list;
@synthesize directlist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return  1;
    }
    else{
        return list.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:105];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:106];
    if(indexPath.section == 0){
        label.text = [directlist objectForKey:@"Name"];
        imageview.image = [UIImage imageNamed:[directlist  objectForKey:@"Icon"]];
    }
    else{
      label.text = [[list objectAtIndex:indexPath.row]objectForKey:@"Name"];
      imageview.image = [UIImage imageNamed:[[list objectAtIndex:indexPath.row]objectForKey:@"Icon"]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title ;
        if(indexPath.section == 0){
            title = @"Σκηνοθέτης";
        }
        else{
            title = @"Ηθοποιοί";
        }
        headerView.headerTitle.text = title;
        
        reusableview = headerView;
    }
    
    
    
    return reusableview;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
