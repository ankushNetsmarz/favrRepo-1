//
//  OrderViewController.h
//  photomoby
//
//  Created by Signity Solutions on 26/11/13.
//  Copyright (c) 2013 Signity Solutions. All rights reserved.
//
typedef enum {
    MagazineCoverOrder,
    MemoryMateOrder,
    TeamPotraitOrder,
    TradingCardOrder
}OrderType;

typedef enum {
    OVFromGallery,
    OVFromOther
}OVCallFrom;

#import <UIKit/UIKit.h>
#import "CustomKeyboard.h"
#import "PayPalMobile.h"
//#import "FTPHelper.h"
#import "MBProgressHUD.h"

@interface OrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomKeyboardDelegate,PayPalPaymentDelegate>
{
    UITableView *_tableView;
    BOOL         _isBillingAddress;
    CustomKeyboard *_customKeyBoard;
   
    UITextField   *_nameTF,
                  *_street1TF,
                  *_street2TF,
                  *_cityTF,
                  *_stateTF,
                  *_zipTF,
                  *_promoCodeTF;
    
    UIButton      *_billingCheckBox;
    UIButton      *_copyrightCheckBox;
    UIButton      *_authorizationCheckBox;
    MBProgressHUD *_progressHud;
    NSString      *_orderID;
    
    NSString      *_image1Name;
    NSString      *_image2Name;
    
}
@property(readwrite)OVCallFrom ovCallFrom;
@property(nonatomic,readwrite)OrderType orderType;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL  acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end
