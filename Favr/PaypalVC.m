//
//  PaypalVC.m
//  Favr
//
//  Created by Ravi on 28/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "PaypalVC.h"

@implementation PaypalVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.paypal.com/"]];
    
    [appDelegate() showMBHUD:@"Please Wait....."];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}

- (IBAction)fn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)referesh:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.paypal.com/"]];
    
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
