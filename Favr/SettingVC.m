//
//  SettingVC.m
//  Favr
//
//  Created by Ankush on 24/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "SettingVC.h"
#import "LoginScreenVC.h"
#import "FirstScreenVC.h"
#import "OrderViewController.h"
#import "GiftCardsVC.h"
#import "PaypalVC.h"


@interface SettingVC ()


@end

@implementation SettingVC


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
   // settingArray = [[NSArray alloc] initWithObjects:@"About", @"Invite a Friend", @"Social Media", @"Gift Cards", @"Payment", @"Download", @"VideoTesting", nil];
    
    
    settingArray = [[NSArray alloc] initWithObjects:@"About", @"Invite a Friend", @"Social Media", @"Gift Cards", @"Payment",@"Logout", nil];//@"Logout"
    
  //  settingImageArray = [[NSArray alloc] initWithObjects: @"information-icon.png",  @"select-plus-icon.png", @"social-media-icon.png", @"gift-icon.png", @"cash-icon.png", @"information-icon.png", @"select-plus-icon.png", nil];
    
     settingImageArray = [[NSArray alloc] initWithObjects: @"information-icon.png",  @"select-plus-icon.png", @"social-media-icon.png", @"gift-icon.png", @"cash-icon.png",@"logout.png",  nil];//@"logout.png"
    
    self.navigationController.navigationBar.barTintColor = [ UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1];
    
     _tableView.separatorColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
    
//    self.navigationBar.backgroundColor = [ UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    SettingVCCell *cell = (SettingVCCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingVCCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.imageView.layer.cornerRadius = 20;
//    cell.imageView.layer.masksToBounds = YES;
    cell.titleLabel.text = [settingArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[settingImageArray objectAtIndex:indexPath.row]];
    
    ////*********Add Divider*********
    UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 43.0f, tableView.frame.size.width, 0.7f)];
    _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
    _imgViewDivider.alpha = 2.0;
    [cell.contentView addSubview:_imgViewDivider];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingArray count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        AboutVC *aboutVC = [[AboutVC alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if (indexPath.row == 1)
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
//        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Work in progress." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [_alertView show];
        InviteAFriendVC *inviteAFriendVC = [[InviteAFriendVC alloc] init];
        [self.navigationController pushViewController:inviteAFriendVC animated:YES];
    }
    else if (indexPath.row == 2)
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

        SocialMediaVC *sociaMediaVC = [[SocialMediaVC alloc] init];
        [self.navigationController pushViewController:sociaMediaVC animated:YES];
    }
    else if (indexPath.row == 3)
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
        GiftCardsVC *giftVC = [[GiftCardsVC alloc] init];
        [self.navigationController pushViewController:giftVC animated:YES];

    }
    else if (indexPath.row == 4)
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
        PaypalVC *paypalVC = [[PaypalVC alloc] init];
        [self.navigationController pushViewController:paypalVC animated:YES];
      // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/"]];
        
//        OrderViewController *_orderVC = [[OrderViewController alloc]init];
//        [self.navigationController pushViewController:_orderVC animated:YES];
        
      //  NSData *image = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"remove" ofType:@"png"]];
      //  [QBContent TUploadFile:image fileName:@"remove" contentType:@"image/png" isPublic:NO delegate:self];
    }
    else if (indexPath.row == 5)
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
        
        NSLog(@"_______________________%@",self.navigationController.viewControllers);
        appDelegate().userLogout = Logout;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AppHasInitiatedBefore"];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loggedInUserPassword"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loggedInUserEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userId"];
       // [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"fetchedStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //                                        [[NSUserDefaults standardUserDefaults] setObject:[[myDictionary objectAtIndex:0] valueForKey:@"objectId"] forKey:@"userId"];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        // [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
        [navigationArray removeObjectAtIndex: 1];
        
        self.navigationController.viewControllers = navigationArray;
        
        if ( appDelegate().getrootType  == fromloginVC) {
              [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else{
          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        
        
      
        
        
//        FirstScreenVC *loginVC = [[FirstScreenVC alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
        
        
        
//        DownloadingVC *downloadingVC = [[DownloadingVC alloc] init];
//        downloadingVC.downloadedId = uploadedImageId;
//        [self.navigationController pushViewController:downloadingVC animated:YES];
    }
    else
    {
//        VideoTesting *videoTesting = [[VideoTesting alloc] init];
//        [self.navigationController pushViewController:videoTesting animated:YES];
    }
}


#pragma mark OtherMethod

- (void)completedWithResult:(Result *)result
{
    // success result
    if(result.success){
        // Upload file result
        if([result isKindOfClass:QBCFileUploadTaskResult.class])
        {
            // get uploaded file ID
            QBCFileUploadTaskResult *res = (QBCFileUploadTaskResult *)result;
            NSUInteger uploadedFileID = res.uploadedBlob.ID;
            NSLog(@"uploadedFileID %lu", (unsigned long)uploadedFileID);
            uploadedImageId = (int)uploadedFileID;
        }
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
