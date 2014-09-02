//
//  InviteAFriendVC.m
//  Favr
//
//  Created by Ankush on 03/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "InviteAFriendVC.h"

#import "ContactsData.h"

@interface InviteAFriendVC ()
{
    NSArray *arrContacts, *arrHeaders;
    NSMutableDictionary *dictFilteredContacts;
    NSArray *allKeys;
}
@end

@implementation InviteAFriendVC


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
    
    [[AccessContactVC sharedManager] fetchContacts];
    arrContacts = [[AccessContactVC sharedManager] userContacts];
    
    dictFilteredContacts =[[NSMutableDictionary alloc]init];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
    [self.navigationController.navigationBar.topItem setTitleView:titleView];
    arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    for(NSString* str in arrHeaders){
        NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
        //   NSLog(@"Pred Str = %@",strPred);
        NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
        NSArray* tempArr =[arrContacts filteredArrayUsingPredicate:namesBeginning];
        //   NSLog(@"Count  = %d", tempArr.count);
        if(tempArr.count>0)
            [dictFilteredContacts setObject:tempArr forKey:str];
    }
    NSLog(@"Dict = %@",dictFilteredContacts);
    NSArray* tempAllKeys = [dictFilteredContacts allKeys];
//    self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
//    contactArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"contactDetails"]];
//    NSLog(@"contact array %@", contactArray);
//    findFriendArray = [[NSMutableArray alloc] init];
//    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Loading";
//    
//    NSString *phoneNumbers = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobileNumbers"];
//    NSArray *phoneNumbersArray = [NSArray arrayWithObject:phoneNumbers];
//    
//    [PFCloud callFunctionInBackground:@"findFriends"
//                       withParameters:@{@"mobileNumbers": phoneNumbersArray}
//                                block:^(NSArray *results, NSError *error) {
//                                    
//                                    if (!error)
//                                    {
//                                        for (int i = 0; i < results.count; i++)
//                                        {
//                                            tempArray = [[NSMutableArray alloc] init];
//                                            [tempArray addObject:[[results objectAtIndex:i] objectForKey:@"fullName"]];
//                                            [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"userMobileNo"]];
//                                            [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"profilePicPath"]];
//                                            [tempArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
//                                            [findFriendArray addObject:tempArray];
//                                        }
//                                        NSLog(@"Find Friend Array %@", findFriendArray);
//                                        [self.tableView reloadData];
//                                        [hud hide:YES];
//                                        [[NSUserDefaults standardUserDefaults] setObject:findFriendArray forKey:@"contactDetails"];
//                                    }
//                                    
//     }
//     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [findFriendArray count];
    return  [dictFilteredContacts count];
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *cellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    cell.textLabel.text = [[findFriendArray objectAtIndex:indexPath.row] objectAtIndex:0];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[findFriendArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//    cell.imageView.layer.cornerRadius = 27.0f;
//    cell.imageView.layer.masksToBounds=YES;
//    
//    
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdent = [NSString stringWithFormat:@"CellIdent"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ////*********Add Divider*********
        UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 43.0f, tableView.frame.size.width, 0.7f)];
        _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
        _imgViewDivider.alpha = 2.0;
        [cell.contentView addSubview:_imgViewDivider];
    }
//    NSString* currentKey = [allKeys objectAtIndex:indexPath.section];
//    NSArray* tempContactArr = [dictFilteredContacts objectForKey:currentKey];
    
//    NSString* fname =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).firstNames;
//    NSString* lName =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).lastNames;
    
    
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",((ContactsData*)[arrContacts objectAtIndex:indexPath.row]).firstNames];
    cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"_____________________%@",[NSString stringWithFormat:@"%@",((ContactsData*)[arrContacts objectAtIndex:indexPath.row]).numbers]);
    
    
    
    
[self sendSMS:@"Come join me on Favr..." recipientList:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",((ContactsData*)[arrContacts objectAtIndex:indexPath.row]).numbers], nil]];

}

#pragma  Method to Send the Message/SMS
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
    
//    UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Message cancelled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//     [_alertView show];
    }
    
    else if (result == MessageComposeResultSent){
            NSLog(@"Message sent");
//        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Message sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [_alertView show];
    }
    else{
                NSLog(@"Message failed") ;
//        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Message failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [_alertView show];

    }
                }
#pragma mark OtherMethod

- (IBAction)backBtnAct:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
