//
//  GroupUserDetailsVC.m
//  Favr
//
//  Created by Ankush on 15/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "GroupUserDetailsVC.h"

@interface GroupUserDetailsVC ()

@end

@implementation GroupUserDetailsVC

@synthesize groupID;

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
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    objectIdArray = [[NSMutableArray alloc] init];
    
    self.acceptedImageView.backgroundColor = [UIColor redColor];
    self.acceptedFavrImageView.backgroundColor = [UIColor redColor];
    self.rejectedFavrImageView.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255 blue:202.0/255 alpha:1];
    self.askedFavrImageView.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255 blue:202.0/255 alpha:1];
    self.acceptedImageView.layer.cornerRadius = 20.0f;
    self.acceptedFavrImageView.layer.cornerRadius = 8.0f;
    self.askedFavrImageView.layer.cornerRadius = 20.0f;
    self.profileImageView.layer.cornerRadius = 45.0f;
    self.rejectedFavrImageView.layer.cornerRadius = 20.0f;
    
    self.acceptedImageView.layer.masksToBounds=YES;
    self.acceptedFavrImageView.layer.masksToBounds = YES;
    self.askedFavrImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.masksToBounds = YES;
    
    
//    addRemoveTag = 0;
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
    
    userIdArray = [[NSMutableArray alloc] init];
    
    groupUserArray = [[NSMutableArray alloc] init];
    
    static int flag;
    flag = 0;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.addContactUserId.length > 1)
    {
        [PFCloud callFunctionInBackground:@"addUserToGrp"
                           withParameters:@{
                                            @"grpId": groupID,
                                            @"userId": appDelegate.addContactUserId
                                            }
                                    block:^(NSArray *result, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"result %@", result);
                 //                                       flag = 0;
                 [self scrollViewMethodCalled:userIdArray.count];
             }
             appDelegate.addContactUserId = nil;
         }];

    }
    
    
    
    
    [PFCloud callFunctionInBackground:@"getGroupDetail2"
                       withParameters:@{
                                        @"grpId": groupID
                                        }
                                block:^(NSArray *results, NSError *error)
     {
         if (!error)
         {
             
             groupDetails = [[NSArray alloc] initWithArray:results];
             NSLog(@"groupDetails %@", groupDetails);
             [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[[[results objectAtIndex:1] objectAtIndex:0] valueForKey:@"grpImage"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
             self.groupFullName.text = [[[results objectAtIndex:1] objectAtIndex:0] valueForKey:@"grpName"];
             self.aboutMeLabel.text = [[[results objectAtIndex:1] objectAtIndex:0] valueForKey:@"grpDescription"];
             
             
             
             for (int i = 0; i < [[results objectAtIndex:0] count]; i++)
             {
                 [userIdArray addObject:[[[results objectAtIndex:0] objectAtIndex:i] valueForKey:@"userId"]];
                 [objectIdArray addObject:[[[results objectAtIndex:0] objectAtIndex:i] valueForKey:@"objectId"]];
             }
             
             for (int i = 0; i < [userIdArray count]; i++)
             {
                 [PFCloud callFunctionInBackground:@"getDetailUser"
                                    withParameters:@{
                                                     @"userId": [userIdArray objectAtIndex:i]
                                                     }
                                             block:^(NSArray *results, NSError *error)
                  {
                      NSLog(@"get user details %@", results);
                      NSMutableArray *userDataArr = [[NSMutableArray alloc] init];
                      [userDataArr addObject:[results valueForKey:@"profilePicPath"]];
                      [userDataArr addObject:[results valueForKey:@"fullName"]];
                      [groupUserArray addObject:userDataArr];
                      flag ++;
                      numberOfUser = userIdArray.count;
                      
                      
                      if (userIdArray.count == flag)
                      {
                          if (appDelegate.addContactUserId.length > 1)
                          {
                              flag = 0;
                          }
                          else
                          {
                              flag = 0;
                               [appDelegate dismissMBHUD];
                              [self scrollViewMethodCalled:userIdArray.count];
                          }
                      }
                      
                     

                  }];
             }
         }
         else
         {
             NSLog(@"Error Occured");
             [appDelegate dismissMBHUD];
         }
     }
     ];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)addRemove:(UIButton *)sender
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
    

    
    NSLog(@"tag %i", sender.tag);
    if (addRemoveTag == -1)
    {
        [PFCloud callFunctionInBackground:@"deleteUserFromGrp"
                           withParameters:@{
                                            @"objectId": [objectIdArray objectAtIndex:sender.tag]
                                            }
                                    block:^(NSArray *results, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"results %@", results);
                 [self viewWillAppear:YES];
             }
         }];
    }
    else if (addRemoveTag == 1)
    {
        AddContactToVC *addContactToVC = [[AddContactToVC alloc] init];
        [self.navigationController pushViewController:addContactToVC animated:YES];
        
//        [PFCloud callFunctionInBackground:@"addUserToGrp"
//                           withParameters:@{
//                                            @"grpId": [objectIdArray objectAtIndex:sender.tag],
//                                            @"userId": [objectIdArray objectAtIndex:sender.tag]
//                                            }
//                                    block:^(NSArray *result, NSError *error)
//        {
//            if (!error)
//            {
//                NSLog(@"result %@", result);
//            }
//        }];
    }
}

#pragma mark ScrollView

// this method display list of users in scrollview
-(void) scrollViewMethodCalled :(int) numberOfViews
{
    
    for (UIView *subview in self.mainScrollView.subviews) {
        if([subview isKindOfClass:[UIImageView class]])
            [subview removeFromSuperview];
        
        if([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin;
        if (i==0) {
            
        //xOrigin = i * self.mainScrollView.frame.size.width;
            xOrigin=0.0;
            
        }
        else{
         xOrigin = xOrigin+160;
        
        }
        NSLog(@"____________________%@",groupUserArray);
        NSLog(@"_____________________%@",[NSString stringWithFormat:@"%@", [[[groupUserArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:0]]);
        
        
        
        
        
        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        userButton.frame = CGRectMake(xOrigin, 140, 150, 50);
        [userButton setTitle:[NSString stringWithFormat:@"%@",[[[groupUserArray objectAtIndex:i] objectAtIndex:1] objectAtIndex:0]] forState:UIControlStateNormal];
       // userButton.titleLabel.textAlignment  = NSTextAlignmentCenter;
        [userButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.mainScrollView addSubview:userButton];
        
        UIImageView *demoImage = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, 150, 150)];
        [demoImage sd_setImageWithURL:[NSURL URLWithString:[[[groupUserArray objectAtIndex:i] objectAtIndex:0] objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
        
        demoImage.layer.cornerRadius = 150/2;
        demoImage.layer.masksToBounds=YES;
        
        [self.mainScrollView addSubview:demoImage];
        
        UIButton *userButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        userButton1.frame = CGRectMake(xOrigin, 0, 150, 150);
        [self.mainScrollView addSubview:userButton1];

        
        if (addRemoveTag == 1)
        {
            addRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addRemoveButton.frame = CGRectMake(0, 0, 30, 30);
            [addRemoveButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
            addRemoveButton.tag = i;
            [addRemoveButton addTarget:self action:@selector(addRemove:) forControlEvents:UIControlEventTouchUpInside];
            [userButton1 addSubview:addRemoveButton];
        }
        else if (addRemoveTag == -1)
        {
            addRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addRemoveButton.frame = CGRectMake(0, 0, 30, 30);
            [addRemoveButton setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
            addRemoveButton.tag = i;
            [addRemoveButton addTarget:self action:@selector(addRemove:) forControlEvents:UIControlEventTouchUpInside];
            [userButton1 addSubview:addRemoveButton];
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(160 * numberOfViews, 150);
    
    self.mainScrollView.delegate=self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mainScrollView.isDragging || self.mainScrollView.isDecelerating){
//        self.pageControl.currentPage = lround(self.mainScrollView.contentOffset.x / (self.mainScrollView.contentSize.width / self.pageControl.numberOfPages));
    }
}

#pragma mark OtherMethod
// this method add user into existing contact list
- (IBAction)addUserToGroup:(UIButton *)sender
{
    AddContactToVC *addContactToVC = [[AddContactToVC alloc] init];
    [self.navigationController pushViewController:addContactToVC animated:YES];
    if (addRemoveTag == 1)
    {
        addRemoveTag = 0;
    }
    else
    {
        addRemoveTag = 1;
    }
    [self scrollViewMethodCalled:numberOfUser];
}

// this method remove user from existing list
- (IBAction)removeUserFromGroup:(UIButton *)sender
{
    if (addRemoveTag == -1)
    {
        addRemoveTag = 0;
    }
    else
    {
        addRemoveTag = -1;
    }
    
    [self scrollViewMethodCalled:numberOfUser];
}

// navigates to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addMemberToGroup:(UIButton *)sender {
    
}

- (IBAction)removeMemberToGroup:(UIButton *)sender {
    
}
@end
