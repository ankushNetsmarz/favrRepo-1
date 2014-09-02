//
//  FavrInfoVC.m
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "FavrInfoVC.h"
#import "MyChattingVC.h"
#import "ChatSharedManager.h"

@interface FavrInfoVC ()<QBActionStatusDelegate>
@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) NSString *opponetChatUserId;
@end

@implementation FavrInfoVC
@synthesize favrId;
@synthesize navigationTitle;
@synthesize incoming_outgoingString;
@synthesize strGetTabText;

static NSString const *kMsgIncomming = @"INCOMMING";
static NSString const *kMsgOutgoing = @"OUTGOING";

#pragma mark - ViewLifeCycle

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
    NSLog(@"favrID %@", favrId);
    
    self.users = [[ChatSharedManager sharedManager] chatUsers];
    
    self.navigationBar.topItem.title = navigationTitle;
    
    if ([strGetTabText isEqualToString:@"pending"]) {
        _barBtnCompleted.image = nil;
    }
    else if ([strGetTabText isEqualToString:@"favr"]){
    
    
    }
    
    
    
    
    if ([incoming_outgoingString isEqualToString:(NSString *) kMsgIncomming])
    {
         _barBtnCompleted.image = nil;
    }
    else if ([incoming_outgoingString isEqualToString:(NSString *) kMsgOutgoing])
    {
    }
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    
    [appDelegate() showMBHUD:@"Please Wait..."];
    
    [PFCloud callFunctionInBackground:@"getFavrDetail"
                       withParameters:@{@"favrId": favrId}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        NSLog(@"favr Details %@", [results objectAtIndex:0]);
                                        favrInfoArray = [[NSArray alloc] initWithArray:results];
                                        [appDelegate() dismissMBHUD];
                                        self.favrTitleLbl.text = [[results objectAtIndex:0] objectForKey:@"favrTitle"];
                                        self.favrDescLabel.text = [[results objectAtIndex:0] objectForKey:@"favrDescription"];
                                        self.whenLabel.text = [[results objectAtIndex:0] valueForKey:@"When"];
                                        self.quidProLabel.text = [[results objectAtIndex:0] valueForKey:@"quidPro"];
                                        
                                        if ([[[favrInfoArray objectAtIndex:0] valueForKey:@"isActive"] integerValue]==0) {
                                           _barBtnCompleted.image = nil;
                                            
                                        }
                                        
                                        
                                    }
                                }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSString *_chatUserName= [[NSUserDefaults standardUserDefaults]objectForKey:@"chatUserName"];
    NSString *_password=  [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [[ChatSharedManager sharedManager] setTxtUserName:_chatUserName];
    [[ChatSharedManager sharedManager] setTxtUserPassword:_password];
    [[ChatSharedManager sharedManager] loginChatFunction:@"LOGIN"];
    
    
    [super viewWillDisappear:YES];
    if (self.pendingFavrStatus == 1)
    {
        if ([incoming_outgoingString isEqualToString:(NSString *) kMsgIncomming])
        {
            self.favrAcceptBtnObj.hidden = NO;
            self.favrRejectButtonObj.hidden = NO;
        }
        else if ([incoming_outgoingString isEqualToString:(NSString *) kMsgOutgoing])
        {
            self.favrAcceptBtnObj.hidden = YES;
            self.favrRejectButtonObj.hidden = YES;
        }
    }
    
    else if (self.pendingFavrStatus == 2)
    {
        if ([incoming_outgoingString isEqualToString:(NSString *) kMsgIncomming])
        {
            self.favrAcceptBtnObj.hidden = YES;
            self.favrRejectButtonObj.hidden = YES;
        }
        else if ([incoming_outgoingString isEqualToString:(NSString *) kMsgOutgoing])
        {
            self.favrAcceptBtnObj.hidden = YES;
            self.favrRejectButtonObj.hidden = YES;
        }
    }
    
     [appDelegate().chatRoom leaveRoom];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    if (alertView.tag==222) {
        
        if (buttonIndex==0) {
            
            NSLog(@"No");
            
        }
        else{
            NSLog(@"Yes");
            
            [appDelegate() showMBHUD:@"Please Wait..."];
            
            [PFCloud callFunctionInBackground:@"isFavrCompleted"
                               withParameters:@{
                                                @"favrId": favrId,
                                                @"helperId":[[favrInfoArray objectAtIndex:0] objectForKey:@"helperId"],
                                                @"quidPro":[[favrInfoArray objectAtIndex:0] objectForKey:@"quidPro"]
                                                
                                                }
                                        block:^(NSArray *results, NSError *error)
             
             {
                 
               
                 
                 if (!error)
                 {
                     [appDelegate() dismissMBHUD];
                    _barBtnCompleted.image = nil;
                     
                 }
                 else
                 {
                     [appDelegate() dismissMBHUD];
                     NSLog(@"Error Occured");
                 }
             }
             ];
        
        }
        
    }


}

#pragma mark - OtherMethod
// navigates to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)isFavrCompleted:(id)sender {
    
    if (_barBtnCompleted.image == nil) {
        return;
    }
    
    
    
    
    UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Is Favr completed ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    _alertView.tag = 222;
    [_alertView show];
    
}

//Favr Rejection method is called when we tap on cross button in bottom right of screen
- (IBAction)FavrRejectedBtnAct:(UIButton *)sender {
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    
    [PFCloud callFunctionInBackground:@"rejectFavr"
                       withParameters:@{@"favrId": favrId,
                                        @"helperId":[[favrInfoArray objectAtIndex:0] objectForKey:@"helperId"],
                                        @"helpeeid":[[favrInfoArray objectAtIndex:0] objectForKey:@"helpeeId"],
                                        @"isGrpFavr":[[favrInfoArray objectAtIndex:0] objectForKey:@"isGrpFavr"]
                                        }
                                block:^(NSString *results, NSError *error) {
                                    if ([results intValue])
                                    {
                                        appDelegate().updatePendingOutGoing = updateYes;
                                        [self.navigationController popViewControllerAnimated:YES];
                                        //                                        NSLog(@"favr Details %@", [results objectAtIndex:0]);
                                        //                                        favrInfoArray = [[NSArray alloc] initWithArray:results];
                                        //                                        [hud hide:YES];
                                        //                                        self.favrTitleLbl.text = [[results objectAtIndex:0] objectForKey:@"favrTitle"];
                                        //                                        self.favrDescLabel.text = [[results objectAtIndex:0] objectForKey:@"favrDescription"];
                                    }
                                }];
}

// Favr Accepted method is called when we tap on check button in bottom left of screen
- (IBAction)favrAcceptedBtnAct:(UIButton *)sender {
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    [PFCloud callFunctionInBackground:@"acceptFavr"
                       withParameters:@{@"favrId": favrId,
                                        @"helperId":[[favrInfoArray objectAtIndex:0] objectForKey:@"helperId"],
                                        @"helpeeid":[[favrInfoArray objectAtIndex:0] objectForKey:@"helpeeId"],
                                        @"isGrpFavr":[[favrInfoArray objectAtIndex:0] objectForKey:@"isGrpFavr"]
                                        
                                        }
                                block:^(NSString *results, NSError *error) {
                                    if ([results intValue])
                                    {
                                        appDelegate().updatePendingOutGoing = updateYes;
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
    
}

// Favr chat method is called when we tap on bottom center button of screen
- (IBAction)favrChatBtnAct:(UIButton *)sender {
//    MyChattingVC *chattingVC = (MyChattingVC*)[mainStoryboard
//                                               instantiateViewControllerWithIdentifier: @"MyChattingVC"];
//    
//    QBUUser *user = (QBUUser *)self.users;
//    
//    MyChattingVC *chattingVC = [[MyChattingVC alloc] init];
//    chattingVC.opponent = user;
//    //    [[SlideNavigationController sharedInstance] pushViewController:chattingVC animated:YES];z
//    [self.navigationController pushViewController:chattingVC animated:YES];
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    
    
    if ([[[favrInfoArray objectAtIndex:0]valueForKey:@"isGrpFavr"] integerValue]==1) {
        [self chatScreen];
        return;
    }
    
    
    if (appDelegate().chatType==helpee) {
        if ([incoming_outgoingString isEqualToString:(NSString *)kMsgIncomming])
        {
            
            [appDelegate() showMBHUD:@"Please Wait..."];
            
            [PFCloud callFunctionInBackground:@"getDetailUser"
                               withParameters:@{
                                                @"userId": [[favrInfoArray objectAtIndex:0] valueForKey:@"helpeeId"]
                                                }
                                        block:^(NSArray *results, NSError *error)
             {
                 
                 if (!error)
                 {
                     [appDelegate() dismissMBHUD];
                     NSLog(@"result array %@", results);
                     NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
                     NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
                     
                     NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
                     NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                     NSLog (@"Result: %@", resultString);
                     
                     self.opponetChatUserId = resultString;
                     NSLog(@"email Id %@", self.opponetChatUserId);
                     
                     [self chatScreen];
                     
                 }
                 else
                 {
                     NSLog(@"Error Occured");
                 }
             }
             ];
        }
        else if ([incoming_outgoingString isEqualToString:(NSString *)kMsgOutgoing])
        {
            
            [appDelegate() showMBHUD:@"Please Wait..."];
            [PFCloud callFunctionInBackground:@"getDetailUser"
                               withParameters:@{
                                                @"userId": [[favrInfoArray objectAtIndex:0] valueForKey:@"helpeeId"]
                                                }
                                        block:^(NSArray *results, NSError *error)
             {
                 
                 if (!error)
                 {
                     [appDelegate() dismissMBHUD];
                     NSLog(@"result array %@", results);
                     NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
                     NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
                     
                     NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
                     NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                     NSLog (@"Result: %@", resultString);
                     
                     self.opponetChatUserId = resultString;
                     NSLog(@"email Id %@", self.opponetChatUserId);
                     
                     [self chatScreen];
                     
                 }
                 else
                 {
                     NSLog(@"Error Occured");
                 }
             }
             ];
        }

        
    }
    else{
    
        if ([incoming_outgoingString isEqualToString:(NSString *)kMsgIncomming])
        {
            
            [appDelegate() showMBHUD:@"Please Wait..."];
            
            [PFCloud callFunctionInBackground:@"getDetailUser"
                               withParameters:@{
                                                @"userId": [[favrInfoArray objectAtIndex:0] valueForKey:@"helperId"]
                                                }
                                        block:^(NSArray *results, NSError *error)
             {
                 
                 if (!error)
                 {
                     [appDelegate() dismissMBHUD];
                     NSLog(@"result array %@", results);
                     NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
                     NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
                     
                     NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
                     NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                     NSLog (@"Result: %@", resultString);
                     
                     self.opponetChatUserId = resultString;
                     NSLog(@"email Id %@", self.opponetChatUserId);
                     
                     [self chatScreen];
                     
                 }
                 else
                 {
                     NSLog(@"Error Occured");
                 }
             }
             ];
        }
        else if ([incoming_outgoingString isEqualToString:(NSString *)kMsgOutgoing])
        {
            
            [appDelegate() showMBHUD:@"Please Wait..."];
            [PFCloud callFunctionInBackground:@"getDetailUser"
                               withParameters:@{
                                                @"userId": [[favrInfoArray objectAtIndex:0] valueForKey:@"helperId"]
                                                }
                                        block:^(NSArray *results, NSError *error)
             {
                 
                 if (!error)
                 {
                     [appDelegate() dismissMBHUD];
                     NSLog(@"result array %@", results);
                     NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
                     NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
                     
                     NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
                     NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                     NSLog (@"Result: %@", resultString);
                     
                     self.opponetChatUserId = resultString;
                     NSLog(@"email Id %@", self.opponetChatUserId);
                     
                     [self chatScreen];
                     
                 }
                 else
                 {
                     NSLog(@"Error Occured");
                 }
             }
             ];
        }

    
    }
    
    
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Loading";
//    [PFCloud callFunctionInBackground:@"getDetailUser"
//                       withParameters:@{
//                                        @"userId": [[favrInfoArray objectAtIndex:0] valueForKey:@"helperId"]
//                                        }
//                        block:^(NSArray *results, NSError *error)
//                        {
//                            
//                            if (!error)
//                            {
//                                [hud hide:YES];
//                                NSLog(@"result array %@", results);
//                                NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
//                                NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
//                                
//                                NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
//                                NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
//                                NSLog (@"Result: %@", resultString);
//                                
//                                self.opponetChatUserId = resultString;
//                                NSLog(@"email Id %@", self.opponetChatUserId);
//                                
//                                [self chatScreen];
//                                
//                            }
//                            else
//                            {
//                                NSLog(@"Error Occured");
//                            }
//                        }
//     ];
    
}

// navigate from favrinfo to chatscreen


-(void)fn_getGroupUserDetail{
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
        
        [appDelegate() showMBHUD:@"Please Wait..."];
        [PFCloud callFunctionInBackground:@"getDetailUser"
                           withParameters:@{
                                            @"userId": [userIdArray objectAtIndex:userIdCount]
                                            }
                                    block:^(NSArray *results, NSError *error)
         {
             
             if (!error)
             {
                 [appDelegate() dismissMBHUD];
                 NSLog(@"result array %@", results);
                 NSLog(@"[results objectAtIndex:0] %@", [results objectAtIndex:0]);
                 NSLog(@"[[results objectAtIndex:0] valueForKey:email] %@", [[results objectAtIndex:0] valueForKey:@"emailAddr"]);
                 
                 NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
                 NSString *resultString = [[[[results objectAtIndex:0] valueForKey:@"emailAddr"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                 NSLog (@"Result: %@", resultString);
                 NSLog(@"email Id %@", resultString);
                 
                 [userGroupIdArray addObject:resultString];
                 
                 if (userIdCount == userIdArray.count-1) {
                     ////// code to chat view controller

                     NSLog(@"User Detail Array_________________%@",userGroupIdArray);
                     
                     for (NSString *strUser in userGroupIdArray) {
                         
                         for (int i = 0; i < self.users.count; i++)
                         {
                             NSLog(@"self.user.count %@", [self.users objectAtIndex:i]);
                             if ([[[self.users objectAtIndex:i] valueForKey:@"login"] isEqualToString:strUser])
                             {
                                 QBUUser *user = (QBUUser *)[self.users objectAtIndex:i];
                                 
                                 [userSelectedArray addObject:user];
                                 break;
                             }
                         }
                         
                     }
                     
                     NSLog(@"userSelectedArray Detail Array_________________%@",userSelectedArray);
                     
                     for (int i=0; i<appDelegate().getDialogs.count; i++) {
                         NSLog(@"____________________%@",[[appDelegate().getDialogs objectAtIndex:i]valueForKey:@"type"]);
                         if ([[[appDelegate().getDialogs objectAtIndex:i]valueForKey:@"type"]integerValue ]==2) {
                             
                             NSMutableArray *userIDSArray =(NSMutableArray*)[[appDelegate().getDialogs objectAtIndex:i]valueForKey:@"occupantIDs"];
                             
                             NSLog(@"____________________%@",userIDSArray);
                             
                             
                             getselectedUsersIDs = [NSMutableArray array];
                             for(QBUUser *user in userSelectedArray){
                                 [getselectedUsersIDs addObject:@(user.ID)];
                             }
                             
                             NSLog(@"____________________%@",getselectedUsersIDs);
                             
                             k=0;
                             if (userIDSArray.count==getselectedUsersIDs.count) {
                                 
                                 for (int i=0; i<getselectedUsersIDs.count; i++) {
                                     
                                     
                                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %d", [[getselectedUsersIDs objectAtIndex:i] integerValue]];
                                     NSArray *newArray = [userIDSArray filteredArrayUsingPredicate:predicate];
                                     NSLog(@"%d", [newArray count]);
                                     
                                     if ([newArray count]>0) {
                                         k++;
                                     }
                                     
                                 }
                                 
                                 if (getselectedUsersIDs.count ==k) {
                                     
                                     QBChatDialog *getdialog = [appDelegate().getDialogs objectAtIndex:i];
                                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard"
                                                                                              bundle: nil];
                                     
                                     [appDelegate() dismissMBHUD];
                                     MyChattingVC *chattingVC = (MyChattingVC*)[mainStoryboard
                                                                                instantiateViewControllerWithIdentifier: @"MyChattingVC"];
                                     
                                     chattingVC.dialog = getdialog;
                                     [self.navigationController pushViewController:chattingVC animated:YES];
                                     
                                     return ;
                                 }
                                 
                            }
                             
                         }
                         
                         
                     }
                     
                     if (k==0) {
                         isCreateGroup = YES;
                     }
                     else{
                         isCreateGroup = NO;
                     }
                     
                     
                     if (isCreateGroup==NO) {
                         
                     }
                     else{
                         [self fn_createDialog];
                     }

                     
                    
                 }
                 else{
                     userIdCount++;
                     [self fn_getGroupUserDetail];
                 
                 }
                 
                 
                 
             }
             else
             {
                  [appDelegate() dismissMBHUD];
                 NSLog(@"Error Occured");
             }
         }
         ];
    



}
-(void)fn_createDialog{

    
    QBChatDialog *chatDialog = [QBChatDialog new];
    
    NSMutableArray *selectedUsersIDs = [NSMutableArray array];
    NSMutableArray *selectedUsersNames = [NSMutableArray array];
    for(QBUUser *user in userSelectedArray){
        [selectedUsersIDs addObject:@(user.ID)];
        [selectedUsersNames addObject:user.login == nil ? user.email : user.login];
    }
    chatDialog.occupantIDs = selectedUsersIDs;
    
    if(userSelectedArray.count == 1){
        chatDialog.type = QBChatDialogTypePrivate;
    }else{
        chatDialog.name = [selectedUsersNames componentsJoinedByString:@","];
        chatDialog.type = QBChatDialogTypeGroup;
    }
    
    [QBChat createDialog:chatDialog delegate:self];

}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    if (result.success && [result isKindOfClass:[QBChatDialogResult class]]) {
        // dialog created
        
        [appDelegate() dismissMBHUD];
        
        QBChatDialogResult *dialogRes = (QBChatDialogResult *)result;
        
     //   DialogsViewController *dialogsViewController = self.navigationController.viewControllers[0];
     //   dialogsViewController.createdDialog = dialogRes.dialog;
        
        if(dialogRes.dialog.type == QBChatDialogTypePrivate){

        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard"
                                                                 bundle: nil];
        MyChattingVC *chattingVC = (MyChattingVC*)[mainStoryboard
                                                   instantiateViewControllerWithIdentifier: @"MyChattingVC"];
        for (int i = 0; i < self.users.count; i++)
        {
            NSLog(@"self.user.count %@", [self.users objectAtIndex:i]);
            if ([[[self.users objectAtIndex:i] valueForKey:@"login"] isEqualToString:self.opponetChatUserId])
            {
                QBUUser *user = (QBUUser *)[self.users objectAtIndex:i];
                chattingVC.opponent = user;
                chattingVC.dialog = dialogRes.dialog;
                [self.navigationController pushViewController:chattingVC animated:YES];
                break;
            }
        }
        
        }
        else{
        
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard"
                                                                     bundle: nil];
            MyChattingVC *chattingVC = (MyChattingVC*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"MyChattingVC"];
            chattingVC.dialog = dialogRes.dialog;
            [self.navigationController pushViewController:chattingVC animated:YES];

        
        }
        
        
    }else{
        
        [appDelegate() dismissMBHUD];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:[[result errors] componentsJoinedByString:@","]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}


-(void) chatScreen
{
    
    
    if ([[[favrInfoArray objectAtIndex:0]valueForKey:@"isGrpFavr"] integerValue]==1) {
       [appDelegate() showMBHUD:@"Please Wait..."];
          NSLog(@"self.user %@", self.users);
        NSLog(@"__________________________________%@",self.opponetChatUserId);
        userIdArray = [[NSMutableArray alloc]init];
        userGroupIdArray = [[NSMutableArray alloc]init];
        userSelectedArray = [[NSMutableArray alloc]init];
        userIdCount = 0;
       NSMutableArray *objectIdArray = [[NSMutableArray alloc]init];
        
        
        [PFCloud callFunctionInBackground:@"getGroupDetail2"
                           withParameters:@{
                                            @"grpId": [[favrInfoArray objectAtIndex:0]valueForKey:@"helperId"]
                                            }
                                    block:^(NSArray *results, NSError *error)
         {
             if (!error)
             {
                 
                 NSArray *groupDetails = [[NSArray alloc] initWithArray:results];
                 NSLog(@"groupDetails %@", groupDetails);
                 
                 
                 
                 for (int i = 0; i < [[results objectAtIndex:0] count]; i++)
                 {
                     [userIdArray addObject:[[[results objectAtIndex:0] objectAtIndex:i] valueForKey:@"userId"]];
                     [objectIdArray addObject:[[[results objectAtIndex:0] objectAtIndex:i] valueForKey:@"objectId"]];
                 }
                 
                 [appDelegate() dismissMBHUD];
                 [self fn_getGroupUserDetail];
                 
             }
             else
             {
                 [appDelegate() dismissMBHUD];
                 NSLog(@"Error Occured");
             }
         }
         ];
        
                    
            
       
        
        
        
    }
    else{
        [appDelegate() showMBHUD:@"Please Wait..."];

        QBChatDialog *chatDialog = [QBChatDialog new];
        
        NSMutableArray *selectedUsersIDs = [NSMutableArray array];
        NSMutableArray *selectedUsersNames = [NSMutableArray array];
        NSMutableArray *selectedSingleUsersNames = [NSMutableArray array];
        
        for (int i = 0; i < self.users.count; i++)
        {
            NSLog(@"self.user.count %@", [self.users objectAtIndex:i]);
            if ([[[self.users objectAtIndex:i] valueForKey:@"login"] isEqualToString:self.opponetChatUserId])
            {
                QBUUser *user = (QBUUser *)[self.users objectAtIndex:i];
                
                [selectedSingleUsersNames addObject:user];
            }
        }
        
        for(QBUUser *user in selectedSingleUsersNames){
            [selectedUsersIDs addObject:@(user.ID)];
            [selectedUsersNames addObject:user.login == nil ? user.email : user.login];
        }
        chatDialog.occupantIDs = selectedUsersIDs;
        chatDialog.type = QBChatDialogTypePrivate;
       
        
        [QBChat createDialog:chatDialog delegate:self];
        
        
        
//        NSString *message1 = @"Hello man!";
//        NSMutableDictionary *payload = [NSMutableDictionary dictionary];
//        NSMutableDictionary *aps = [NSMutableDictionary dictionary];
//        [aps setObject:@"default" forKey:QBMPushMessageSoundKey];
//        [aps setObject:message1 forKey:QBMPushMessageAlertKey];
//        [payload setObject:aps forKey:QBMPushMessageApsKey];
//        
//        NSString *strUserID =[selectedUsersIDs objectAtIndex:0];
//        
//        QBMPushMessage *message = [[QBMPushMessage alloc] initWithPayload:payload];
//        [QBMessages TRegisterSubscriptionWithDelegate:self];
//        // Send push to users with ids 292,300,1295
//        [QBMessages TSendPush:message toUsers:strUserID delegate:self];
        
        
        
        
        
       
    
    }
    
    
    
   
//    QBUUser *user = (QBUUser *)self.users[selectedIndex];
//    
//    chattingVC.opponent = user;
//    [[SlideNavigationController sharedInstance] pushViewController:chattingVC animated:YES];
}
@end
