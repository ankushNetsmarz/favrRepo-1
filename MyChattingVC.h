//
//  MyChattingVC.h
//  Favr
//
//  Created by Taranjit Singh on 01/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "Quickblox/Quickblox.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
typedef enum {
    photos,
    videos,
} libraryType;
@interface MyChattingVC : UIViewController<HPGrowingTextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBActionStatusDelegate>
{
    AppDelegate *appDelegate;
    NSMutableArray *tempArr;
    int uploadedImageId;
    NSData *ImageData;
    BOOL isSelectImage;
    BOOL iscallImagePicker;
    BOOL isCalltoSeeVideoPics;
    NSString *imagename;
    
}
@property (nonatomic, strong) QBUUser *opponent;
@property(assign,nonatomic)libraryType libraryType;
@property (nonatomic,strong) HPGrowingTextView* textView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,weak)IBOutlet UINavigationBar* navBar;
@property(nonatomic,strong)UIViewController* prevVC;
@property (nonatomic, strong) QBChatDialog *dialog;

@property (strong, nonatomic) IBOutlet UIButton *attachmentBtnObj;
- (IBAction)attactmentBtnAct:(UIButton *)sender;

@end