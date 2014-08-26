//
//  GreenDetailsViewController.m
//  CineMetro
//
//  Created by George Haristos on 19/8/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "GreenDetailsViewController.h"

@interface GreenDetailsViewController ()
@property NSInteger position1;

@end

@implementation GreenDetailsViewController
@synthesize position1;
@synthesize position;
@synthesize textview;
NSMutableArray *images;
NSArray *currentList;



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
    images = [[NSMutableArray alloc]init];
    
    position1 = position;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GreenLineStations" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *anns = [dict objectForKey:@"Stations"];
    currentList = anns;
    self.navigationItem.title =[[currentList objectAtIndex:position1]objectForKey:@"Subtitle"];
    textview.text = [[anns objectAtIndex:position1]objectForKey:@"text"];
    images = [[anns objectAtIndex:position1]objectForKey:@"Images"];
    NSLog(@"%i",images.count);

    // Do any additional setup after loading the view.
}

- (IBAction)rateButtonPressed:(id)sender {
    UIAlertView *rate = [[UIAlertView alloc]initWithTitle:@"Αξιολογήστε την Στάση" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"1",@"2",@"3",@"4",@"5", nil];
    rate.tag = 100;
    [rate show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100 && buttonIndex != 0){
        NSLog(@"%i",buttonIndex);
        UIAlertView *rate = [[UIAlertView alloc]initWithTitle:@"Ευχαριστούμε Πολύ" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [rate show];
        
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return images.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"tCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:108];
    imageview.image =[ UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    return cell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
