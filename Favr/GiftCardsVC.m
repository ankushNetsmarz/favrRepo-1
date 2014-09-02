//
//  GiftCardsVC.m
//  Favr
//
//  Created by Ravi on 28/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "GiftCardsVC.h"



@implementation GiftCardsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.amazon.in/b/ref=mh_3704982031_dri_2_4048867031?rh=n%%3A3704982031%%2Cn%%3A%%213704983031%%2Cn%%3A3704982031%%2Cn%%3A%%213704983031&ie=UTF8&node=4048867031"]];
    
    [appDelegate() showMBHUD:@"Please Wait....."];

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}

- (IBAction)fn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)referesh:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.amazon.in/b/ref=mh_3704982031_dri_2_4048867031?rh=n%%3A3704982031%%2Cn%%3A%%213704983031%%2Cn%%3A3704982031%%2Cn%%3A%%213704983031&ie=UTF8&node=4048867031"]];
    
    [appDelegate() showMBHUD:@"Please Wait....."];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark Web View Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [appDelegate() dismissMBHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [appDelegate() dismissMBHUD];
}



@end
