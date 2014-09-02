//
//  ChatImageScrollView.h
//  Favr
//
//  Created by Ankush on 01/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"

@interface ChatImageScrollView : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *imageIdArray;
    NSString *docPath, *filePath;
    UIPinchGestureRecognizer *pgr;
    UIView *view1;
    MPMoviePlayerController *moviePlayerController;
}
- (IBAction)backBtnAct:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSString *currentImageId;
@property (strong, nonatomic) NSString *currentImageName;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)nextBtnAct:(UIButton *)sender;

@end
