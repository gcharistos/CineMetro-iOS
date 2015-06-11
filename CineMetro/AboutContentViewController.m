//
//  AboutContentViewController.m
//  CineMetro
//
//  Created by George Haristos on 29/11/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "AboutContentViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface AboutContentViewController ()
@property (strong, nonatomic)  UITextView *textview;
@end

@implementation AboutContentViewController
@synthesize imageview;
@synthesize textview;
CGRect rect;
CGFloat heightOfText;
- (void)viewDidLoad {
    [super viewDidLoad];
    imageview.image = [UIImage imageNamed:self.imageFile];
    heightOfText = [self heightOfTextViewWithString:self.text withFont:[UIFont systemFontOfSize:18] andFixedWidth:self.view.frame.size.width];
    if(IDIOM == IPAD){
        textview = [[UITextView alloc]initWithFrame:CGRectMake(0,imageview.frame.origin.y+imageview.frame.size.height+150,self.view.frame.size.width,heightOfText)];
    }
    else{
      textview = [[UITextView alloc]initWithFrame:CGRectMake(0,imageview.frame.origin.y+imageview.frame.size.height+30,self.view.frame.size.width,heightOfText)];
    }
    textview.text = self.text;
    [textview setFont:[UIFont systemFontOfSize:18]];
    textview.editable = NO;
    textview.selectable = NO;
    textview.scrollEnabled = NO;
    textview.textColor = [UIColor colorWithRed:0.561 green:0.004 blue:0.004 alpha:1.0];
    textview.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
    [scroller addSubview:textview];

       // Do any additional setup after loading the view.
}



- (CGFloat)heightOfTextViewWithString:(NSString *)string
                             withFont:(UIFont *)font
                        andFixedWidth:(CGFloat)fixedWidth
{
    UITextView *tempTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, fixedWidth, 1)];
    tempTV.text = [string uppercaseString];
    tempTV.font = font;
    
    CGSize newSize = [tempTV sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tempTV.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tempTV.frame = newFrame;
    
    return tempTV.frame.size.height;
}






-(void)viewDidLayoutSubviews{
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width,400+textview.frame.size.height)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
