//
//  QuidProQuoVC.m
//  Favr
//
//  Created by Ankush on 11/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "QuidProQuoVC.h"

@interface QuidProQuoVC ()

@end

@implementation QuidProQuoVC

@synthesize favrTitleString, favrDescriptionString;
@synthesize editflag;

@synthesize whenString, privicyString, quidProString;


#pragma mark ViewLifeCycle

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
    // Do any additional setup after loading the view from its nib.
    
    self.quidProDesc.delegate = self;
    self.quidProTitle.delegate = self;
    self.sliderView.hidden = YES;
    
    
    self.goodKarmaInfoBtnObj.hidden = YES;
    self.caseInfoBtnObj.hidden = YES;
    self.giftCardInfoBtnObj.hidden = YES;
    self.drinkInfoBtnObj.hidden = YES;
    
    
    
   
    quidProTitleArray = [[NSArray alloc] initWithObjects:@"Its new way of saying 'Thank You'", @"Award cash to helper in return of Favr", @"Award gift card to helper in return of Favr", @"Promise of paying back", nil];
    quidProImageArray = [[NSArray alloc] initWithObjects:@"goodkarmaQuidPro1", @"CaseQuidPro1", @"giftcardQuidPro1", @"drinkQuidPro1", nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.goodKarmaBtnObj.enabled = NO;
    self.goodKarmaImgVew.alpha = 0.6;
    [self.goodKarmaBtnObj setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
    quidProString = self.goodKarmaBtnObj.titleLabel.text;
    
    _goodKarmaBtnObj.layer.cornerRadius = 130/2;
    _goodKarmaBtnObj.layer.masksToBounds = YES;
    
    self.cashBtnObj.enabled = YES;
    self.caseImgVew.alpha = 1.0;
    [self.cashBtnObj setBackgroundColor:[UIColor clearColor]];
    
    _cashBtnObj.layer.cornerRadius = 130/2;
    _cashBtnObj.layer.masksToBounds = YES;

    
    self.giftCardBtnObj.enabled = YES;
    self.giftCardImgVew.alpha = 1.0;
    [self.giftCardBtnObj setBackgroundColor:[UIColor clearColor]];
    _giftCardBtnObj.layer.cornerRadius = 130/2;
    _giftCardBtnObj.layer.masksToBounds = YES;
    
    self.drinkBtnObj.enabled = YES;
    self.drinkImgVew.alpha = 1.0;
    [self.drinkBtnObj setBackgroundColor:[UIColor clearColor]];
    _drinkBtnObj.layer.cornerRadius = 130/2;
    _drinkBtnObj.layer.masksToBounds = YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// resign keyboard first responder when enter button is pressed
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark OtherMethod

// quid pro selection method
- (IBAction)quidProBtnAct:(UIButton *)sender
{
    if (sender.tag == 11)
    {
        self.goodKarmaBtnObj.enabled = NO;
        self.goodKarmaImgVew.alpha = 0.6;
        [self.goodKarmaBtnObj setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
        
        
        self.cashBtnObj.enabled = YES;
        self.caseImgVew.alpha = 1.0;
        [self.cashBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.giftCardBtnObj.enabled = YES;
        self.giftCardImgVew.alpha = 1.0;
        [self.giftCardBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.drinkBtnObj.enabled = YES;
        self.drinkImgVew.alpha = 1.0;
        [self.drinkBtnObj setBackgroundColor:[UIColor clearColor]];
        
        quidProString = self.goodKarmaBtnObj.titleLabel.text;
        
    }
    else if (sender.tag == 12)
    {
        
        self.goodKarmaBtnObj.enabled = YES;
        self.goodKarmaImgVew.alpha = 1.0;
        [self.goodKarmaBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.cashBtnObj.enabled = NO;
        self.caseImgVew.alpha = 0.6;
        [self.cashBtnObj setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
        
        self.giftCardBtnObj.enabled = YES;
        self.giftCardImgVew.alpha = 1.0;
        [self.giftCardBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.drinkBtnObj.enabled = YES;
        self.drinkImgVew.alpha = 1.0;
        [self.drinkBtnObj setBackgroundColor:[UIColor clearColor]];
        
        quidProString = self.cashBtnObj.titleLabel.text;
        
    }
    else if (sender.tag == 13)
    {
        
        self.goodKarmaBtnObj.enabled = YES;
        self.goodKarmaImgVew.alpha = 1.0;
        [self.goodKarmaBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.cashBtnObj.enabled = YES;
        self.caseImgVew.alpha = 1.0;
        [self.cashBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.giftCardBtnObj.enabled = NO;
        self.giftCardImgVew.alpha = 0.6;
        [self.giftCardBtnObj setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
        
        self.drinkBtnObj.enabled = YES;
        self.drinkImgVew.alpha = 1.0;
        [self.drinkBtnObj setBackgroundColor:[UIColor clearColor]];
        
        quidProString = self.giftCardBtnObj.titleLabel.text;
    }
    else if (sender.tag == 14)
    {
        
        self.goodKarmaBtnObj.enabled = YES;
        self.goodKarmaImgVew.alpha = 1.0;
        [self.goodKarmaBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.cashBtnObj.enabled = YES;
        self.caseImgVew.alpha = 1.0;
        [self.cashBtnObj setBackgroundColor:[UIColor clearColor]];
        
        self.giftCardBtnObj.enabled = YES;
        self.giftCardImgVew.alpha = 1.0;
        [self.giftCardBtnObj setBackgroundColor:[UIColor clearColor]];
        
        
        self.drinkBtnObj.enabled = NO;
        self.drinkImgVew.alpha = 0.6;
        [self.drinkBtnObj setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
        
        quidProString = self.drinkBtnObj.titleLabel.text;
        
    }
}


// close popup when close button is pressed
// functionality is removed in latest build
- (IBAction)closePopUp:(UIButton *)sender {
    
    self.goodKarmaInfoBtnObj.enabled = YES;
    self.caseInfoBtnObj.enabled = YES;
    self.giftCardInfoBtnObj.enabled = YES;
    self.drinkInfoBtnObj.enabled = YES;
    self.backBtnObj.enabled = YES;
    self.nextBtnObj.enabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sliderView.frame =  CGRectMake(13, 86, 0, 0);
//        self.sliderImageView.frame = CGRectMake(65, 85, 0, 0);
        [self.sliderView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.sliderView setHidden:YES];
    }];

}

// info of quid pro selected item
// functionality is removed in latest build
- (IBAction)quidProInfoAct:(UIButton *)sender {
    
    self.goodKarmaInfoBtnObj.enabled = NO;
    self.caseInfoBtnObj.enabled = NO;
    self.giftCardInfoBtnObj.enabled = NO;
    self.drinkInfoBtnObj.enabled = NO;
    self.backBtnObj.enabled = NO;
    self.nextBtnObj.enabled = NO;
    
    static int count;
    count++;
    
    
    
    NSLog(@"sender.tag %i", sender.tag);
    self.quidProInfoDetailsLabel.text = [quidProTitleArray objectAtIndex:sender.tag - 1];
    self.sliderImageView.image = [UIImage imageNamed:[quidProImageArray objectAtIndex:sender.tag - 1]];
    
//    if(count % 2 == 0)
//    {
        [self.sliderView setHidden:NO];
        self.sliderView.frame =  CGRectMake(130, 20, 0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderView.frame =  CGRectMake(13, 86, 295, 370);
//            self.sliderImageView.frame = CGRectMake(65, 85, 180, self.view.frame.size.height-160);
            self.sliderView.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
        
//        /*To hide*/
//        
////        [UIView animateWithDuration:0.25 animations:^{
////            self.sliderView.frame =  CGRectMake(130, 30, 100, 200);
////        }];
////        
////        sender.tag = 102;
//    }
//    else
//    {
//        
//        //        [UIView animateWithDuration:0.25 animations:^{
////            self.sliderView.frame =  CGRectMake(130, 480, 100, 200);
////        }];
////        sender.tag = 101;  
//    }
}

// navigate to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// goes to next view to pick contact from list
- (IBAction)nextBtnAction:(UIBarButtonItem *)sender {
    if (editflag == 1)
    {
        
        //appDelegate.groupSelected == 1
        NSString *strGrpFavr=   [[NSUserDefaults standardUserDefaults]objectForKey:@"isGrpFavr"];
        if ([strGrpFavr integerValue]==0) {
            appDelegate().groupSelected = 1;
        }
        else{
            appDelegate().groupSelected = 3;

        }
        
        PickContactVC *pickContactVC = [[PickContactVC alloc] init];
        pickContactVC.favrTitleString = favrTitleString;
        pickContactVC.favrDescriptionString = favrDescriptionString;
        pickContactVC.whenString = whenString;
        pickContactVC.privicyString = privicyString;
        pickContactVC.quidProString = quidProString;
        [self.navigationController pushViewController:pickContactVC animated:YES];
        
        
//    NSString *strhelperID=    [[NSUserDefaults standardUserDefaults]objectForKey:@"helperId"];
//    NSString *strhelpeeID=    [[NSUserDefaults standardUserDefaults]objectForKey:@"helpeeId"];
//     NSString *strGrpFavr=   [[NSUserDefaults standardUserDefaults]objectForKey:@"isGrpFavr"];
//    NSString *strSinglefavr=    [[NSUserDefaults standardUserDefaults]objectForKey:@"isSingleFavr"];
//      NSString *strMulticastFavr=    [[NSUserDefaults standardUserDefaults]objectForKey:@"isMulticastFavr"];
//        [appDelegate() showMBHUD:@"Please Wait..."];
//        
//        [PFCloud callFunctionInBackground:@"createFavr"
//                           withParameters:@{
//                                            @"helpeeId" : strhelpeeID,
//                                            @"favrTitle" : self.favrTitleString,
//                                            @"favrDescription" : self.favrDescriptionString,
//                                            @"helper" : strhelperID,
//                                            @"singleFavr" : strSinglefavr,
//                                            @"multicastFavr" : strMulticastFavr,
//                                            @"grpFavr" : strGrpFavr,
//                                            @"when": whenString,
//                                            @"isForwardable":privicyString,
//                                            @"quidPro": quidProString
//                                            }
//                                    block:^(NSString *results, NSError *error) {
//                                        
//                                        [appDelegate() dismissMBHUD];
//                                        [self showStatus:@"Favr Updated Successfully" timeout:5];
//                                        
//                                    }];
        
    }
    else
    {
        appDelegate().editType = editNo;
        PickContactVC *pickContactVC = [[PickContactVC alloc] init];
        pickContactVC.favrTitleString = favrTitleString;
        pickContactVC.favrDescriptionString = favrDescriptionString;
        pickContactVC.whenString = whenString;
        pickContactVC.privicyString = privicyString;
        pickContactVC.quidProString = quidProString;
        [self.navigationController pushViewController:pickContactVC animated:YES];
    }
    
}
- (void)showStatus:(NSString *)message timeout:(double)timeout {
    statusAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message:message
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
    [statusAlert show];
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(timerExpired:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)timerExpired:(NSTimer *)timer {
    [statusAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:array.count-3] animated:YES];

}
@end
