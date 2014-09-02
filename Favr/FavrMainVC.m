//
//  FavrMainVC.m
//  Favr
//
//  Created by Taranjit Singh on 14/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//
@import QuartzCore;
#import "FavrMainVC.h"
#import "FavrCell.h"
#import "ChatSharedManager.h"
#import "TSPopoverController.h"

@interface FavrMainVC ()
{
    NSString* incomming_Outgoing;
    NSMutableArray* arrData;
    NSArray *selectedRows;
    UIView  *popupView;
    TSPopoverController  *popoverController;
}

@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) NSString *opponetChatUserId;

@end

static NSString const *kMsgIncomming = @"INCOMMING";
static NSString const *kMsgOutgoing = @"OUTGOING";
static NSString *kDeleteAllTitle = @"Delete All";
static NSString *kDeletePartialTitle = @"Delete (%d)";

@implementation FavrMainVC


#pragma mark View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.users = [[ChatSharedManager sharedManager] chatUsers];
    
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
//    refresh = [[UIRefreshControl alloc] init];
//    refresh.tintColor = [UIColor grayColor];
//    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
//    [refresh addTarget:self action:@selector(get_vrns) forControlEvents:UIControlEventValueChanged];
//    tableViewController.refreshControl = refresh;
   pullToRefreshBool = NO;
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    

    [self get_vrns1];
    
    self.tableView.rowHeight = 70;
    
    
    // Do any additional setup after loading the view.
    editingModeOn = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
//    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
//    [self.navigationBar.topItem setTitleView:titleView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"FavrCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
    incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
    arrData = [[NSMutableArray alloc]initWithObjects:@"Favour 1",@"Favour 2",@"Favour 3",@"Favour 4",@"Favour 5",@"Favour 6",@"Favour 7",@"Favour 8",@"Favour 9",@"Favour 10", nil];
    self.dataArray = [[NSMutableArray alloc]initWithObjects:@"Favour 1",@"Favour 2",@"Favour 3",@"Favour 4",@"Favour 5",@"Favour 6",@"Favour 7",@"Favour 8",@"Favour 9",@"Favour 10", nil];
    
    ////************UILable Display when No Favr User*****************
    _lblWhenNoData = [[UILabel alloc]initWithFrame:CGRectMake(0.0,0.0 , self.view.frame.size.width,30.0)];
    _lblWhenNoData.backgroundColor = [UIColor clearColor];
    _lblWhenNoData.center = self.view.center;
    _lblWhenNoData.textAlignment = NSTextAlignmentCenter;
    _lblWhenNoData.text = @"You have not Received any favr";
    _lblWhenNoData.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_lblWhenNoData];
    _lblWhenNoData.hidden = YES;
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    NSString *_chatUserName= [[NSUserDefaults standardUserDefaults]objectForKey:@"chatUserName"];
    NSString *_password=  [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [[ChatSharedManager sharedManager] setTxtUserName:_chatUserName];
    [[ChatSharedManager sharedManager] setTxtUserPassword:_password];
    [[ChatSharedManager sharedManager] loginChatFunction:@"LOGIN"];
    
    
    [super viewWillAppear:YES];
     [appDelegate().chatRoom leaveRoom];
//    [self get_vrns];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    [self performSelector:@selector(get_vrns1) withObject:nil afterDelay:0.0];
    
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




// pull to refresh action when pullToRefreshBool = YES
-(void) get_vrns
{
    pullToRefreshBool = YES;
    NSLog(@"pull to refresh");
    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
    {
     //   [incomingFavrListArray removeAllObjects];
      //  [incomingFavrUserArray removeAllObjects];
    }
    else if ([incomming_Outgoing isEqualToString:(NSString *) kMsgOutgoing])
    {
       // [outgoingFavrListArray removeAllObjects];
       // [outgoingFavrListArray removeAllObjects];
    }
    
    [self refreshData:self.segmentControl];
    
}

// pull to refresh action when pullToRefresh = NO
-(void) get_vrns1
{
    pullToRefreshBool = NO;
    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
    {
        [incomingFavrListArray removeAllObjects];
        [incomingFavrUserArray removeAllObjects];
    }
    else if ([incomming_Outgoing isEqualToString:(NSString *) kMsgOutgoing])
    {
        [outgoingFavrListArray removeAllObjects];
        [outgoingFavrListArray removeAllObjects];
    }
    
    [self refreshData:self.segmentControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
    {
        
        if (incomingFavrListArray.count>0)
        {
            return [incomingFavrListArray count];

        }
        
        
    }
    else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
    {
        
        if (outgoingFavrListArray.count>0)
        {
            return [outgoingFavrListArray count];
            
        }
        
    }
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell; // = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            
//            UIView *selectionColor = [[UIView alloc] init];
//            selectionColor.backgroundColor = [UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
//            cell.selectedBackgroundView = selectionColor;
            cell.delegate = self;
          //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if ([incomming_Outgoing isEqualToString:(NSString*)kMsgIncomming])
        {
            cell.rightUtilityButtons = [self rightButtonsForIncoming];
        }
        else
        {
            cell.rightUtilityButtons = [self rightButtonsForOutgoing];
        }
        
        UIButton *favrInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        favrInfo.frame = CGRectMake(285, 20, 30, 30);
        [favrInfo setImage:[UIImage imageNamed:@"info_icon"] forState:UIControlStateNormal];
        [favrInfo addTarget:self action:@selector(favrInfoBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        //        [checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        favrInfo.tag = indexPath.row;
      //  [cell.contentView addSubview:favrInfo];
    
    
    
    
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        profileImageView.tag = indexPath.row;
        [cell.contentView addSubview:profileImageView];
        profileImageView.layer.cornerRadius = 20.f;
        profileImageView.layer.masksToBounds = YES;
    
    
        cell.imageView.hidden = YES;
        
        cell.imageView.layer.cornerRadius = 32.0f;
        cell.imageView.layer.masksToBounds=YES;
        
        if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
        {
            
            UIImageView *favrAcceptedRejectedImgView = [[UIImageView alloc] init];
            favrAcceptedRejectedImgView.frame = CGRectMake(230, 20, 30, 30);
//            favrAcceptedRejectedImgView.backgroundColor = [UIColor purpleColor];
            [cell.contentView addSubview:favrAcceptedRejectedImgView];
            if ([[[incomingFavrListArray  objectAtIndex:indexPath.row] objectAtIndex:3] intValue] == 1)
            {
                favrAcceptedRejectedImgView.image = [UIImage imageNamed:@"acceptedFavr.png"];
            }
            else if ([[[incomingFavrListArray  objectAtIndex:indexPath.row] objectAtIndex:3] intValue] == 2)
            {
                favrAcceptedRejectedImgView.image = [UIImage imageNamed:@"rejectedFavr.png"];
            }
            
            if (incomingFavrListArray.count==0) {
                
            }else{
                // favrInfo.tag = indexPath.row;
                cell.textLabel.text = [[incomingFavrListArray  objectAtIndex:indexPath.row] objectAtIndex:0];
                cell.textLabel.textColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
                [profileImageView sd_setImageWithURL:[NSURL URLWithString:[[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:6]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
                cell.imageView.image = [UIImage imageNamed:@"userImg"];
                cell.detailTextLabel.text = [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:7];
                
                ////*********Add Divider*********
                UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 69.0f, tableView.frame.size.width, 0.7f)];
                _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
                _imgViewDivider.alpha = 2.0;
                [cell.contentView addSubview:_imgViewDivider];


            }
            
            
            
            
        }
        else
        {
            
            if (outgoingFavrListArray.count==0) {
                
            }else{
            }
//            favrAcceptedRejectedImgView.image = [UIImage imageNamed:@"abc"];
          //  favrInfo.tag = 1000+indexPath.row;
            cell.textLabel.text = [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.textLabel.textColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
            [profileImageView sd_setImageWithURL:[NSURL URLWithString:[[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:9]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
            cell.imageView.image = [UIImage imageNamed:@"userImage2.jpg"];
            cell.detailTextLabel.text = [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:8];
            
            ////*********Add Divider*********
            UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 69.0f, tableView.frame.size.width, 0.7f)];
            _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
            _imgViewDivider.alpha = 2.0;
            [cell.contentView addSubview:_imgViewDivider];

        }
    
    
        return cell;
//    }

    
    
    
//    NSString *cellIdentifier = @"cell";
//
//    
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
////    if (cell == nil)
////    {
////       UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
////    }
//    
//    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        
//        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        cell.delegate = self;
//    }
//    
//    
//    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    profileImageView.layer.cornerRadius = 25.0f;
//    profileImageView.layer.masksToBounds=YES;
//    [cell.contentView addSubview:profileImageView];
//    
//    
//    
//    favourNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 166, 21)];
//    favourNumberLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:190.0/255 blue:202.0/255 alpha:1];
//    [cell.contentView addSubview:favourNumberLabel];
//    
//    
//    profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 36, 166, 21)];
//    profileNameLabel.font = [UIFont fontWithName:@"Arial" size:12];
//    [cell.contentView addSubview:profileNameLabel];
//    
//    
//    profileInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
//    profileInfoBtn.tag = indexPath.row;
//    profileInfoBtn.frame = CGRectMake(286, 29, 22, 22);
//    if (editingModeOn)
//    {
//        UIButton *button = profileInfoBtn; //(get button from cell using a property, a tag, etc.)
//        BOOL isEditing = !self.editing;  //(obtain the state however you like)
//        button.hidden = isEditing;
//    }
//    [cell.contentView addSubview:profileInfoBtn];
//    
//    
//    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
//    {
//        profileImageView.image = [UIImage imageNamed:@"userImg"];
//        profileNameLabel.text = @"Jane Doe";
//    }
//    else
//    {
//        profileImageView.image = [UIImage imageNamed:@"userImage2.jpg"];
//        profileNameLabel.text = @"Sandy Jolie";
//    }
//    
//    favourNumberLabel.text = [self.dataArray objectAtIndex:indexPath.row];
//    
//    return cell;
    
    
    
    
    
    
    
    
//    static NSString  *cellIdentifier = @"cellIdentifier";
// 
//    FavrCell *cell = (FavrCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//
//    
//    if(!cell){
//        cell = [[FavrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    }
//    if ([incomming_Outgoing isEqualToString:(NSString*)kMsgIncomming]) {
//        cell.rightUtilityButtons = [self rightButtonsForIncoming];
//        cell.imgFavrPic.image = [UIImage imageNamed:@"userImg"];
//        cell.lblFavrName.text = @"Jane Doe";
//    }
//    else{
//        cell.rightUtilityButtons = [self rightButtonsForOutgoing];
//        cell.imgFavrPic.image = [UIImage imageNamed:@"userImage2.jpg"];
//        cell.lblFavrName.text = @"Sandy Jolie";
//    }
////    cell.delegate = self;
//
//    cell.imgFavrPic.layer.cornerRadius = 25.0f;
//    cell.imgFavrPic.layer.masksToBounds=YES;
//
//    cell.lblFavrNo.text = [arrData objectAtIndex:indexPath.row];
//        return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
        [tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"can edit at index path");
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing)
    {
        selectedRows = [self.tableView indexPathsForSelectedRows];
        //        self.deleteButton.title = (selectedRows.count == 0) ?
        //        kDeleteAllTitle : [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
    }
    
    if (editingModeOn == YES) {
        
    }else{
        
        
        if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
        {
            FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
            favrInfoVC.favrId = [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:2];
            favrInfoVC.navigationTitle = [[incomingFavrUserArray objectAtIndex:indexPath.row] objectAtIndex:0];
            favrInfoVC.incoming_outgoingString = (NSString *)kMsgIncomming;
            favrInfoVC.pendingFavrStatus = 2;
            favrInfoVC.strGetTabText = @"favr";
            [self.navigationController pushViewController:favrInfoVC animated:YES];
        }
        else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
        {
            FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
            favrInfoVC.favrId = [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:2];
            favrInfoVC.navigationTitle = [[outgoingFavrUserInfo objectAtIndex:indexPath.row] objectAtIndex:0];
            favrInfoVC.incoming_outgoingString = (NSString *)kMsgOutgoing;
            favrInfoVC.pendingFavrStatus = 2;
            favrInfoVC.strGetTabText = @"favr";
            [self.navigationController pushViewController:favrInfoVC animated:YES];
        }
        
        
    }

    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    rowNumber = indexPath.row;
    
    if (self.tableView.isEditing)
    {
        selectedRows = [self.tableView indexPathsForSelectedRows];
//        NSString *deleteButtonTitle = [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
        
        if (selectedRows.count == self.dataArray.count)
        {
//            deleteButtonTitle = kDeleteAllTitle;
        }
        //        self.deleteButton.title = deleteButtonTitle;
    }
    if (editingModeOn == YES) {
        
    }else{
        
        
        if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
        {
            FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
            favrInfoVC.favrId = [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:2];
            favrInfoVC.navigationTitle = [[incomingFavrUserArray objectAtIndex:indexPath.row] objectAtIndex:0];
            favrInfoVC.incoming_outgoingString = (NSString *)kMsgIncomming;
            favrInfoVC.pendingFavrStatus = 2;
            favrInfoVC.strGetTabText = @"favr";
            [self.navigationController pushViewController:favrInfoVC animated:YES];
        }
        else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
        {
            FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
            favrInfoVC.favrId = [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:2];
            favrInfoVC.navigationTitle = [[outgoingFavrUserInfo objectAtIndex:indexPath.row] objectAtIndex:0];
            favrInfoVC.incoming_outgoingString = (NSString *)kMsgOutgoing;
            favrInfoVC.pendingFavrStatus = 2;
            favrInfoVC.strGetTabText = @"favr";
            [self.navigationController pushViewController:favrInfoVC animated:YES];
        }
        
        
    }

    
    
    
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing)
    {
        // add your button
        profileInfoBtn.hidden = YES;
        
    }
    else
    {
        // remove your button
        profileInfoBtn.hidden = YES;
    }
}




#pragma mark SWTableViewDataSource


- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state)
    {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
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
    
    cell = (SWTableViewCell *)[self.tableView viewWithTag:cell.tag];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"rowid_________________%d",indexPath.row);
    
    NSLog(@"_________________%@",incomingFavrListArray);
    
    
    
    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
    {
        switch (index) {
            case 0:
            {
                
                NSLog(@"_____________________________________%@",[[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:4]);
                
                favrInteger=[[[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:4] integerValue];
                
                
                if ([[[incomingFavrListArray objectAtIndex:index] objectAtIndex:4] integerValue]==1) {
                    
                    inCommingHelperID = [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:5];
                    [self chatScreen:(NSString *)kMsgIncomming];
                    return;
                    
                }
                
                
                if (appDelegate().chatType==helpee) {
                    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
                    {
                        
                        [appDelegate() showMBHUD:@"Please Wait..."];
                        
                        [PFCloud callFunctionInBackground:@"getDetailUser"
                                           withParameters:@{
                                                            @"userId": [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:1]
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
                                 
                                 [self chatScreen:(NSString *)kMsgIncomming];
                                 
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
                    
                    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
                    {
                        
                        [appDelegate() showMBHUD:@"Please Wait..."];
                        
                        [PFCloud callFunctionInBackground:@"getDetailUser"
                                           withParameters:@{
                                                            @"userId": [[incomingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:5]
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
                                 
                                 [self chatScreen:(NSString *)kMsgIncomming];
                                 
                             }
                             else
                             {
                                 NSLog(@"Error Occured");
                             }
                         }
                         ];
                    }
                    
                }
                
                //            NSLog(@"More button was pressed");
                //            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
                //            [alertTest show];
                //
                //            [cell hideUtilityButtonsAnimated:YES];
                break;
            }
//            case 1:
//            {
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeIndeterminate;
//                hud.labelText = @"Loading";
//                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
//                [PFCloud callFunctionInBackground:@"acceptFavr"
//                                   withParameters:@{@"favrId": favrId}
//                                            block:^(NSString *results, NSError *error) {
//                                                if ([results intValue])
//                                                {
//                                                    [hud hide:YES];
//                                                    [self get_vrns];
//                                                }
//                                            }];
//                break;
//                
//            }
//            case 2:
//            {
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeIndeterminate;
//                hud.labelText = @"Loading";
//                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
//                [PFCloud callFunctionInBackground:@"rejectFavr"
//                                   withParameters:@{@"favrId": favrId}
//                                            block:^(NSString *results, NSError *error) {
//                                                if ([results intValue])
//                                                {
//                                                    [hud hide:YES];
//                                                    [self get_vrns];
//                                                }
//                                            }];
//                break;
//            }
            case 1:
            {
               
                [appDelegate() showMBHUD:@"Please Wait..."];
                
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
                [PFCloud callFunctionInBackground:@"delete2"
                                   withParameters:@{@"favrId": favrId}
                                            block:^(NSString *results, NSError *error) {
                                                if ([results intValue])
                                                {
                                                   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                    [appDelegate() dismissMBHUD];
                                                    [self get_vrns];
                                                }
                                            }];
                break;
                
                // Delete button was pressed
                //            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                //            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
                //            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                //            break;
            }
            default:
                break;
        }
        
    }
    else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
    {
        switch (index) {
            case 1:
            {
                 NSLog(@"_____________________________________%@",outgoingFavrListArray);
                
                NSLog(@"_____________________________________%@",[[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:4]);
                NSLog(@"helperID_____________________________________%@",[[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:1]);
                
                favrInteger=[[[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:4] integerValue];
                
                if ([[[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:4] integerValue]==1) {
                    outGoingHelperID = [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:1] ;
                    [self chatScreen:(NSString *)kMsgOutgoing];
                    return;
                    
                }
                
                
                if (appDelegate().chatType==helpee) {
                    
                    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
                    {
                        
                        [appDelegate() showMBHUD:@"Please Wait..."];
                        [PFCloud callFunctionInBackground:@"getDetailUser"
                                           withParameters:@{
                                                            @"userId": [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:5]
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
                                 
                                 [self chatScreen:(NSString *)kMsgOutgoing];
                                 
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
                    
                    
                    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
                    {
                        
                        [appDelegate() showMBHUD:@"Please Wait..."];
                        [PFCloud callFunctionInBackground:@"getDetailUser"
                                           withParameters:@{
                                                            @"userId": [[outgoingFavrListArray objectAtIndex:indexPath.row] objectAtIndex:1]
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
                                 
                                 [self chatScreen:(NSString *)kMsgOutgoing];
                                 
                             }
                             else
                             {
                                 NSLog(@"Error Occured");
                             }
                         }
                         ];
                    }
                    
                    
                }
                
                //            NSLog(@"More button was pressed");
                //            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
                //            [alertTest show];
                //
                //            [cell hideUtilityButtonsAnimated:YES];
                break;
            }
//            case 1:
//            {
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeIndeterminate;
//                hud.labelText = @"Loading";
//                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
//                [PFCloud callFunctionInBackground:@"acceptFavr"
//                                   withParameters:@{@"favrId": favrId}
//                                            block:^(NSString *results, NSError *error) {
//                                                if ([results intValue])
//                                                {
//                                                    [hud hide:YES];
//                                                    [self get_vrns];
//                                                }
//                                            }];
//                break;
//                
//            }
//            case 2:
//            {
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeIndeterminate;
//                hud.labelText = @"Loading";
//                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
//                [PFCloud callFunctionInBackground:@"rejectFavr"
//                                   withParameters:@{@"favrId": favrId}
//                                            block:^(NSString *results, NSError *error) {
//                                                if ([results intValue])
//                                                {
//                                                    [hud hide:YES];
//                                                    [self get_vrns];
//                                                }
//                                            }];
//                break;
//            }
            case 2:
            {
                
                [appDelegate() showMBHUD:@"Please Wait"];
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                NSString *favrId = [[incomingFavrListArray objectAtIndex:cellIndexPath.row] objectAtIndex:2];
                [PFCloud callFunctionInBackground:@"delete2"
                                   withParameters:@{@"favrId": favrId}
                                            block:^(NSString *results, NSError *error) {
                                                if ([results intValue])
                                                {
                                                   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                    [appDelegate() dismissMBHUD];
                                                    [self get_vrns];
                                                }
                                            }];
                break;
                
                // Delete button was pressed
                //            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                //            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
                //            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                //            break;
            }
            default:
                break;
        }
        
    }

    
//    switch (index)
//    {
//        case 0:
//        {
//            NSLog(@"More button was pressed");
//            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//            [alertTest show];
//            
//            [cell hideUtilityButtonsAnimated:YES];
//            break;
//        }
//        case 3:
//        {
//            // Delete button was pressed
//            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//            
//            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            break;
//        }
//        default:
//            break;
//    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state)
    {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}



//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
//    NSLog(@"Right index  = %d",index);
//    if([incomming_Outgoing isEqualToString:(NSString*)kMsgIncomming]){
//        if(index==3){
//            // Delete button was pressed
//            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//            
//            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
//    else{
//        if(index==2){
//            // Delete button was pressed
//            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//            
//            [self.dataArray removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
//                                  withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
//}
//
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
//{
//    NSLog(@"swipeable table view cell");
//}

- (NSArray *)rightButtonsForIncoming
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cellChat"]];
    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cross"]];
//    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"check"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"trashBtn_unselected"]];
    return rightUtilityButtons;
}

- (NSArray *)rightButtonsForOutgoing
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cellEdit"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cellChat"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"trashBtn_unselected"]];
    
    return rightUtilityButtons;
}


#pragma mark UISegmentControl

-(void)refreshData:(UISegmentedControl*)sender{
    if(sender.selectedSegmentIndex==0)
    {
        
        
        appDelegate().chatType = helpee;
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
        if (incomingFavrListArray.count>0)
        {
            _lblWhenNoData.hidden = YES;
            [appDelegate() showMBHUD:@"Please Wait..."];
            [self.tableView reloadData];
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [appDelegate() dismissMBHUD];
            [refresh endRefreshing];
        }
        else
        {
            if (pullToRefreshBool == NO)
            {
                
                [appDelegate() showMBHUD:@"Please Wait..."];
            }
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            [PFCloud callFunctionInBackground:@"getIncomingFavrList"
                               withParameters:@{@"userId": userId}
                                        block:^(NSArray *results, NSError *error)
             {
                 NSLog(@"results %@", results);
                 if (results.count <= 0)
                 {
                     _lblWhenNoData.hidden = NO;
                     //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [appDelegate() dismissMBHUD];
                     [refresh endRefreshing];
                     NSLog(@"count 0 called");
                     [self.tableView reloadData];
                     [self showStatus:@"You have not received any favr" timeout:1];
                     return ;
                 }
                 incomingFavrListArray = [[NSMutableArray alloc] init];
                 if (results.count > 0)
                 {
                     _lblWhenNoData.hidden = YES;
                     NSLog(@"results %@", [results objectAtIndex:0]);
                     for (int i = 0; i < results.count; i++)
                     {
                         if ([[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"] intValue] >= 1)
                         {
                             tempIncomingFavrListArray = [[NSMutableArray alloc] init];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"favrTitle"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isGrpFavr"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeImage"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeName"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperName"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperImage"]];
                             [incomingFavrListArray addObject:tempIncomingFavrListArray];
                         }
                         
                     }
                     NSLog(@"incomming favr list array %@", incomingFavrListArray);
                     [appDelegate() dismissMBHUD];
                     [self.tableView reloadData];
                     
                 }
             }
             ];
        }
     
        
        
        
    }
    else
    {
        
        
        appDelegate().chatType = helper;
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgOutgoing];
        if (outgoingFavrListArray.count>0)
        {
            [appDelegate() showMBHUD:@"Please Wait..."];
            
            [refresh endRefreshing];
            // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [appDelegate() dismissMBHUD];
            [self.tableView reloadData];
            _lblWhenNoData.hidden = YES;
        }
        else
        {
            if (pullToRefreshBool == NO)
            {
                
                [appDelegate() showMBHUD:@"Please Wait..."];
            }
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            [PFCloud callFunctionInBackground:@"getOutgoingFavrList"
                               withParameters:@{@"userId": userId}
                                        block:^(NSArray *results, NSError *error)
             {
                 NSLog(@"results %@", results);
                 if (results.count <= 0)
                 {
                     _lblWhenNoData.hidden = NO;
                     //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [appDelegate() dismissMBHUD];
                     [refresh endRefreshing];
                     NSLog(@"count 0 called");
                     [self.tableView reloadData];
                     [self showStatus:@"You have not requested any favr" timeout:1];
                 }
                 outgoingFavrListArray = [[NSMutableArray alloc] init];
                 if (results.count > 0)
                 {
                     _lblWhenNoData.hidden = YES;
                     NSLog(@"results %@", [results objectAtIndex:0]);
                     for (int i = 0; i < results.count; i++)
                     {
                         tempOutgoingFavrListArray = [[NSMutableArray alloc] init];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"favrTitle"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isGrpFavr"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeImage"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeName"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperName"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperImage"]];
                         [outgoingFavrListArray addObject:tempOutgoingFavrListArray];
                     }
                     NSLog(@"outgoing favr list array %@", outgoingFavrListArray);
                     
                 }             [appDelegate() dismissMBHUD];
                               [self.tableView reloadData];
             }
             ];
            
        }
        
        
        
    }
    //    [self.tableView reloadData];
}


// segment control action method
-(IBAction)listIncomingOutgoing:(UISegmentedControl*)sender
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
    
    if (sender.selectedSegmentIndex==0)
    {
        
        if (incomingFavrUserArray.count>0) {
            appDelegate().chatType = helpee;
            _lblWhenNoData.hidden = YES;
            incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
             [self.tableView reloadData];
            return;
        }
    }
    else
    {
        if (outgoingFavrUserInfo.count>0) {
            appDelegate().chatType = helper;
            _lblWhenNoData.hidden = YES;
            incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgOutgoing];
             [self.tableView reloadData];
            return;
        }

    }
    
    
    
    if(sender.selectedSegmentIndex==0)
    {
        
        
        appDelegate().chatType = helpee;
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
        if (incomingFavrListArray.count>0)
        {
            _lblWhenNoData.hidden = YES;
            [appDelegate() showMBHUD:@"Please Wait..."];
            [self.tableView reloadData];
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [appDelegate() dismissMBHUD];
            [refresh endRefreshing];
        }
        else
        {
            if (pullToRefreshBool == NO)
            {
                
                [appDelegate() showMBHUD:@"Please Wait..."];
            }
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            [PFCloud callFunctionInBackground:@"getIncomingFavrList"
                               withParameters:@{@"userId": userId}
                                        block:^(NSArray *results, NSError *error)
             {
                 NSLog(@"results %@", results);
                 if (results.count <= 0)
                 {
                     _lblWhenNoData.hidden = NO;
                  //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [appDelegate() dismissMBHUD];
                     [refresh endRefreshing];
                     NSLog(@"count 0 called");
                     [self.tableView reloadData];
                     [self showStatus:@"You have not received any favr" timeout:1];
                     return ;
                 }
                 incomingFavrListArray = [[NSMutableArray alloc] init];
                 if (results.count > 0)
                 {
                     _lblWhenNoData.hidden = YES;
                     NSLog(@"results %@", [results objectAtIndex:0]);
                     for (int i = 0; i < results.count; i++)
                     {
                         if ([[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"] intValue] >= 1)
                         {
                             tempIncomingFavrListArray = [[NSMutableArray alloc] init];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"favrTitle"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isGrpFavr"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperId"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeImage"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeName"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperName"]];
                             [tempIncomingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperImage"]];
                             [incomingFavrListArray addObject:tempIncomingFavrListArray];
                         }
                         
                     }
                     NSLog(@"outgoing favr list array %@", incomingFavrListArray);
                     [appDelegate() dismissMBHUD];
                     [self.tableView reloadData];
                    
                 
                 }
             }
             ];
        }
        
        
        
    }
    else
    {
        
       
        appDelegate().chatType = helper;
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgOutgoing];
        if (outgoingFavrListArray.count>0)
        {
            [appDelegate() showMBHUD:@"Please Wait..."];

            [refresh endRefreshing];
           // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [appDelegate() dismissMBHUD];
            [self.tableView reloadData];
            _lblWhenNoData.hidden = YES;
        }
        else
        {
            if (pullToRefreshBool == NO)
            {
                
                [appDelegate() showMBHUD:@"Please Wait..."];
            }
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            [PFCloud callFunctionInBackground:@"getOutgoingFavrList"
                               withParameters:@{@"userId": userId}
                                        block:^(NSArray *results, NSError *error)
             {
                 NSLog(@"results %@", results);
                 if (results.count <= 0)
                 {
                     _lblWhenNoData.hidden = NO;
                     //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [appDelegate() dismissMBHUD];
                     [refresh endRefreshing];
                     NSLog(@"count 0 called");
                     [self.tableView reloadData];
                     [self showStatus:@"You have not requested any favr" timeout:1];
                 }
                 outgoingFavrListArray = [[NSMutableArray alloc] init];
                 if (results.count > 0)
                 {
                     _lblWhenNoData.hidden = YES;
                     NSLog(@"results %@", [results objectAtIndex:0]);
                     for (int i = 0; i < results.count; i++)
                     {
                         tempOutgoingFavrListArray = [[NSMutableArray alloc] init];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"favrTitle"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"objectId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isAcceptedByHelper"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"isGrpFavr"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeId"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeImage"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helpeeName"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperName"]];
                         [tempOutgoingFavrListArray addObject:[[results objectAtIndex:i] valueForKey:@"helperImage"]];
                         [outgoingFavrListArray addObject:tempOutgoingFavrListArray];
                     }
                     NSLog(@"outgoing favr list array %@", outgoingFavrListArray);
                     
                   }
                    [appDelegate() dismissMBHUD];
                    [self.tableView reloadData];
             }
             ];
            
        }
        
        
        
    }
//    [self.tableView reloadData];
}


- (void)showStatus:(NSString *)message timeout:(double)timeout
{
    incomingOutgoingAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    [incomingOutgoingAlert show];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerExpired:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)timerExpired:(NSTimer *)timer
{
    [incomingOutgoingAlert dismissWithClickedButtonIndex:0 animated:YES];
}



#pragma mark OtherMethod
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
                 
                 for (int i=0; i<appDelegate().getDialogs.count; i++)
                 {
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
    
    [appDelegate() showMBHUD:@"Please Wait..."];
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
            
            [appDelegate() dismissMBHUD];
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
            [appDelegate() dismissMBHUD];
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


-(void) chatScreen:(NSString*)strType
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
    
    if (favrInteger==1) {
        [appDelegate() showMBHUD:@"Please Wait..."];
        NSLog(@"self.user %@", self.users);
        NSLog(@"__________________________________%@",self.opponetChatUserId);
        userIdArray = [[NSMutableArray alloc]init];
        userGroupIdArray = [[NSMutableArray alloc]init];
        userSelectedArray = [[NSMutableArray alloc]init];
        userIdCount = 0;
        NSMutableArray *objectIdArray = [[NSMutableArray alloc]init];
        
        
        if ([strType isEqualToString:(NSString *)kMsgIncomming]) {
            
            [PFCloud callFunctionInBackground:@"getGroupDetail2"
                               withParameters:@{
                                                @"grpId": inCommingHelperID
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
            [PFCloud callFunctionInBackground:@"getGroupDetail2"
                               withParameters:@{
                                                @"grpId": outGoingHelperID
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
        
        
        
        
    }
    
    
    
    
    //    QBUUser *user = (QBUUser *)self.users[selectedIndex];
    //
    //    chattingVC.opponent = user;
    //    [[SlideNavigationController sharedInstance] pushViewController:chattingVC animated:YES];
}

// selected favr from editable tableview will show alertview to delete
- (IBAction)deleteButtonAction:(UIBarButtonItem *)sender
{
    
    NSLog(@"_testArray%@", self.dataArray);
    NSLog(@"tableView Editing %i", self.tableView.editing);
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (!self.tableView.editing)
    {
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            editingModeOn = NO;
            NSString *actionTitle = ([[self.tableView indexPathsForSelectedRows] count] == 1) ?
            @"Are you sure you want to remove this item?" : @"Are you sure you want to remove these items?";
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"OK" otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showInView:self.view];
        }
        else
        {
            editingModeOn = NO;
            [self.tableView reloadData];
        }
        //        editingModeOn = NO;
        //        [self.tableView reloadData];
    }
    else
    {
        editingModeOn = YES;
        [self.tableView reloadData];
    }

    
//    NSLog(@"tableView Editing %i", self.tableView.editing);
//    [self.tableView setEditing:!self.tableView.editing animated:YES];
//    if (!self.tableView.editing)
//    {
//        editingModeOn = NO;
//        [self.tableView reloadData];
//    }
//    else
//    {
//        editingModeOn = YES;
//        [self.tableView reloadData];
//    }
    
}
#pragma mark- UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
		// Delete what the user selected.
        //        selectedRows = [self.tableView indexPathsForSelectedRows];
        BOOL deleteSpecificRows = selectedRows.count > 0;
        if (deleteSpecificRows)
        {
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }
            // Delete the objects from our data model.
            
            k=0;
            
            if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
            {
                 [appDelegate() showMBHUD:@"Please Wait..."];
                for (NSIndexPath *selectedIndex in selectedRows)
                {
                    
                   
                    NSString *favrId = [[incomingFavrListArray objectAtIndex:selectedIndex.row] objectAtIndex:2];
                    [PFCloud callFunctionInBackground:@"delete2"
                                       withParameters:@{@"favrId": favrId}
                                                block:^(NSString *results, NSError *error) {
                                                    if ([results intValue])
                                                    {
                                                        
                                                        if (k==selectedRows.count-1) {
                                                            [appDelegate() dismissMBHUD];
                                                            [self get_vrns];
                                                        }
                                                        
                                                        k++;
                                                    }
                                                }];
                    
                }
                
                //                [incomingFavrListArray removeObject]
                //                [incomingFavrListArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            }
            else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
            {
                 [appDelegate() showMBHUD:@"Please Wait..."];
                for (NSIndexPath *selectedIndex in selectedRows)
                {
                    NSString *favrId = [[outgoingFavrListArray objectAtIndex:selectedIndex.row] objectAtIndex:2];
                    [PFCloud callFunctionInBackground:@"delete2"
                                       withParameters:@{@"favrId": favrId}
                                                block:^(NSString *results, NSError *error) {
                                                    if ([results intValue])
                                                    {
                                                        if (k==selectedRows.count-1) {
                                                            [appDelegate() dismissMBHUD];
                                                            [self get_vrns];
                                                        }
                                                        
                                                        k++;
                                                    }
                                                }];
                    
                }
                //                [outgoingFavrListArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            }
            //            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            
            // Tell the tableView that we deleted the objects
            //            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            //            selectedRows = nil;
            
        }
        else
        {
            // Delete everything, delete the objects from our data model.
            //            [self.dataArray removeAllObjects];
            
            [self.dataArray removeObjectAtIndex:rowNumber];
            NSLog(@"seld.dataArray %@", self.dataArray);
            
            // Tell the tableView that we deleted the objects.
            // Because we are deleting all the rows, just reload the current table section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
        
        
        // Exit editing mode after the deletion.
        [self.tableView setEditing:NO animated:YES];
        [self.tableView reloadData];
        //        [self updateButtonsToMatchTableState];
	}
}

// newFavrAct is a popup view on top right of contact, pending and favr screen
- (IBAction)newFavrAct:(UIBarButtonItem *)sender  forEvent:(UIEvent*)event
{
    
    //    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    //    tableViewController.view.frame = CGRectMake(0,0, 100, 200);
    
    
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
//{
////    ChatUserListVC *chatUserListVC = [[ChatUserListVC alloc] initWithNibName:@"ChatUserListVC" bundle:nil];
////    [self.navigationController pushViewController:chatUserListVC animated:YES];
////    CreateFavrVC *createFavr = [[CreateFavrVC alloc] init];
////    [self.navigationController pushViewController:createFavr animated:YES];
//}



// single, multiple, and group favr selected
// appDeleate.groupSelected use to distinguish whether favr is single, multiple and group
-(void) singleFavrSelectBtnAction: (UIButton *)sender
{
    
    
    
    
    if (sender.tag==1) {
        
        if (appDelegate().contactStatus==isContactAddedNo) {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have no contact added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
            [popoverController dismissPopoverAnimatd:YES];
            return;
            
        }
        
        
    }
    else if (sender.tag==2){
        
        if ( appDelegate().contactStatus==isContactAddedNo) {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You have no contact added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
            [popoverController dismissPopoverAnimatd:YES];
            return;
        }
        
    }
    else if (sender.tag==3){
        if (appDelegate().groupStatus==isGroupAddedNo) {
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

// favrInfo button Action
// favrInfoVC.pendingFavrStatus = 2;
-(IBAction)favrInfoBtnAct:(UIButton *)sender
{
    if ([incomming_Outgoing isEqualToString:(NSString *)kMsgIncomming])
    {
        FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
        favrInfoVC.favrId = [[incomingFavrListArray objectAtIndex:sender.tag] objectAtIndex:2];
        favrInfoVC.navigationTitle = [[incomingFavrUserArray objectAtIndex:sender.tag] objectAtIndex:0];
        favrInfoVC.incoming_outgoingString = (NSString *)kMsgIncomming;
        favrInfoVC.pendingFavrStatus = 2;
        favrInfoVC.strGetTabText = @"favr";
        [self.navigationController pushViewController:favrInfoVC animated:YES];
    }
    else if ([incomming_Outgoing isEqualToString:(NSString *)kMsgOutgoing])
    {
        FavrInfoVC *favrInfoVC = [[FavrInfoVC alloc] init];
        favrInfoVC.favrId = [[outgoingFavrListArray objectAtIndex:sender.tag - 1000] objectAtIndex:2];
        favrInfoVC.navigationTitle = [[outgoingFavrUserInfo objectAtIndex:sender.tag - 1000] objectAtIndex:0];
        favrInfoVC.incoming_outgoingString = (NSString *)kMsgOutgoing;
        favrInfoVC.pendingFavrStatus = 2;
        favrInfoVC.strGetTabText = @"favr";
        [self.navigationController pushViewController:favrInfoVC animated:YES];
    }
    
}

@end
