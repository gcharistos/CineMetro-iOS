//
//  AboutViewController.m
//  CineMetro
//
//  Created by George Haristos on 22/9/14.
//  Copyright (c) 2014 George Haristos. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
NSArray *textArray;
@synthesize aboutTextview;


- (void)viewDidLoad {
    [super viewDidLoad];
    aboutTextview.text = NSLocalizedString(@"about1",@"word");
    [aboutTextview setFont:[UIFont systemFontOfSize:14]];
    textArray = [[NSArray alloc]initWithObjects:@"Copyright (c) 2013 Matej Bukovinski.\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in  all copies or substantial portions of the Software. \nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.",/*second license*/@"Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc. (\"Apple\") in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of  this Apple software constitutes acceptance of these terms.  If you do not agree with these terms, please do not use, install, modify or redistribute this Apple software. In consideration of your agreement to abide by the following terms, and subject to these terms, Apple grants you a personal, non-exclusive license, under Apple's copyrights in this original Apple software (the \"Apple Software\"), to use, reproduce, modify and redistribute the Apple  Software, with or without modifications, in source and/or binary forms;  provided that if you redistribute the Apple Software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the Apple Software.  Neither the name, trademarks, service marks or logos of Apple Inc. may  be used to endorse or promote products derived from the Apple Software  without specific prior written permission from Apple.  Except as  expressly stated in this notice, no other rights or licenses, express or   implied, are granted by Apple herein, including but not limited to any  patent rights that may be infringed by your derivative works or by other works in which the Apple Software may be incorporated. The Apple Software is provided by Apple on an \"AS IS\" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\nCopyright (C) 2014 Apple Inc. All Rights Reserved.", nil];
   
    // Do any additional setup after loading the view.
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

-(void)viewDidLayoutSubviews{
    [scroller  setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320,1200)];
}

- (IBAction)mbprogresshudPressed:(id)sender {
    self.popViewController = [[LicenseViewController alloc] initWithNibName:@"LicenseViewController" bundle:nil];
    
    [self.popViewController showInView:self.navigationController.view  withController:self  withText:[textArray objectAtIndex:0] withColor:[UIColor whiteColor] withTextColor:[UIColor blackColor] animated:YES];
}

- (IBAction)reachabilityPressed:(id)sender {
    self.popViewController = [[LicenseViewController alloc] initWithNibName:@"LicenseViewController" bundle:nil];
    
    [self.popViewController showInView:self.navigationController.view  withController:self  withText:[textArray objectAtIndex:1] withColor:[UIColor whiteColor] withTextColor:[UIColor blackColor] animated:YES];
}

- (IBAction)contactPressed:(id)sender {
    NSString *recipients = [NSString stringWithFormat:@"mailto:geohararnea16@hotmail.com"];
    
    NSString *body = @"";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];

}

- (IBAction)ratebuttonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/jobsy/id933450618"]];

}
@end
