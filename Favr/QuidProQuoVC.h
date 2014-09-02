//
//  QuidProQuoVC.h
//  Favr
//
//  Created by Ankush on 11/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickContactVC.h"

@interface QuidProQuoVC : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    NSString *favrTitleStr, *favrDescStr;
    NSArray *quidProTitleArray ;
    NSArray *quidProImageArray;
     UIAlertView *statusAlert;
}
@property (strong, nonatomic) IBOutlet UITextField *quidProTitle;
@property (strong, nonatomic) IBOutlet UITextView *quidProDesc;

@property (strong, nonatomic) IBOutlet UILabel *quidProInfoDetailsLabel;
@property (strong, nonatomic) NSString *favrTitleString;
@property (strong, nonatomic) NSString *favrDescriptionString;
@property (assign, nonatomic) int editflag;
@property (strong, nonatomic) IBOutlet UIView *sliderView;

@property (strong, nonatomic) IBOutlet UIButton *goodKarmaBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *goodKarmaInfoBtnObj;
@property (strong, nonatomic) IBOutlet UIImageView *goodKarmaImgVew;

@property (strong, nonatomic) IBOutlet UIButton *cashBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *caseInfoBtnObj;
@property (strong, nonatomic) IBOutlet UIImageView *caseImgVew;

@property (strong, nonatomic) IBOutlet UIButton *giftCardBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *giftCardInfoBtnObj;
@property (strong, nonatomic) IBOutlet UIImageView *giftCardImgVew;

@property (strong, nonatomic) IBOutlet UIButton *drinkBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *drinkInfoBtnObj;
@property (strong, nonatomic) IBOutlet UIImageView *drinkImgVew;

@property (strong, nonatomic) IBOutlet UIImageView *sliderImageView;
@property (strong, nonatomic) IBOutlet UIButton *closePopupObj;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBtnObj;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtnObj;


@property (strong, nonatomic) NSString *whenString;
@property (strong, nonatomic) NSString *privicyString;
@property (strong, nonatomic) NSString *quidProString;

- (IBAction)quidProBtnAct:(UIButton *)sender;

- (IBAction)closePopUp:(UIButton *)sender;
- (IBAction)quidProInfoAct:(UIButton *)sender;
- (IBAction)backBtnAct:(UIBarButtonItem *)sender;
- (IBAction)nextBtnAction:(UIBarButtonItem *)sender;

@end
