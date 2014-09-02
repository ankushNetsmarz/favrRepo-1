//
//  VideoTesting.m
//  Favr
//
//  Created by Ankush on 01/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "VideoTesting.h"

@interface VideoTesting ()

@end

@implementation VideoTesting

@synthesize uploadImageView, downloadImageView;

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
//    NSData *data = [@"Working at Parse is great!" dataUsingEncoding:NSUTF8StringEncoding];
//    PFFile *file = [PFFile fileWithName:@"resume.txt" data:data];
//    [file saveInBackground];
//    
//    
//    PFObject *jobApplication = [PFObject objectWithClassName:@"JobApplication"];
//    jobApplication[@"applicantName"] = @"Joe Smith";
//    jobApplication[@"applicantResumeFile"] = file;
//    [jobApplication saveInBackground];
//    
//    PFFile *applicantResume = anotherApplication[@"applicantResumeFile"];
//    NSData *resumeData = [applicantResume getData];
    
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
    PFFile *imageFile = [PFFile fileWithName:@"video.mp4" data:imageData];
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    userPhoto[@"imageName"] = @"My trip to Hawaii!";
    userPhoto[@"imageFile"] = imageFile;
    [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Object id %@",[userPhoto objectId]);
        PFFile *userImageFile = userPhoto[@"imageFile"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageDataaa, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"Object id %@", [userPhoto objectId]);
                 NSLog(@"data is %@", imageDataaa);
                 NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"video.mp4"];
                 if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                 {
                     [imageDataaa writeToFile:filePath atomically:YES];
                 }
             }
         }
         ];
    }];
    
}


-(void) testingMethod
{
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
    PFFile *imageFile = [PFFile fileWithName:@"video.mp4" data:imageData];
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    userPhoto[@"imageName"] = @"My trip to Hawaii!";
    userPhoto[@"imageFile"] = imageFile;
    [userPhoto saveInBackground];
    NSLog(@"Object id %@", [userPhoto objectId]);
    PFFile *userImageFile = userPhoto[@"imageFile"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (!error)
        {
            NSLog(@"Object Id %@", [userPhoto objectId]);
            NSLog(@"Data is %@", data);
        }
    }
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
