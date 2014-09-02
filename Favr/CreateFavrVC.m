//
//  CreateFavrVC.m
//  Favr
//
//  Created by Ankush on 30/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "CreateFavrVC.h"

@interface CreateFavrVC ()
{
    UIActionSheet *pickerViewPopup;
    UIDatePicker *pickerView;
}
@end

@implementation CreateFavrVC

@synthesize titlTxtFld, descTxtVew;
@synthesize titleString, descString;
@synthesize editFlag;
@synthesize whenBtnString, privicyBtnString;

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
    
    
    NSLog(@"titleString %@", titleString);
    NSLog(@"descString %@", descString);
    
    if (titleString.length >= 1)
    {
        self.titlTxtFld.text = titleString;
        self.descTxtVew.text = descString;
        _descriptionLabel.text = @"";
    }
    
    NSLog(@"titleTxtField %@", titlTxtFld.text);
    NSLog(@"descTxtVew %@", descTxtVew.text);
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"appDelegate.groupSelected%i", appDelegate.groupSelected);
    
    self.titlTxtFld.delegate = self;
    self.descTxtVew.delegate = self;
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    self.navigationBar.backgroundColor = [UIColor redColor];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.asapBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [self.NLTBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.AYECBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.anonymousBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [self.ATFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.ANTFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    
    whenBtnString = @"ASAP";
    privicyBtnString = @"0";
    
//    [self.asapBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [self.NLTBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [self.AYECBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [self.anonymousBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [self.ATFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//    [self.ANTFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// resign keyboard from first responder if user touch on view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self.view];
//    NSLog(@"X location: %f", point.x);
//    NSLog(@"Y Location: %f",point.y);
    
    [self.titlTxtFld resignFirstResponder];
    [self.descTxtVew resignFirstResponder];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// textview resign first responder then enter is pressed
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.descriptionLabel.text = @"";
    
    return YES;
}

#pragma mark OtherMethod

// pop to previous view controller
- (IBAction)backButtonAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)pickContactBtnAct:(UIBarButtonItem *)sender {
//    PickContactVC *pickContactVC = [[PickContactVC alloc] init];
//    [self.navigationController pushViewController:pickContactVC animated:YES];
//    pickContactVC.favrTitleString = self.titleTxtFld.text;
//    pickContactVC.favrDescriptionString = self.descTxtVew.text;
    if ([self.titlTxtFld.text length] <=0 || [self.titlTxtFld.text isEqualToString:@""])
    {
        [self showAlert:@"Message" :@"Please enter favr title"];
    }
    else if ([self.descTxtVew.text length] <= 0 || [self.descTxtVew.text isEqualToString:@""] )
    {
        [self showAlert:@"Message" :@"Please enter favr description"];
    }
    else
    {
        QuidProQuoVC *quidProQuoVC = [[QuidProQuoVC alloc] init];
        quidProQuoVC.favrTitleString = self.titlTxtFld.text;
        quidProQuoVC.favrDescriptionString = self.descTxtVew.text;
        quidProQuoVC.editflag = editFlag;
        quidProQuoVC.whenString = whenBtnString;
        quidProQuoVC.privicyString = privicyBtnString;
        [self.navigationController pushViewController:quidProQuoVC animated:YES];
    }

}

// date picker view
- (IBAction)datePickerAct:(UIButton *)sender {
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.hidden = NO;
    pickerView.date = [NSDate date];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
//    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [pickerViewPopup addSubview:pickerToolbar];
    [pickerViewPopup addSubview:pickerView];
    [pickerViewPopup showInView:self.view];
    [pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];
    
    
}

-(void)showAlert:(NSString *)title :(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}


// when radio button action
- (IBAction)whenBtnAct:(UIButton *)sender {
    if (sender.tag == 1)
    {
        [self.asapBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.NLTBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.AYECBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        whenBtnString = @"ASAP";
    }
    else if (sender.tag == 2)
    {
        [self.asapBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.NLTBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.AYECBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self datePickerAct:self.NLTBtnObj];
        whenBtnString = self.datePickerObj.titleLabel.text;
    }
    else if (sender.tag == 3)
    {
        [self.asapBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.NLTBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.AYECBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        whenBtnString = @"At your Earliest convernience";
    }
    
}

// privicy radio button action
- (IBAction)privicyBtnAct:(UIButton *)sender
{
    if (sender.tag == 4)
    {
        [self.anonymousBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.ATFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.ANTFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        privicyBtnString = @"0";
    }
    else if (sender.tag == 5)
    {
        [self.anonymousBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.ATFBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [self.ANTFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        privicyBtnString = @"1";
    }
    else if (sender.tag == 6)
    {
        [self.anonymousBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.ATFBtnObj setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [self.ANTFBtnObj setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        privicyBtnString = @"2";
    }
}

//dismiss date picker view controller
-(void)doneButtonPressed:(id)sender{
    //Do something here here with the value selected using [pickerView date] to get that value
    
    [self.datePickerObj setTitle:[NSString stringWithFormat:@"%@",[pickerView date]] forState:UIControlStateNormal];
    NSLog(@"%@",[pickerView date]);
    
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)cancelButtonPressed:(id)sender{
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}
@end
