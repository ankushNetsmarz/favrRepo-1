//
//  OrderViewController.m
//  photomoby
//
//  Created by Signity Solutions on 26/11/13.
//  Copyright (c) 2013 Signity Solutions. All rights reserved.
//

#import "OrderViewController.h"
#define kPayPalClientId       @"AYJYAhAKTqJDQ4nujiWEBkWxuiuYb5hfiuP2F9vNRJN4uPSYULYZXF_lcSTN"
#define kPayPalReceiverEmail  @"gurpreet@signitysolutions.co.in"
#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@implementation OrderViewController
@synthesize environment         =_environment;
@synthesize acceptCreditCards   =_acceptCreditCards;
@synthesize completedPayment    =_completedPayment;
@synthesize orderType           =_orderType;
@synthesize ovCallFrom          =_ovCallFrom;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    /***
     * Background ImageView
     **/
    UIImageView *_bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height)];
    _bgImageView.backgroundColor=[UIColor whiteColor];
 //   _bgImageView.image=BackgroundImage;
    [self.view addSubview:_bgImageView];
    
    /***
     * Back Button
     **/
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor=[UIColor redColor];
    _backBtn.frame=CGRectMake(6.0, 4.0, 67.0, 30.0);
    _backBtn.center=CGPointMake(self.view.center.x, 19.0);
    [_backBtn setImage:[UIImage imageNamed:@"back_btn1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
   
    /***
     * Price Label
     **/
    UILabel *_priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90.0,13.0, 90.0, 30.0)];
    _priceLabel.backgroundColor=[UIColor clearColor];
    _priceLabel.textAlignment=NSTextAlignmentCenter;
    _priceLabel.textColor=[UIColor colorWithRed:81.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0];
    _priceLabel.font=[UIFont fontWithName:@"SourceSansPro-Regular" size:24.0];
    [self.view addSubview:_priceLabel];
    
    /***
     * Item Description
     **/
    UILabel *_descriptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90.0,37.0, 90.0, 17.0)];
    _descriptionLabel.backgroundColor=[UIColor clearColor];
    _descriptionLabel.textAlignment=NSTextAlignmentCenter;
    _descriptionLabel.textColor=[UIColor colorWithRed:81.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0];
    _descriptionLabel.font=[UIFont fontWithName:@"SourceSansPro-Light" size:13.0];
    [self.view addSubview:_descriptionLabel];
    
    if (_orderType==MagazineCoverOrder) {
        _priceLabel.text=@"$9.99";
        _descriptionLabel.text=@"(8x10 size)";
    }
    else if (_orderType==MemoryMateOrder){
        _priceLabel.text=@"$9.99";
        _descriptionLabel.text=@"(8x10 size)";
    }
    else if (_orderType==TeamPotraitOrder){
        _priceLabel.text=@"$9.99";
        _descriptionLabel.text=@"(8x10 size)";
    }
    else{
        _priceLabel.text=@"$12.99";
        _descriptionLabel.text=@"(8 cards)";
    }
    
    /***
     * Header Label
     **/
    UILabel *_titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(14.0, 40.0, 300.0, 30.0)];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor colorWithRed:81.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0];
    _titleLabel.font=[UIFont fontWithName:@"SourceSansPro-Light" size:24.0];
    _titleLabel.text=@"ORDER";
    [self.view addSubview:_titleLabel];
    
    /***
     * Custom Keyboard
     **/
    _customKeyBoard=[[CustomKeyboard alloc]init];
    _customKeyBoard.delegate=self;
   
    /***
     * TableView
     **/
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 70.0, 320.0, self.view.frame.size.height-70) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    /***
     * PayPal intialization
     **/
    self.acceptCreditCards = YES;
    self.environment = PayPalEnvironmentNoNetwork;
    [PayPalMobile initializeWithClientIdsForEnvironments:@{
                                                           PayPalEnvironmentProduction : self.environment,
                                                           PayPalEnvironmentSandbox : kPayPalClientId
                                                           
                                                           }];
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Favr.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    
    
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.environment = kPayPalEnvironment;

    

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:self.environment];
}

#pragma mark ----------------------***--------------------
#pragma mark TableView delegate/Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0)
        return 55.0;
    else if(indexPath.section==3 && indexPath.row==0)
        return 55;
    else
        return 40.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if (section==0)
       return 7;
   else if (section==1)
        return 1;
   else
       return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *_cellIdentifier=[NSString stringWithFormat:@"%i_%i",indexPath.row,indexPath.section];
    UITableViewCell *_cell=[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (_cell==nil) {
        _cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
        _cell.selectionStyle=UITableViewCellSelectionStyleNone;
        _cell.backgroundColor=[UIColor clearColor];
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 140.0, 17) withText:@"Shipping Address" withFont:@"SourceSansPro-Bold" withSize:14.0];
                [_cell.contentView addSubview:_lbl];
                
                _lbl=[self createLabelwithRect:CGRectMake(20.0, 15.0, 90.0, _cell.contentView.frame.size.height) withText:@"Name*" withFont:@"SourceSansPro-Light" withSize:14.0];
                [_cell.contentView addSubview:_lbl];
                
                _nameTF=[self createTextFieldWithFrame:CGRectMake(90, 22.0, 320.0-105, 30.0) withPlaceHolder:@""];
                [_nameTF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:NO :YES]];
                [_cell.contentView addSubview:_nameTF];
            }
          else  if (indexPath.row==1) {
                UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"Street 1*" withFont:@"SourceSansPro-Light" withSize:14.0];
                [_cell.contentView addSubview:_lbl];
                
                _street1TF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
                [_street1TF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :YES]];
                [_cell.contentView addSubview:_street1TF];
            }
           else if (indexPath.row==2) {
                UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"Street 2" withFont:@"SourceSansPro-Light" withSize:14.0];
                [_cell.contentView addSubview:_lbl];
                
                _street2TF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
                [_street2TF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :YES]];
                [_cell.contentView addSubview:_street2TF];
            }
           else if (indexPath.row==3) {
               UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"City*" withFont:@"SourceSansPro-Light" withSize:14.0];
               [_cell.contentView addSubview:_lbl];
               
               _cityTF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
               [_cityTF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :YES]];
               [_cell.contentView addSubview:_cityTF];
           }
           else if (indexPath.row==4) {
               UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"State*" withFont:@"SourceSansPro-Light" withSize:14.0];
               [_cell.contentView addSubview:_lbl];
               
               _stateTF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
               [_stateTF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :YES]];
               [_cell.contentView addSubview:_stateTF];
           }
           else if (indexPath.row==5) {
               UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"Zip*" withFont:@"SourceSansPro-Light" withSize:14.0];
               [_cell.contentView addSubview:_lbl];
               
               _zipTF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
               [_zipTF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :YES]];
               [_cell.contentView addSubview:_zipTF];
           }
           else if (indexPath.row==6) {
               UILabel *_lbl=[self createLabelwithRect:CGRectMake(20.0, 0.0, 90.0, 35) withText:@"Promo Code" withFont:@"SourceSansPro-Light" withSize:13.0];
               [_cell.contentView addSubview:_lbl];
               
               _promoCodeTF=[self createTextFieldWithFrame:CGRectMake(90, 5.0, 320.0-105, 30.0) withPlaceHolder:@""];
               [_promoCodeTF setInputAccessoryView:[_customKeyBoard getToolbarWithPrevNextDone:YES :NO]];
               [_cell.contentView addSubview:_promoCodeTF];
           }
        }
        else if (indexPath.section==1){
            _copyrightCheckBox=[UIButton buttonWithType:UIButtonTypeCustom];
            [_copyrightCheckBox setImage:[UIImage imageNamed:@"Check_tick.png"] forState:UIControlStateSelected];
            _copyrightCheckBox.frame=CGRectMake(15.0, 5.0, 35, 40.0);
            [_copyrightCheckBox addTarget:self action:@selector(copyrightCheckMarkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_copyrightCheckBox setImage:[UIImage imageNamed:@"Check_untick.png"] forState:UIControlStateNormal];
            [_cell.contentView addSubview:_copyrightCheckBox];
            
            UILabel *_lbl=[self createLabelwithRect:CGRectMake(90.0, 2.0, 200.0, 40) withText:@"Yes, I own the copyright or am authorized by the owner to use this photo." withFont:@"SourceSansPro-Light" withSize:12.0];
            _lbl.numberOfLines=2;
            [_cell.contentView addSubview:_lbl];
        }
        else if (indexPath.section==2){
            _authorizationCheckBox=[UIButton buttonWithType:UIButtonTypeCustom];
            [_authorizationCheckBox setImage:[UIImage imageNamed:@"Check_tick.png"] forState:UIControlStateSelected];
             [_authorizationCheckBox setImage:[UIImage imageNamed:@"Check_untick.png"] forState:UIControlStateNormal];
            _authorizationCheckBox.frame=CGRectMake(15.0, 5.0, 35, 40.0);
            [_authorizationCheckBox addTarget:self action:@selector(aggremnetCheckMarkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_cell.contentView addSubview:_authorizationCheckBox];
            
            UILabel *_lbl=[self createLabelwithRect:CGRectMake(90.0, 2.0, 200.0, 40) withText:@"Yes, I authorize PhotoMoby to use my image and story for marketing purpose." withFont:@"SourceSansPro-Light" withSize:12.0];
            _lbl.numberOfLines=2;
            [_cell.contentView addSubview:_lbl];
        }
        else {
            /***
             * Order Button
             **/
            UIButton *_payButton=[UIButton buttonWithType:UIButtonTypeCustom];
            _payButton.frame=CGRectMake(75.0, 15.0,170.0, 35.0);
            [_payButton setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:175.0/255.0 blue:240.0/255.0 alpha:1.0]];
            [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _payButton.titleLabel.font=[UIFont fontWithName:@"SourceSansPro-Light" size:20.0];
            [_payButton setTitle:@"PAY" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(payBtn) forControlEvents:UIControlEventTouchUpInside];
            [_cell.contentView addSubview:_payButton];
        }
       
    
    }
    return _cell;
}
-(UILabel *)createLabelwithRect:(CGRect)frame withText:(NSString *)text withFont:(NSString *)font withSize:(float)size{
    UILabel *_lbl=[[UILabel alloc]initWithFrame:frame];
    _lbl.textColor=[UIColor colorWithRed:81.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:1.0];
    _lbl.font=[UIFont fontWithName:font size:size];
    _lbl.text=text;
    return _lbl;
    
}
-(UITextField *)createTextFieldWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolderString{
    UITextField *_textField=[[UITextField alloc]initWithFrame:frame];
    _textField.backgroundColor=[UIColor colorWithRed:81.0/255.0 green:172.0/255.0 blue:207.0/255.0 alpha:0.3];
    _textField.font=[UIFont fontWithName:@"SourceSansPro-Regular" size:17.0];
    _textField.textColor=[UIColor blackColor];
    _textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _textField.placeholder=placeHolderString;
    _textField.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField.delegate=self;
    _textField.returnKeyType=UIReturnKeyDone;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _textField.leftView = paddingView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    return _textField;
}
#pragma mark ----------------------***--------------------
#pragma mark Button Actions
//Billing CheckBox
-(void)billingCheckBoxBtnAction:(UIButton *)sender{
    if (sender.selected) {
        sender.selected=NO;
        _isBillingAddress=NO;
    }
    else{
        sender.selected=YES;
        _isBillingAddress=YES;
    }
 
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
}
//CopyRight CheckBox
-(void)copyrightCheckMarkBtnAction:(UIButton *)sender{
    if(sender.selected)
        sender.selected=NO;
    else
        sender.selected=YES;
}
//Aggrement CheckBox
-(void)aggremnetCheckMarkBtnAction:(UIButton *)sender{
    if(sender.selected)
        sender.selected=NO;
    else
        sender.selected=YES;
}
//BAck Button
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----------------------***--------------------
#pragma mark Custom Keyboard Delegate
-(void)previousClicked:(NSUInteger)selectedId{
   if([_promoCodeTF isFirstResponder])
       [_zipTF becomeFirstResponder];
    else if ([_zipTF isFirstResponder])
        [_stateTF becomeFirstResponder];
    else if ([_stateTF isFirstResponder])
        [_cityTF becomeFirstResponder];
    else if ([_cityTF isFirstResponder])
        [_street2TF becomeFirstResponder];
    else if ([_street2TF isFirstResponder])
        [_street1TF becomeFirstResponder];
    else if([_street1TF isFirstResponder])
        [_nameTF becomeFirstResponder];
    }
-(void)nextClicked:(NSUInteger)selectedId{
    if ([_nameTF isFirstResponder])
        [_street1TF becomeFirstResponder];
    else if ([_street1TF isFirstResponder])
        [_street2TF becomeFirstResponder];
    else if ([_street2TF isFirstResponder])
             [_cityTF becomeFirstResponder];
    else if ([_cityTF isFirstResponder])
        [_stateTF becomeFirstResponder];
    else if([_stateTF isFirstResponder])
        [_zipTF becomeFirstResponder];
    else if ([_zipTF isFirstResponder])
        [_promoCodeTF becomeFirstResponder];
}
-(void)doneClicked:(NSUInteger)selectedId{
    [self resignAll];
}
#pragma mark ----------------------***--------------------
#pragma mark TextField Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.view.frame=CGRectMake(0.0, -65.0, 320.0, self.view.frame.size.height);
    UITableViewCell *_cell=(UITableViewCell *)textField.superview.superview.superview;
    if (_cell) {
        NSIndexPath *_indexPath=[_tableView indexPathForCell:_cell];
        [self performSelector:@selector(moveUp:) withObject:_indexPath afterDelay:0.0];

    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignAll];
    return YES;
}

-(void)moveUp:(NSIndexPath *)indexPath{
 [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
-(void)resignAll{
    self.view.frame=CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height);
    if([_nameTF isFirstResponder])[_nameTF resignFirstResponder];
    if([_street1TF isFirstResponder])[_street1TF resignFirstResponder];
    if([_street2TF isFirstResponder])[_street2TF resignFirstResponder];
    if([_cityTF isFirstResponder])[_cityTF resignFirstResponder];
    if([_stateTF isFirstResponder])[_stateTF resignFirstResponder];
    if([_zipTF isFirstResponder])[_zipTF resignFirstResponder];
     if([_promoCodeTF isFirstResponder])[_promoCodeTF resignFirstResponder];
}
#pragma mark-
#pragma mark ------------------ Check Validation ---------------------
-(void)payBtn{
    NSCharacterSet *_whitespace            = [NSCharacterSet whitespaceAndNewlineCharacterSet];
   
    NSString       *_shippingName    = [_nameTF.text stringByTrimmingCharactersInSet:_whitespace];
    NSString       *_shippingStreet1 = [_street1TF.text stringByTrimmingCharactersInSet:_whitespace];
    NSString       *_shippingStreet2 = [_street2TF.text stringByTrimmingCharactersInSet:_whitespace];
    NSString       *_shippingCity    = [_cityTF.text stringByTrimmingCharactersInSet:_whitespace];
    NSString       *_shippingState   = [_stateTF.text stringByTrimmingCharactersInSet:_whitespace];
    NSString       *_shippingZip     = [_zipTF.text stringByTrimmingCharactersInSet:_whitespace];
   NSString       *_promoCode     = [_zipTF.text stringByTrimmingCharactersInSet:_whitespace];
    if (_shippingName.length>0&&_shippingStreet1.length>0&&_shippingCity.length>0&&_shippingState.length>0&&_shippingZip.length>0) {
        if (_copyrightCheckBox.selected==YES) {
          
                
        [self makePayement:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_shippingName,_shippingStreet1,_shippingStreet2,_shippingCity,_shippingState,_shippingZip,_promoCode, nil] forKeys:[NSArray arrayWithObjects:@"shippingName",@"shippingStreet1",@"shippingStreet2",@"shippingCity",@"shippingState",@"shippingZip",@"promoCode", nil]]];
            
        }
        else
            [self showAlertWithMessage:@"Please check the copyright checkbox"];
        
    }
    else{
        [self showAlertWithMessage:@"Please enter the required fields"];
    }
    
    
    
}
-(void)makePayement:(NSDictionary *)dictionary{
    self.completedPayment = nil;
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
   // NSArray *items = @[item1, item2, item3];
      NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Favr";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
-(void)showAlertWithMessage:(NSString *)message{
    UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [_alertView show];
}
#pragma mark ----------------------***--------------------
#pragma mark Pay Pal delegate Methods
//- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
//    
//    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
//    if (_orderID) {
//    //    [_orderID release];
//        _orderID=nil;
//    }
//    _orderID=[[[completedPayment.confirmation objectForKey:@"proof_of_payment"]objectForKey:@"adaptive_payment"]objectForKey:@"pay_key"];
//   // [_orderID retain];
//    
//    [self uploadToFTP];
//}
- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    self.completedPayment = completedPayment;
   // [self sendCompletedPaymentToServer:completedPayment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
   
    self.completedPayment = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
  //  self.resultText = [completedPayment description];
  //  [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
   // self.resultText = nil;
   // self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}





-(void)createHUD{
    if(_progressHud)return;
    
    _progressHud        =  [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode   =  MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"Please Wait....";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    
}
#pragma mark ------------------------***---------------------
#pragma mark FTP Uploading Methods
-(void)uploadToFTP{
    if (_progressHud) {
        [_progressHud show:YES];
        [_progressHud hide:NO];
    }
    else
        [self createHUD];
  
    
    NSString *_fileName=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (_orderType==MagazineCoverOrder) {
        if (_image1Name) {
           // [_image1Name release];
            _image1Name=nil;
        }
        _image1Name=[NSString stringWithFormat:@"%@_%@",_orderID,[self genRandStringLength:3]];
     //   [_image1Name retain];
        
        _fileName=[_fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_image1Name]];
        [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Cover.png"]] toURL:[NSURL fileURLWithPath:_fileName] error:nil];
    }
    else  if (_orderType==TeamPotraitOrder) {
        if (_image1Name) {
        //    [_image1Name release];
            _image1Name=nil;
        }
        _image1Name=[NSString stringWithFormat:@"%@_%@",_orderID,[self genRandStringLength:3]];
      //  [_image1Name retain];
        
        _fileName=[_fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_image1Name]];
        [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Team.png"]] toURL:[NSURL fileURLWithPath:_fileName] error:nil];
    }
    else  if (_orderType==MemoryMateOrder) {
        if (_image1Name) {
        //    [_image1Name release];
            _image1Name=nil;
        }
        _image1Name=[NSString stringWithFormat:@"%@_%@",_orderID,[self genRandStringLength:3]];
      //  [_image1Name retain];
        
        _fileName=[_fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_image1Name]];
        [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Team.png"]] toURL:[NSURL fileURLWithPath:_fileName] error:nil];
    }
    else{
        if (_image1Name) {
       //     [_image1Name release];
            _image1Name=nil;
        }
        _image1Name=[NSString stringWithFormat:@"%@_%@",_orderID,[self genRandStringLength:3]];
     //   [_image1Name retain];
 
        NSString *_frontImage=[_fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_image1Name]];
        [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Card.png"]] toURL:[NSURL fileURLWithPath:_frontImage] error:nil];

    }
   
//    FTPHelper *_ftpHelper=[FTPHelper sharedInstance];
//    _ftpHelper.urlString=@"ftp://03703f8.netsolhost.com/htdocs/Photomoby/printerfiles";
//    _ftpHelper.uname=@"ftp1939157";
//    _ftpHelper.pword=@"Cardboard1162";
//    _ftpHelper.delegate = self;
//    
//    NSString *_str=[NSString stringWithFormat:@"%@.png",_image1Name];
//    [FTPHelper upload:_str];
}
- (void)dataUploadFinished: (NSNumber *) bytes{
    [self sendEmailId];
}
- (void)dataUploadFailed: (NSString *) reason{
    [_progressHud show:NO];
    [_progressHud hide:YES];
    [self saveOrderHistory:NO];
  
    NSString *_messageString=[NSString stringWithFormat:@"Order Placed successfully.You order Id is %@.",_orderID];
    UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@"" message:_messageString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [_alertView show];
 //   [_alertView release];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (_ovCallFrom==OVFromOther) {
//        NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//        if (viewsArray.count>0) {
//       //     LandscapeCameraView *team=(LandscapeCameraView*)[viewsArray objectAtIndex:0];
//            NSArray *_outerViewController=[((UINavigationController *)[team.navigationController presentingViewController]) viewControllers];
//            if (_outerViewController.count>0) {
//                TeamStylePicker *_optionView=[_outerViewController lastObject];
//                [_optionView.navigationController popToRootViewControllerAnimated:NO];
//                [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//            }
//        }
//        else
//         //   [self.navigationController popToRootViewControllerRetro];
//    }
//    else{
//        NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//        if (viewsArray.count>0) {
//            AddTeamVC *team=(AddTeamVC*)[viewsArray objectAtIndex:0];
//            [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//        }
//        else{
//            NSArray *_viewsArray=self.navigationController.viewControllers;
//            [self.navigationController popViewControllerRetro:[_viewsArray objectAtIndex:_viewsArray.count-4]];
//        }
//    }

}
NSString *Characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
-(NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [Characters characterAtIndex: arc4random() % [Characters length]]];
    }
    
    return randomString;
}
-(void)sendEmailId{
    NSString *_orderTypeStr=@"";
    if (_orderType==TradingCardOrder) {
        _orderTypeStr=@"Trading Card";
    }
    else if (_orderType==TeamPotraitOrder) {
        _orderTypeStr=@"Team Potrait";
    }
    else if (_orderType==MagazineCoverOrder) {
        _orderTypeStr=@"Magazine Cover";
    }
    else
         _orderTypeStr=@"Memory Mate";
    
    NSString *_dataString = [NSString stringWithFormat:@"order_number=%@&order_type=%@&image_path=%@&name=%@&street1=%@&street2=%@&city=%@&state=%@&zip=%@&promo_code=%@",_orderID,_orderTypeStr,[NSString stringWithFormat:@"%@.png",_image1Name],_nameTF.text,_street1TF.text,_street2TF.text,_cityTF.text,_stateTF.text,_zipTF.text,_promoCodeTF.text];
    NSData *_postData = [_dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *_postDataLength = [NSString stringWithFormat:@"%d",[_postData length]];
    
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] init] ;
    [_request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://03703f8.netsolhost.com/Photomoby/sendemail.php"]]];
    [_request setHTTPMethod:@"POST"];
    [_request setValue:_postDataLength forHTTPHeaderField:@"Content-Length"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [_request setHTTPBody:_postData];
    
  //  [CAURLDownload downloadURL:_request target:self selector:@selector(successToSubmitEmail:) failSelector:@selector(failToSubmitEmail:) userInfo:nil];
}
-(void)successToSubmitEmail:(NSData *)responseData{
    [_progressHud show:NO];
    [_progressHud hide:YES];
    
    NSDictionary *_responseDictionary=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    if ([[_responseDictionary objectForKey:@"success"]integerValue]==1) {
        NSString *_messageString=[NSString stringWithFormat:@"Order Placed successfully.You order Id is %@.",_orderID];
        UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@"" message:_messageString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [_alertView show];
      //  [_alertView release];
        
        [self.navigationController popViewControllerAnimated:YES];
        
//        if (_ovCallFrom==OVFromOther) {
//            NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//            if (viewsArray.count>0) {
//                LandscapeCameraView *team=(LandscapeCameraView*)[viewsArray objectAtIndex:0];
//                NSArray *_outerViewController=[((UINavigationController *)[team.navigationController presentingViewController]) viewControllers];
//                if (_outerViewController.count>0) {
//                    TeamStylePicker *_optionView=[_outerViewController lastObject];
//                    [_optionView.navigationController popToRootViewControllerAnimated:NO];
//                    [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//                }
//            }
//            else
//                [self.navigationController popToRootViewControllerRetro];
//        }
//        else{
//            NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//            if (viewsArray.count>0) {
//                AddTeamVC *team=(AddTeamVC*)[viewsArray objectAtIndex:0];
//                [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//            }
//            else{
//                NSArray *_viewsArray=self.navigationController.viewControllers;
//                [self.navigationController popViewControllerRetro:[_viewsArray objectAtIndex:_viewsArray.count-4]];
//            }
//        }

    }
   
}
-(void)failToSubmitEmail:(NSError *)error{
    
    [self saveOrderHistory:YES];
    [_progressHud show:NO];
    [_progressHud hide:YES];
  
    NSString *_messageString=[NSString stringWithFormat:@"Order Placed successfully.You order Id is %@.",_orderID];
    UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@"" message:_messageString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [_alertView show];
  //  [_alertView release];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (_ovCallFrom==OVFromOther) {
//        NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//        if (viewsArray.count>0) {
//            LandscapeCameraView *team=(LandscapeCameraView*)[viewsArray objectAtIndex:0];
//            NSArray *_outerViewController=[((UINavigationController *)[team.navigationController presentingViewController]) viewControllers];
//            if (_outerViewController.count>0) {
//                TeamStylePicker *_optionView=[_outerViewController lastObject];
//                [_optionView.navigationController popToRootViewControllerAnimated:NO];
//                [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//            }
//        }
//        else
//            [self.navigationController popToRootViewControllerRetro];
//    }
//    else{
//        NSArray *viewsArray=[((UINavigationController *)[[self navigationController] presentingViewController]) viewControllers];
//      
//        if (viewsArray.count>0) {
//            AddTeamVC *team=(AddTeamVC*)[viewsArray objectAtIndex:0];
//            [[team.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
//        }
//        else{
//            NSArray *_viewsArray=self.navigationController.viewControllers;
//            [self.navigationController popViewControllerRetro:[_viewsArray objectAtIndex:_viewsArray.count-4]];
//        }
//    }

}

-(void)saveOrderHistory:(BOOL)uploaded{
    NSString *_orderTypeStr=@"";
    if (_orderType==TeamPotraitOrder) {
        _orderTypeStr=@"Team Potrait";
    }
    else if (_orderType==MemoryMateOrder){
        _orderTypeStr=@"Memory Mate";
    }
    else if (_orderType==MagazineCoverOrder){
        _orderTypeStr=@"Magazine Cover";
    }
    else
        _orderTypeStr=@"Trading Card";
    
    NSString *_uploadedStatus=@"";
    if(uploaded)
        _uploadedStatus=@"YES";
    else
        _uploadedStatus=@"NO";
    
    if (uploaded==NO) {
        
        NSString *_fileName=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _fileName=[_fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_image1Name]];
        [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:_fileName] toURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:[NSString stringWithFormat:@"OF/%@.png",_image1Name]]] error:nil];

    }
    
    NSMutableDictionary *_dictionary=[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_orderID,_orderTypeStr,_uploadedStatus,@"Fail",_nameTF.text,_street1TF.text,_street2TF.text,_cityTF.text,_stateTF.text,_zipTF.text,_image1Name,@"", nil] forKeys:[NSArray arrayWithObjects:@"OrderId",@"OrderType",@"Uploaded",@"Status",@"Name",@"Street1",@"Street2",@"City",@"State",@"Zip",@"OrderImage1",@"OrderImage2", nil]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Fail" object:Nil userInfo:_dictionary];

}
#pragma mark-
#pragma mark ------------------ Handle Rotation ---------------------
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark-
#pragma mark ------------------ Hide StatusBar ---------------------
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
