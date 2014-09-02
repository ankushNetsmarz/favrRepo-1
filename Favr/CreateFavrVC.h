//
//  CreateFavrVC.h
//  Favr
//
//  Created by Ankush on 30/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickContactVC.h"
#import "QuidProQuoVC.h"

@interface CreateFavrVC : UIViewController  <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>


@property (assign, nonatomic) int  editFlag;

@property (strong, nonatomic) IBOutlet UITextField *titlTxtFld;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextView *descTxtVew;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *descString;

@property (strong, nonatomic) IBOutlet UIButton *asapBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *NLTBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *AYECBtnObj;

@property (strong, nonatomic) IBOutlet UIButton *anonymousBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *ATFBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *ANTFBtnObj;

@property (strong, nonatomic) IBOutlet UIButton *firstBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *secondBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *fourthBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *fifthBtnObj;
@property (strong, nonatomic) IBOutlet UIButton *sixthBtnObj;

@property (strong, nonatomic) NSString *whenBtnString;
@property (strong, nonatomic) NSString *privicyBtnString;



- (IBAction)whenBtnAct:(UIButton *)sender;

- (IBAction)privicyBtnAct:(UIButton *)sender;

- (IBAction)backButtonAct:(UIBarButtonItem *)sender;
- (IBAction)pickContactBtnAct:(UIBarButtonItem *)sender;
- (IBAction)datePickerAct:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *datePickerObj;

@end
