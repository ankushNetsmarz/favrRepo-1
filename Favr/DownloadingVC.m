//
//  DownloadingVC.m
//  Favr
//
//  Created by Ankush on 14/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "DownloadingVC.h"

@interface DownloadingVC ()

@end

@implementation DownloadingVC
@synthesize downloadedId;

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
    
    [QBContent TDownloadFileWithBlobID:downloadedId delegate:self];
}


- (void)completedWithResult:(Result *)result{
    // Download file result
    if(result.success && [result isKindOfClass:QBCFileDownloadTaskResult.class]){
        // extract image
        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
        UIImage *image = [UIImage imageWithData:res.file];
        self.downloadedImage.image = image;
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bactBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
