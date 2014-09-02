//
//  ChatVideoPlayVC.m
//  Favr
//
//  Created by Ravi on 25/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "ChatVideoPlayVC.h"

@implementation ChatVideoPlayVC
@synthesize strVideoURL = _strVideoURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_strVideoURL]];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}

- (IBAction)fn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Web View Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [appDelegate() dismissMBHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [appDelegate() showMBHUD:@"Please Wait....."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	 [appDelegate() dismissMBHUD];
}




@end
