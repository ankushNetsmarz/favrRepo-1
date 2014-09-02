//
//  ChatVideoPlayVC.h
//  Favr
//
//  Created by Ravi on 25/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ChatVideoPlayVC : UIViewController
{
    MPMoviePlayerController *mpMovieplayer;
}

@property(nonatomic,retain)NSString *strVideoURL;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
