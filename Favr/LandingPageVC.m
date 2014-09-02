//
//  LandingPageVC.m
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "LandingPageVC.h"
#import "AccessContactVC.h"
#import "ContactsData.h"
#import "CountryListDataSource.h"
#import <Parse/Parse.h>
#import "AddressBookUI/AddressBookUI.h"
#import "UIImageView+WebCache.h"
#import "ContactUserDetailVC.h"
#import "TSActionSheet.h"
#import "TSPopoverController.h"

@interface LandingPageVC ()
@property(nonatomic,strong)NSArray* arrContacts;
@property(nonatomic,strong)NSMutableDictionary* dictFilteredContacts;
@property(nonatomic,strong)NSArray* arrHeaders;
@property(nonatomic,strong)NSArray* allKeys;
@end

@implementation LandingPageVC


static NSString const *kMsgContact = @"CONTACT";
static NSString const *kMsgGroup = @"GROUP";



#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    groupDetailsArray = [[NSMutableArray alloc] init];
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    
    
    
    self.createAGroupObj.hidden = YES;
    self.tableView.hidden = YES;
    self.segmentControl.hidden = YES;
    self.goObj.hidden = YES;
    self.mobileNumberTxtFld.hidden = YES;
    self.countryCodeObj.hidden = YES;
    self.countryCodePickerView.hidden = YES;
    self.mobileNumberTxtFld.delegate = self;
    self.cancelBtnObj.hidden = YES;
    
    ////************UILable Display when No Favr User*****************
    _lblWhenNoData = [[UILabel alloc]initWithFrame:CGRectMake(0.0,0.0 , self.view.frame.size.width,30.0)];
    _lblWhenNoData.backgroundColor = [UIColor clearColor];
   // _lblWhenNoData.center = self.view.center;
    _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
    _lblWhenNoData.textAlignment = NSTextAlignmentCenter;
    _lblWhenNoData.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_lblWhenNoData];
    _lblWhenNoData.hidden = YES;
    
    [self getAllContacts];

    
    tableRect = self.tableView.frame;
    
    findFriendArray = [[NSMutableArray alloc] init];
    
    contact_group =[NSString stringWithFormat:@"%@",kMsgContact];
    
//    pickerDataArray ;
    
    NSString *fetchedStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"fetchedStatus"];
    if ([fetchedStatus isEqualToString:nil])
    {
        
        UIAlertView *fetchAlert = [[UIAlertView alloc] initWithTitle:@"What is your phone number?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Continue", nil];
        [fetchAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [fetchAlert show];
    }
    else if ([fetchedStatus isEqualToString:@"yes"])
    {
        self.fetchFriendListFirstTimeObj.hidden = YES;
        self.tableView.hidden = NO;
        self.segmentControl.hidden = NO;
        
        findFriendArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"contactDetails"]];
        self.arrContacts = [[AccessContactVC sharedManager] userContacts];
        self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
        
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
        [self.navigationController.navigationBar.topItem setTitleView:titleView];
        self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
        
        for(NSString* str in self.arrHeaders){
            NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
            //   NSLog(@"Pred Str = %@",strPred);
            NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
            NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
            //   NSLog(@"Count  = %d", tempArr.count);
            if(tempArr.count>0)
                [self.dictFilteredContacts setObject:tempArr forKey:str];
        }
        NSLog(@"Dict = %@",self.dictFilteredContacts);
        NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
        
        self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
//    if (appDelegate().isFromSignUpPage==YES) {
//        [findFriendArray removeAllObjects];
//        [groupDetailsArray removeAllObjects];
//        self.fetchFriendListFirstTimeObj.hidden = NO;
//        _lblWhenNoData.hidden = NO;
//        appDelegate().contactStatus = isContactAddedNo;
//    }
    
    
    
//    if (appDelegate.loginSignupFlag == 2)
//    {
               userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
//        [[NSUserDefaults standardUserDefaults] setObject:phoneNumbers forKey:@"mobileNumbers"];
        
        if (phoneNumbers.count==0) {
            
            //phoneNumber = @"0000000000";
           // phoneNumberArr = [NSArray arrayWithObject:phoneNumber];
        }
        else{
        
               [appDelegate() CheckInternetConnection];
               if([appDelegate() internetWorking] ==0){
                   
               }
               else
               {
                   UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                   [_alertView show];
                   return;
               }
            
            
            if (appDelegate().isNumberVerified == NO) {
                
                [findFriendArray removeAllObjects];
                [groupDetailsArray removeAllObjects];
                self.fetchFriendListFirstTimeObj.hidden = NO;
                _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
                _lblWhenNoData.text = @"You have no contact added.";
                _lblWhenNoData.hidden = NO;
                appDelegate().contactStatus = isContactAddedNo;
                
            }else{
            
            
               [appDelegate() showMBHUD:@"Please Wait..."];

               [PFCloud callFunctionInBackground:@"findFriends"
                                  withParameters:@{@"mobileNumbers": phoneNumbers,
                                                   @"userId": userId
                                                   }
                                           block:^(NSArray *results, NSError *error) {
                                               
                                               NSLog(@"_______________________%@",results);
                                               
                                                     [appDelegate() dismissMBHUD];
                                               if (!error) {
                                                   [findFriendArray removeAllObjects];
                                                   
                                                   for (int i = 0; i < results.count; i++)
                                                   {
                                                       tempArray = [[NSMutableArray alloc] init];
                                                       [tempArray addObject:[[results objectAtIndex:i] objectForKey:@"fullName"]];
                                                       [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"userMobileNo"]];
                                                       [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"profilePicPath"]];
                                                       [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                                                       [findFriendArray addObject:tempArray];
                                                   }
                                                   NSLog(@"Find Friend Array %@", findFriendArray);
                                                   
                                                   [[NSUserDefaults standardUserDefaults] setObject:findFriendArray forKey:@"contactDetails"];
                                                   //     NSLog(@"name %@, number %@", [[results objectAtIndex:0] objectForKey:@"fullName"], [[results objectAtIndex:0] valueForKey:@"userMobileNo"]);
                                                   
                                                       self.tableView.hidden = NO;
                                                       self.segmentControl.hidden = NO;
                                                       self.fetchFriendListFirstTimeObj.hidden = YES;
                                                   
                                                       
                                                       [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"fetchedStatus"];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                       
                                                       self.arrContacts = [[AccessContactVC sharedManager] userContacts];
                                                       self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
                                                       
                                                       UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
                                                       [self.navigationController.navigationBar.topItem setTitleView:titleView];
                                                       self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
                                                       
                                                       NSMutableArray *contactListArray = [[NSMutableArray alloc] init];
                                                       for (id obj in findFriendArray)
                                                       {
                                                           [contactListArray addObject:[obj objectAtIndex:0]];
                                                       }
                                                       NSLog(@"contactListArray %@", contactListArray);
                                                       for(NSString* str in self.arrHeaders){
                                                           NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
                                                           NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
                                                           NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
                                                           if(tempArr.count>0)
                                                               [self.dictFilteredContacts setObject:tempArr forKey:str];
                                                       }
                                                       NSLog(@"Dict = %@",self.dictFilteredContacts);
                                                       
                                                       NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
                                                       
                                                       self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                       [self.tableView reloadData];
                                                       if (findFriendArray.count==0) {
                                                           _lblWhenNoData.hidden = NO;
                                                           _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
                                                           _lblWhenNoData.text = @"You have no contact added.";
                                                           self.fetchFriendListFirstTimeObj.hidden = NO;
                                                           appDelegate().contactStatus = isContactAddedNo;
                                                       }else{
                                                           _lblWhenNoData.hidden = YES;
                                                           self.fetchFriendListFirstTimeObj.hidden = YES;
                                                           appDelegate().contactStatus = isContactAddedYes;
                                                       }

                                                   
                                               }else{
                                                   [appDelegate() dismissMBHUD];
                                                   [appDelegate() dismissMBHUD];
                                                   UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   [_alertView show];
                                                   
                                               }
                                               
                                  }];
               
               
            }
        
      
    }
    
    
    [self checkGroupDetail];


}



-(void) get_vrns
{
    
    if ([contact_group isEqualToString:(NSString *)kMsgContact])
    {
        contact_group = [NSString stringWithFormat:@"%@",kMsgContact];
    }
    else if ([contact_group isEqualToString:(NSString *)kMsgGroup])
    {
        
        contact_group = [NSString stringWithFormat:@"%@", kMsgGroup];
    }
    
    pullToRefreshBool = YES;
    [self contactGroupSegmentAct:self.segmentControl];
}



-(void)viewWillAppear:(BOOL)animated
{
    
    NSString *_chatUserName= [[NSUserDefaults standardUserDefaults]objectForKey:@"chatUserName"];
    NSString *_password=  [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [[ChatSharedManager sharedManager] setTxtUserName:_chatUserName];
    [[ChatSharedManager sharedManager] setTxtUserPassword:_password];
    [[ChatSharedManager sharedManager] loginChatFunction:@"LOGIN"];
    
    
    if (appDelegate().updatePendingOutGoing == updateYes) {
        appDelegate().updatePendingOutGoing = updateNo;
        [self get_vrns];
    }
    
    
    [super viewWillAppear:animated];
    popupView.hidden = NO;
    self.mobileNumberTxtFld.text = @"";
}
-(void)viewDidAppear:(BOOL)animated{
    
    

    
    if (findFriendArray.count>0) {
        appDelegate().contactStatus = isContactAddedYes;
    }
    else{
    appDelegate().contactStatus = isContactAddedNo;
    
    }
    
    [appDelegate() dismissMBHUD];
    
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    
    [self performSelector:@selector(get_vrns) withObject:nil afterDelay:0.0];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - UITextfield Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.countryCodePickerView.hidden = YES;
    return YES;
}


#pragma mark ----------------------------------------------------------------
#pragma mark - Fetch Friend list

- (IBAction)fetchFriendListFirstTimeAct:(UIButton *)sender
{
    _lblWhenNoData.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255.0 blue:202.0/255.0 alpha:1];
    self.fetchFriendListFirstTimeObj.hidden = YES;
    self.countryCodeObj.hidden = NO;
    self.mobileNumberTxtFld.hidden = NO;
    self.goObj.hidden = NO;
    self.cancelBtnObj.hidden = NO;
    [self.mobileNumberTxtFld becomeFirstResponder];
    
    //    UIAlertView *fetchAlert = [[UIAlertView alloc] initWithTitle:@"What is your phone number?"
    //                                                         message:nil
    //                                                        delegate:self
    //                                               cancelButtonTitle:@"Cancel"
    //                                               otherButtonTitles:@"Continue", nil];
    //    [fetchAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    //    [fetchAlert show];
}
#pragma mark ----------------------------------------------------------------
#pragma mark - Country Code

- (IBAction)countryCodeAct:(UIButton *)sender {
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    pickerDataArray = [dataSource countries];
    NSLog(@"PickerDataArray %@", pickerDataArray);
    [self.countryCodePickerView reloadAllComponents];
    self.countryCodePickerView.hidden = NO;
    [self.mobileNumberTxtFld resignFirstResponder];
}


#pragma mark ----------------------------------------------------------------
#pragma mark - UIAlertView Delegate


-(void)showAlertWithText:(NSString*)title :(NSString*)message{
    UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [validationAlert show]
    ;
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        NSString *verifyCode = [[alertView textFieldAtIndex:0] text];
        NSLog(@"userId %@, Verify Code %@", userId, verifyCode);
        
        
        [appDelegate() CheckInternetConnection];
        if([appDelegate() internetWorking] ==0){
            
        }
        else
        {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
            return;
        }
        
        
        
        [PFCloud callFunctionInBackground:@"verifyCode"
                           withParameters:@{
                                            @"userId": userId,
                                            @"verifyCode":verifyCode
                                            }
                                    block:^(NSString *results, NSError *error) {
                                        if ([results integerValue] == 0)
                                        {
                                            NSLog(@"result: %li",(long)[results integerValue]);
                                            self.fetchFriendListFirstTimeObj.hidden = NO;
                                            _lblWhenNoData.hidden = NO;
                                            _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
                                            _lblWhenNoData.text = @"You have no contact added.";
                                            
                                            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code didn't match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [_alertView show];
                                            
                                            
//                                            self.tableView.hidden = NO;
//                                            self.segmentControl.hidden = NO;
//                                            self.fetchFriendListFirstTimeObj.hidden = YES;
//                                            
//                                            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"fetchedStatus"];
//                                            [[NSUserDefaults standardUserDefaults] synchronize];
//                                            
//                                            self.arrContacts = [[AccessContactVC sharedManager] userContacts];
//                                            self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
//                                            
//                                            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
//                                            [self.navigationController.navigationBar.topItem setTitleView:titleView];
//                                            self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
//                                            
//                                            for(NSString* str in self.arrHeaders){
//                                                NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
//                                                //   NSLog(@"Pred Str = %@",strPred);
//                                                NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
//                                                NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
//                                                //   NSLog(@"Count  = %d", tempArr.count);
//                                                if(tempArr.count>0)
//                                                    [self.dictFilteredContacts setObject:tempArr forKey:str];
//                                            }
//                                            NSLog(@"Dict = %@",self.dictFilteredContacts);
//                                            NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
//                                            
//                                            self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//                                            [self.tableView reloadData];
                                            
                                           
                                            
                                        }
                                        else
                                        {
//                                            [self showAlertWithText:@"Message" :@"Verification code is not correct"];
                                            
                                            [PFCloud callFunctionInBackground:@"findFriends"
                                                               withParameters:@{@"mobileNumbers": phoneNumbers,
                                                                                @"userId": userId
                                                                                }
                                                                        block:^(NSArray *results, NSError *error) {
                                                                            
                                                                             [findFriendArray removeAllObjects];
                                                                            for (int i = 0; i < results.count; i++)
                                                                            {
                                                                                tempArray = [[NSMutableArray alloc] init];
                                                                                [tempArray addObject:[[results objectAtIndex:i] objectForKey:@"fullName"]];
                                                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"userMobileNo"]];
                                                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"profilePicPath"]];
                                                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                                                                                [findFriendArray addObject:tempArray];
                                                                            }
                                                                            NSLog(@"Find Friend Array %@", findFriendArray);
                                                                            
                                                                            [[NSUserDefaults standardUserDefaults] setObject:findFriendArray forKey:@"contactDetails"];
//                                                                            NSLog(@"name %@, number %@", [[results objectAtIndex:0] objectForKey:@"fullName"], [[results objectAtIndex:0] valueForKey:@"userMobileNo"]);
                                                                            
                                                                            if (!error) {
//                                                                                NSLog(@"result: %i",[results integerValue]);
                                                                                
                                                                                
                                                                                self.tableView.hidden = NO;
                                                                                self.segmentControl.hidden = NO;
                                                                                self.fetchFriendListFirstTimeObj.hidden = YES;
                                                                                _lblWhenNoData.hidden = YES;
                                                                                appDelegate().contactStatus = isContactAddedYes;
                                                                                
                                                                                [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"fetchedStatus"];
                                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                
                                                                                self.arrContacts = [[AccessContactVC sharedManager] userContacts];
                                                                                self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
                                                                                
                                                                                UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
                                                                                [self.navigationController.navigationBar.topItem setTitleView:titleView];
                                                                                self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
                                                                                
                                                                                for(NSString* str in self.arrHeaders){
                                                                                    NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
                                                                                    //   NSLog(@"Pred Str = %@",strPred);
                                                                                    NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
                                                                                    NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
                                                                                    //   NSLog(@"Count  = %d", tempArr.count);
                                                                                    if(tempArr.count>0)
                                                                                        [self.dictFilteredContacts setObject:tempArr forKey:str];
                                                                                }
                                                                                NSLog(@"Dict = %@",self.dictFilteredContacts);
                                                                                
                                                                                NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
                                                                                
                                                                                self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                                                [self.tableView reloadData];
                                                                                
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                        }] ;

                                        }
                                        
                                    }] ;
        
        
        
        
    }
    else if (buttonIndex == 0)
    {
        self.fetchFriendListFirstTimeObj.hidden = NO;
        _lblWhenNoData.hidden = NO;
        _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
        _lblWhenNoData.text = @"You have no contact added.";
    }
}



#pragma mark ----------------------------------------------------------------
#pragma mark - UITableView Delegate/Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return [self.allKeys count];
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.allKeys objectAtIndex:section];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([contact_group isEqualToString:(NSString *)kMsgContact])
    {
        return findFriendArray.count;
    }
    else if ([contact_group isEqualToString:(NSString *)kMsgGroup])
    {
        return groupDetailsArray.count;
    }
    return 0;
//    NSString* currentKey = [self.allKeys objectAtIndex:section];
//    NSArray* tempArr = [self.dictFilteredContacts objectForKey:currentKey];
//    return tempArr.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString* currentKey = [self.allKeys objectAtIndex:indexPath.section];
//    NSArray* tempContactArr = [self.dictFilteredContacts objectForKey:currentKey];
//    
//    NSString* fname =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).firstNames;
//    NSString* lName =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).lastNames;
    
    if ([contact_group isEqualToString:(NSString *)kMsgContact])
    {
        NSString* cellIdent = [NSString stringWithFormat:@"CellIdent"];
        ContactTableCell *cell = (ContactTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdent];
        if (cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ContactTableCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
//        if(!cell){
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
//        }
        cell.textLabel.text = [[findFriendArray objectAtIndex:indexPath.row] objectAtIndex:0];
        
        cell.imageView.layer.cornerRadius = 24.0f;
        cell.imageView.layer.masksToBounds=YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[findFriendArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        
        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
        
        
        
        ////*********Add Divider*********
        UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 59.0f, tableView.frame.size.width, 0.7f)];
        _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
        _imgViewDivider.alpha = 2.0;
        [cell.contentView addSubview:_imgViewDivider];
        return cell;
    }
    else if ([contact_group isEqualToString:(NSString *) kMsgGroup])
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
        GroupTableCell *cell = (GroupTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@"grpName"];
        cell.imageView.layer.cornerRadius = 24.0f;
        cell.imageView.layer.masksToBounds=YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@"grpImage"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
        cell.detailTextLabel.text = [[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@"grpDescription"];
        
        ////*********Add Divider*********
        UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 59.0f, tableView.frame.size.width, 0.7f)];
        _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
        _imgViewDivider.alpha = 2.0;
        [cell.contentView addSubview:_imgViewDivider];
        return cell;
    }
    
    
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50.0f;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0f;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
//    /* Create custom view to display section header... */
//    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 35, 35)];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 25, 25)];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setTextColor:[UIColor whiteColor]];
//    NSString *string =[self.allKeys objectAtIndex:section];
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [circleView addSubview:label];
//    circleView.layer.cornerRadius = 17.0f;
//    circleView.layer.masksToBounds=YES;
//    [view setBackgroundColor:[UIColor clearColor]];
//    [circleView setBackgroundColor: [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0]];
//    [view addSubview:circleView];
//    return view;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([contact_group isEqualToString:(NSString *)kMsgContact])
    {
        ContactUserDetailVC *contactUserDetailVC = [[ContactUserDetailVC alloc] init];
        [self.navigationController pushViewController:contactUserDetailVC animated:YES];
        contactUserDetailVC.userId = [[findFriendArray objectAtIndex:indexPath.row] objectAtIndex:3];
    }
    else if ([contact_group isEqualToString:(NSString *)kMsgGroup])
    {
        GroupUserDetailsVC *groupUserDetailsVC = [[GroupUserDetailsVC alloc] init];
        NSLog(@"[[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@objectId] %@", [[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@"objectId"]);
        groupUserDetailsVC.groupID = [[groupDetailsArray objectAtIndex:indexPath.row] valueForKey:@"objectId"];
        [self.navigationController pushViewController:groupUserDetailsVC animated:YES];
    }

}



#pragma mark - UIPickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSInteger rows;
//    if (0 == component)
//        rows = 10;
//    else if (1 == component)
//        rows = 10;
//    else
//        rows = 15;
    return [pickerDataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //NSString *temp;
    
    
    //temp = [[NSString alloc] initWithString:[self.pocModelData.arrayOfDistricts objectAtIndex:row]];
    if (0 == component)
    {
//        NSLog(@"String returned is %@ for row %d for component %d", [self.pocModelData.arrayOfDistricts objectAtIndex:row], row, component);
        return  [[pickerDataArray objectAtIndex:row] valueForKey:kCountryName];
    }
    else if
        (1 == component){
//            NSLog(@"String returned is %@ for row %d for component %d", [self.pocModelData.arrayOfDistricts objectAtIndex:row], row, component);
//            return [self.pocModelData.arrayOfDistricts objectAtIndex:row];
        }else{
//            NSLog(@"String returned is %@ for row %d for component %d", [self.pocModelData.arrayOfDistricts objectAtIndex:row], row, component);
//            return [self.pocModelData.arrayOfDistricts objectAtIndex:row];
        }
    //return temp;
    //  return [self.pocModelData.arrayOfDistricts objectAtIndex:row];
    return nil;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"row %i", row);
    NSString *item;  // = [[pickerDataArray objectAtIndex:row] valueForKey:kCountryCallingCode];
    if (row == 197)
    {
        item = @"+672";
    }
    else
    {
        item = [[pickerDataArray objectAtIndex:row] valueForKey:kCountryCallingCode];
    }
//    if ([[[pickerDataArray objectAtIndex:row] valueForKey:kCountryCallingCode] isEqualToString:@"<null>"])
//    {
//        item = @"011";
//    }
//    else
//    {
//        item = [[pickerDataArray objectAtIndex:row] valueForKey:kCountryCallingCode];
//    }
    
    
//    NSString *resultString = [[NSString alloc] initWithFormat:
//                              @"%.2f USD = %.2f %@", dollars, result,
//                              [countryNames objectAtIndex:row]];
    [self.countryCodeObj setTitle:item forState:UIControlStateNormal];
}





#pragma mark ------------------------------------------------------------------------

#pragma mark --Method to get All contacts


-(NSArray *)getAllContacts
{
    CFErrorRef *error = nil;
    phoneNumbers = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    if (accessGranted) {
#ifdef DEBUG
        NSLog(@"Fetching contact info ----> ");
#endif
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
        for (int i = 0; i < nPeople; i++)
        {
            ContactsData *contacts = [ContactsData new];
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            //get First Name and Last Name
            @try {
                if(!(ABRecordCopyValue(person, kABPersonFirstNameProperty)== NULL)){
                    NSString* fName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonFirstNameProperty)];
                    contacts.firstNames = fName;
                }
                NSString* lName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonLastNameProperty)];
                contacts.lastNames =  lName;
            }
            @catch (NSException *exception) {
                NSLog(@"error is: %@", exception);
            }
            @finally {
            }
            if (!contacts.firstNames) {
                contacts.firstNames = @"";
            }
            if (!contacts.lastNames) {
                contacts.lastNames = @"";
            }
            // get contacts picture, if pic doesn't exists, show standart one
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
            contacts.image = [UIImage imageWithData:imgData];
            if (!contacts.image) {
                contacts.image = [UIImage imageNamed:@"NOIMG.png"];
            }
            //get Phone Numbers
//            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                NSString *phNo = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *pN = [phNo stringByReplacingOccurrencesOfString:@"-" withString:@""];//
                NSString *getPhoneNumber = [[pN componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                NSString *finalPhoneNumber = [NSString stringWithFormat:@"+%@",getPhoneNumber];

                [phoneNumbers addObject:finalPhoneNumber];
//                [phoneNumbers addObject:phoneNumber];
                //NSLog(@"All numbers %@", phoneNumbers);
            }
            [contacts setNumbers:phoneNumbers];
            //get Contact email
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                [contactEmails addObject:contactEmail];
                // NSLog(@"All emails are:%@", contactEmails);
            }
            [contacts setEmails:contactEmails];
//            NSLog(@"phone Numbers %@", contacts.firstNames);
            [items addObject:contacts];
#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
        }
        NSLog(@"phone contact %@", phoneNumbers);
         [[NSUserDefaults standardUserDefaults] setObject:phoneNumbers forKey:@"mobileNumbers"];
        return items;
    }
    else
    {
#ifdef DEBUG
        NSLog(@"Cannot fetch Contacts :( ");
#endif
        return NO;
    }
}

#pragma mark ------------------------------------------------------------------------

#pragma mark --UIButon Actions

// after entering contact number go button is pressed
- (IBAction)goAct:(UIButton *)sender {
    
    NSLog(@"phone contact%@", [self getAllContacts]);
    
    self.countryCodePickerView.hidden = YES;
    [self.mobileNumberTxtFld resignFirstResponder];
    
    self.countryCodeObj.hidden = YES;
    self.mobileNumberTxtFld.hidden = YES;
    self.goObj.hidden = YES;
    self.cancelBtnObj.hidden = YES;
    
    NSString *mobileNumber = [[NSString alloc] initWithFormat:@"%@%@",self.countryCodeObj.titleLabel.text, self.mobileNumberTxtFld.text];
    userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSLog(@"mobile number %@ user id %@", mobileNumber, userId);
    
    self.mobileNumberTxtFld.text = @"";
    
    
    if (mobileNumber.length==0) {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter your contact number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
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

    
    [PFCloud callFunctionInBackground:@"sendVerificationCodee"
                       withParameters:@{@"number": mobileNumber,
                                        @"userId": userId
                                        }
                                block:^(NSString *results, NSError *error) {
                                    [appDelegate() dismissMBHUD];
                                    
                                        NSLog(@"result: %@",results);
                                    
                                    if (!error) {
                                        if(![results integerValue])
                                        {
                                            [appDelegate() dismissMBHUD];
                                            appDelegate().contactStatus = isContactAddedNo;
                                            [self showAlertWithText:@"Favr" :@"We couldn't connect to the server"];
                                        }
                                        
                                        else
                                        {
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:mobileNumber forKey:@"MobileNumber"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            [appDelegate() dismissMBHUD];
                                            UIAlertView *fetchAlert = [[UIAlertView alloc] initWithTitle:@"Please enter code?"
                                                                                                 message:nil
                                                                                                delegate:self
                                                                                       cancelButtonTitle:@"Cancel"
                                                                                       otherButtonTitles:@"Continue", nil];
                                            [fetchAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                                            [[fetchAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
                                            [fetchAlert show];
                                            
                                        }

                                        
                                    }else{
                                        
                                        [appDelegate() dismissMBHUD];
                                        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [_alertView show];
                                    
                                    }
                                        
                                    
                                    
                                }];
    self.view.backgroundColor = [UIColor whiteColor];
}

// this method is executed when we tap create a group in group segement control
- (IBAction)createAGroupAction:(UIButton *)sender {
    
    if (findFriendArray.count==0) {
        
        UIAlertView *fetchAlert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"Please add contacts."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [fetchAlert show];
        return;
    }
    CreateFavrGroupVC *createFavrGroupVC = [[CreateFavrGroupVC alloc] init];
    [self.navigationController pushViewController:createFavrGroupVC animated:YES];
}

// when enter mobile number screen comes to verify number and user want to cancel this method is executed
- (IBAction)cancelAct:(UIButton *)sender {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mobileNumberTxtFld  resignFirstResponder];
    self.fetchFriendListFirstTimeObj.hidden = NO;
    self.countryCodePickerView.hidden = YES;
    self.countryCodeObj.hidden = YES;
    self.mobileNumberTxtFld.hidden = YES;
    self.goObj.hidden = YES;
    self.cancelBtnObj.hidden = YES;
    
    _lblWhenNoData.hidden = NO;
}

// SegmentControl action method
- (IBAction)contactGroupSegmentAct:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex==0)
    {
        [refresh endRefreshing];
        self.tableView.frame = tableRect;
        self.createAGroupObj.hidden = YES;
        
        contact_group =[NSString stringWithFormat:@"%@",kMsgContact];
        
        
        if (appDelegate().isNumberVerified == NO) {
            return;
        }
        
        
        [appDelegate() showMBHUD:@"Please Wait..."];
        [PFCloud callFunctionInBackground:@"findFriends"
                           withParameters:@{@"mobileNumbers": phoneNumbers,
                                            @"userId": userId
                                            }
                                    block:^(NSArray *results, NSError *error) {
                                        
                                        NSLog(@"_______________________%@",results);
                                        
                                        
                                        if (!error) {
                                            [findFriendArray removeAllObjects];
                                            
                                            for (int i = 0; i < results.count; i++)
                                            {
                                                tempArray = [[NSMutableArray alloc] init];
                                                [tempArray addObject:[[results objectAtIndex:i] objectForKey:@"fullName"]];
                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"userMobileNo"]];
                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"profilePicPath"]];
                                                [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                                                [findFriendArray addObject:tempArray];
                                            }
                                            [appDelegate() dismissMBHUD];
                                            NSLog(@"Find Friend Array %@", findFriendArray);
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:findFriendArray forKey:@"contactDetails"];
                                            //                                                                            NSLog(@"name %@, number %@", [[results objectAtIndex:0] objectForKey:@"fullName"], [[results objectAtIndex:0] valueForKey:@"userMobileNo"]);
                                            
                                            self.tableView.hidden = NO;
                                            self.segmentControl.hidden = NO;
                                            self.fetchFriendListFirstTimeObj.hidden = YES;
                                           
                                            
                                            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"fetchedStatus"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            self.arrContacts = [[AccessContactVC sharedManager] userContacts];
                                            self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
                                            
                                            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
                                            [self.navigationController.navigationBar.topItem setTitleView:titleView];
                                            self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
                                            
                                            NSMutableArray *contactListArray = [[NSMutableArray alloc] init];
                                            for (id obj in findFriendArray)
                                            {
                                                [contactListArray addObject:[obj objectAtIndex:0]];
                                            }
                                            NSLog(@"contactListArray %@", contactListArray);
                                            for(NSString* str in self.arrHeaders){
                                                NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
                                                NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
                                                NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
                                                if(tempArr.count>0)
                                                    [self.dictFilteredContacts setObject:tempArr forKey:str];
                                            }
                                            NSLog(@"Dict = %@",self.dictFilteredContacts);
                                            
                                            NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
                                            
                                            self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                            [self.tableView reloadData];
                                            if (findFriendArray.count==0) {
                                                _lblWhenNoData.hidden = NO;
                                                _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
                                                _lblWhenNoData.text = @"You have no contact added.";
                                                 self.fetchFriendListFirstTimeObj.hidden = NO;
                                                 appDelegate().contactStatus = isContactAddedNo;
                                            }else{
                                                _lblWhenNoData.hidden = YES;
                                                 self.fetchFriendListFirstTimeObj.hidden = YES;
                                                 appDelegate().contactStatus = isContactAddedYes;
                                            }
                                            
                                            
                                            
                                        }else{
                                            
                                            [appDelegate() dismissMBHUD];
                                            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [_alertView show];
                                            
                                        }
                                        
                                    }];
        
        
        
        
        
        
        if (findFriendArray.count==0) {
            appDelegate().contactStatus = isContactAddedNo;
            _lblWhenNoData.hidden = NO;
            self.fetchFriendListFirstTimeObj.hidden = NO;
            _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y-100);
            _lblWhenNoData.text = @"You have no contact added.";
        }else{
            appDelegate().contactStatus = isContactAddedYes;
            _lblWhenNoData.hidden = YES;
            self.fetchFriendListFirstTimeObj.hidden = YES;
        }
        
        
    }
    else
    {
        
        [refresh endRefreshing];
        self.tableView.frame = tableRect;
        CGRect rect = self.tableView.frame;
        self.createAGroupObj.hidden = NO;
        self.fetchFriendListFirstTimeObj.hidden = YES;
        rect.origin.y = rect.origin.y+40;
        rect.size.height = rect.size.height-40;
        self.tableView.frame = rect;
        contact_group =[NSString stringWithFormat:@"%@",kMsgGroup];
//        groupDetailsArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"groupDetails"];
        
        
         [appDelegate() showMBHUD:@"Please Wait..."];
        
        [self getGroupDetails];
    }
    [self.tableView reloadData];
}
#pragma mark ------------------------------------------------------------------------

#pragma mark --Method to Check group Details

-(void)checkGroupDetail{
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        [appDelegate() dismissMBHUD];
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    //        [groupDetailsArray removeAllObjects];
    
    groupIDArray = [[NSMutableArray alloc] init];
    temproryGroupDetailsArray = [[NSMutableArray alloc] init];
    //        [groupDetailsArray removeAllObjects];
    
    
    
    
    
    
    
    userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    [PFCloud callFunctionInBackground:@"getGroupForUser"
                       withParameters:@{
                                        @"userId": userId
                                        }
                                block:^(NSArray *results, NSError *error)
     {
         NSLog(@"result: %@",results);
         for (int i = 0; i <results.count; i++)
         {
             [groupIDArray addObject:[[results objectAtIndex:i] valueForKey:@"grpId"]];
         }
         
         
         
         
         
         
         [PFCloud callFunctionInBackground:@"getGroupDetail"
                            withParameters:@{
                                             @"grpId":groupIDArray
                                             }
                                     block:^(NSArray *results, NSError *error)
          {
              
              
              if (!error) {
                  
                  groupDetailsArray = [[NSMutableArray alloc] init];
                  
                  for (int i = 0; i< results.count; i++)
                  {
                      [temproryGroupDetailsArray addObject:[results objectAtIndex:i]];
                      NSMutableDictionary *groupDetailsDict = [[NSMutableDictionary alloc] init];
                      [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"objectId"] forKey:@"objectId"];
                      [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpAdmin"] forKey:@"grpAdmin"];
                      [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpDescription"] forKey:@"grpDescription"];
                      [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpImage"] forKey:@"grpImage"];
                      [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpName"] forKey:@"grpName"];
                      [groupDetailsArray addObject:groupDetailsDict];
                  }
                  //                                        [groupDetailsArray removeAllObjects];
                  //                                        groupDetailsArray = [[NSArray alloc] initWithArray:temproryGroupDetailsArray];
                  NSLog(@"results array %@", results);
                  if (groupDetailsArray.count > 0)
                  {
                      appDelegate().groupStatus = isGroupAddedYes;
                      [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"groupDetails"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                  }
                  //                                        [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"contact1Details"];
                  
                  
                  
                  if (groupDetailsArray.count==0) {
                      appDelegate().groupStatus = isGroupAddedNo;
                  }else{
                      _lblWhenNoData.hidden = YES;
                      appDelegate().groupStatus = isGroupAddedYes;
                  }
                  
                  [appDelegate() dismissMBHUD];
                  [self.tableView reloadData];
                  
              }
              else{
                  [appDelegate() dismissMBHUD];
                  
              }
              
              
          }
          ];
         
     }
     ];
    
}

#pragma mark ------------------------------------------------------------------------

#pragma mark -Method to get all group Details
// display list of group in tableview
-(void) getGroupDetails
{
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
         [appDelegate() dismissMBHUD];
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
//        [groupDetailsArray removeAllObjects];
        
        groupIDArray = [[NSMutableArray alloc] init];
        temproryGroupDetailsArray = [[NSMutableArray alloc] init];
//        [groupDetailsArray removeAllObjects];
    
    
    
   
    
   
    
        userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        [PFCloud callFunctionInBackground:@"getGroupForUser"
                           withParameters:@{
                                            @"userId": userId
                                            }
                                    block:^(NSArray *results, NSError *error)
         {
             NSLog(@"result: %@",results);
             for (int i = 0; i <results.count; i++)
             {
                 [groupIDArray addObject:[[results objectAtIndex:i] valueForKey:@"grpId"]];
             }
             
             
             
             
             
             
             [PFCloud callFunctionInBackground:@"getGroupDetail"
                                withParameters:@{
                                                 @"grpId":groupIDArray
                                                 }
                                         block:^(NSArray *results, NSError *error)
              {
                  
                  
                  if (!error) {
                      
                      groupDetailsArray = [[NSMutableArray alloc] init];
                      
                      for (int i = 0; i< results.count; i++)
                      {
                          [temproryGroupDetailsArray addObject:[results objectAtIndex:i]];
                          NSMutableDictionary *groupDetailsDict = [[NSMutableDictionary alloc] init];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"objectId"] forKey:@"objectId"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpAdmin"] forKey:@"grpAdmin"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpDescription"] forKey:@"grpDescription"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpImage"] forKey:@"grpImage"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpName"] forKey:@"grpName"];
                          [groupDetailsArray addObject:groupDetailsDict];
                      }
                      //                                        [groupDetailsArray removeAllObjects];
                      //                                        groupDetailsArray = [[NSArray alloc] initWithArray:temproryGroupDetailsArray];
                      NSLog(@"results array %@", results);
                      if (groupDetailsArray.count > 0)
                      {
                          appDelegate().groupStatus = isGroupAddedYes;
                          [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"groupDetails"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                      }
                      //                                        [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"contact1Details"];
                      
                      
                      
                      if (groupDetailsArray.count==0) {
                          _lblWhenNoData.hidden = NO;
                          _lblWhenNoData.center =CGPointMake(self.view.center.x, self.view.center.y);
                          appDelegate().groupStatus = isGroupAddedNo;
                          _lblWhenNoData.text = @"You have no group added.";
                      }else{
                          _lblWhenNoData.hidden = YES;
                          appDelegate().groupStatus = isGroupAddedYes;
                      }
                      
                      [appDelegate() dismissMBHUD];
                      [self.tableView reloadData];
                      
                  }
                  else{
                  [appDelegate() dismissMBHUD];
                  
                  }
                  
                  
              }
              ];
             
         }
         ];
    
}

#pragma mark ------------------------------------------------------------------------

#pragma mark --Method to reload Contacts in UITableView

// show popup of single, multiple and group favr list for selection
-(IBAction)reloadContactsTableView:(id)sender forEvent:(UIEvent*)event
{
    
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 100, 200);
    
    
    popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 160)];
    
    UIButton *singleFavrSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleFavrSelectBtn.frame = CGRectMake(5, 15, 30, 30);
    [singleFavrSelectBtn setBackgroundImage:[UIImage imageNamed:@"single"] forState:UIControlStateNormal];
    [singleFavrSelectBtn addTarget:self action:@selector(singleFavrSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    singleFavrSelectBtn.tag = 1;
    [popupView addSubview:singleFavrSelectBtn];
    
    
    UIButton *multipleFavrSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    multipleFavrSelectBtn.frame = CGRectMake(5, 65, 30, 30);
    [multipleFavrSelectBtn setBackgroundImage:[UIImage imageNamed:@"multiple"] forState:UIControlStateNormal];
    [multipleFavrSelectBtn addTarget:self action:@selector(singleFavrSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    multipleFavrSelectBtn.tag = 2;
    [popupView addSubview:multipleFavrSelectBtn];
    
    
    UIButton *groupFavrSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    groupFavrSelectBtn.frame = CGRectMake(5, 115, 30, 30);
    [groupFavrSelectBtn setBackgroundImage:[UIImage imageNamed:@"group"] forState:UIControlStateNormal];
    [groupFavrSelectBtn addTarget:self action:@selector(singleFavrSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    groupFavrSelectBtn.tag = 3;
    [popupView addSubview:groupFavrSelectBtn];
    
    popoverController = [[TSPopoverController alloc] initWithView:popupView];
    popoverController.cornerRadius = 5;
    
//    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor whiteColor];
    popoverController.popoverGradient= NO;
    //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
    
    
//    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"action sheet"];
//    [actionSheet destructiveButtonWithTitle:@"hoge" block:nil];
//    [actionSheet addButtonWithTitle:@"hoge1" block:^{
//        NSLog(@"pushed hoge1 button");
//    }];
//    [actionSheet addButtonWithTitle:@"moge2" block:^{
//        NSLog(@"pushed hoge2 button");
//    }];
//    [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
//    actionSheet.cornerRadius = 5;
//    [actionSheet showWithTouch:event];
    
    
    [self.tableView reloadData];
}

#pragma mark ------------------------------------------------------------------------

#pragma mark --Method to singleFavrSelect

// creation of single multiple and group favr
-(void) singleFavrSelectBtnAction: (UIButton *)sender
{
    
    
    if (sender.tag==1) {
        
        if ( findFriendArray.count==0) {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have no contact added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
             [popoverController dismissPopoverAnimatd:YES];
            return;
            
        }
        
        
    }
    else if (sender.tag==2){
        
        if ( findFriendArray.count==0) {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have no contact added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
             [popoverController dismissPopoverAnimatd:YES];
            return;
        }
    
    }
    else if (sender.tag==3){
        if (groupDetailsArray.count==0) {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have no group added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [popoverController dismissPopoverAnimatd:YES];
            [_alertView show];
            return;
        }
    
    }
    
    
    
    [popoverController dismissPopoverAnimatd:YES];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.groupSelected = sender.tag;
    
    CreateFavrVC *createFavrVC = [[CreateFavrVC alloc] init];
    [self.navigationController pushViewController:createFavrVC animated:YES];
}

@end
