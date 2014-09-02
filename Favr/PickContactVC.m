
//
//  PickContactVC.m
//  Favr
//
//  Created by Ankush on 01/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "PickContactVC.h"

@interface PickContactVC ()

//@property (nonatomic, strong) IBOutlet UIBarButtonItem *editButton;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *cancelButton;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *addButton;

@end

@implementation PickContactVC

@synthesize whenString, privicyString;
@synthesize quidProString;

static NSString const *kContact = @"Contact";
static NSString const *kGroup = @"Group";

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
    
    
    NSLog(@"when = %@, privicy = %@, quidPro = %@", whenString, privicyString, quidProString);
    
    contact_Group = [NSString stringWithFormat:@"%@", (NSString *)kContact];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"appDelegate.groupSelected%i", appDelegate.groupSelected);
    
    if (appDelegate.groupSelected == 3)
    {
        self.segmentControl.selectedSegmentIndex = 1;
        contact_Group = [NSString stringWithFormat:@"%@", (NSString *)kGroup];
    }
    else if (appDelegate.groupSelected == 2)
    {
        [self.tableView setEditing:YES animated:YES];
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    
    
    /*
     This option is also selected in the storyboard. Usually it is better to configure a table view in a xib/storyboard, but we're redundantly configuring this in code to demonstrate how to do that.
     */
    
    
    // populate the data array with some example objects
    self.contactDataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"contactDetails"]];
    self.groupDataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"groupDetails"]];
//    NSString *itemFormatString = NSLocalizedString(@"Item %d", @"Format string for item");
//    for (unsigned int itemNumber = 1; itemNumber <= 8; itemNumber++)
//    {
//        NSString *itemName = [NSString stringWithFormat:itemFormatString, itemNumber];
//        [self.dataArray addObject:itemName];
//    }
    
    // make our view consistent
    
    
    NSLog(@"_____________________%@",self.contactDataArray);
    NSString *userID=  [[NSUserDefaults standardUserDefaults] valueForKey: @"userId"];
    
    NSLog(@"_________________%@",(NSMutableArray*)[self.contactDataArray objectAtIndex:0]);
    
    
    for (int i=0; i<self.contactDataArray.count; i++) {
        
        if ([[(NSMutableArray*)[self.contactDataArray objectAtIndex:i] objectAtIndex:3]isEqualToString:userID]) {
            
            
            helpeeName =[(NSMutableArray*)[self.contactDataArray objectAtIndex:i] objectAtIndex:0];
            helpeeImage=[(NSMutableArray*)[self.contactDataArray objectAtIndex:i] objectAtIndex:2];
            
            [self.contactDataArray removeObjectAtIndex:i];
            
        }
        
    }
    
    
    NSLog(@"_____________________%@",self.contactDataArray);
    
    
    [self updateButtonsToMatchTableState];
    
    [self contactGroupSegmentControl:self.segmentControl];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    addedFavrListArray = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([contact_Group isEqualToString:(NSString *)kContact])
    {
        return self.contactDataArray.count;
    }
    else if ([contact_Group isEqualToString:(NSString *)kGroup])
    {
        return self.groupDataArray.count;
    }
	return 0;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate] ;
    
    if (appDelegate.groupSelected == 1 || appDelegate.groupSelected == 3)
    {
        selectedIndex = indexPath.row;
        [tableView reloadData];
    }
    else
    {
        [self updateButtonsToMatchTableState];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure a cell to show the corresponding string from the array.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString *kCellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    if ([contact_Group isEqualToString:(NSString *)kContact])
    {
//        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//        cell.accessoryView.frame = CGRectMake(5.0, 5.0, 5.0, 5.0);
        //    cell.accessoryType
//        cell.textLabel.text = [[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//        cell.imageView.layer.cornerRadius = 30.0f;
//        cell.imageView.layer.masksToBounds=YES;
        
        
        ////*********Add Profile image*********
        UIImageView *_imgViewProfileImage  =[[UIImageView alloc]initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
        _imgViewProfileImage.backgroundColor = [UIColor clearColor];
        [_imgViewProfileImage sd_setImageWithURL:[NSURL URLWithString:[[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        _imgViewProfileImage.layer.cornerRadius = 50/2;
        _imgViewProfileImage.layer.masksToBounds=YES;
        [cell.contentView addSubview:_imgViewProfileImage];
        
        
        ////*********Add User Name*********
        UILabel *_lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(_imgViewProfileImage.frame.origin.x+_imgViewProfileImage.frame.size.width+10, 10.0, 200.0, 30.0)];
        _lblUserName.backgroundColor = [UIColor clearColor];
        _lblUserName.textAlignment = NSTextAlignmentLeft;
        _lblUserName.textColor = [UIColor blackColor];
        _lblUserName.text =[[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
        [cell.contentView addSubview:_lblUserName];
        
        
        
        ////*********Add Divider*********
        UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 59.0f, tableView.frame.size.width, 0.7f)];
        _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
        _imgViewDivider.alpha = 2.0;
        [cell.contentView addSubview:_imgViewDivider];
        
        
        if (appDelegate.groupSelected == 1)
        {
            if(indexPath.row == selectedIndex)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        //	cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    }
    else if ([contact_Group isEqualToString:(NSString *)kGroup])
    {
//        cell.textLabel.text = [[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpName"];
//        cell.imageView.layer.cornerRadius = 30.0f;
//        cell.imageView.layer.masksToBounds=YES;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpImage"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
//        cell.detailTextLabel.text = [[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpDescription"];
        
        
        
        
        ////*********Add Profile image*********
        UIImageView *_imgViewProfileImage  =[[UIImageView alloc]initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
        _imgViewProfileImage.backgroundColor = [UIColor clearColor];
        [_imgViewProfileImage sd_setImageWithURL:[NSURL URLWithString:[[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpImage"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        _imgViewProfileImage.layer.cornerRadius = 50/2;
        _imgViewProfileImage.layer.masksToBounds=YES;
        [cell.contentView addSubview:_imgViewProfileImage];
        
        
        ////*********Add User Name*********
        UILabel *_lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(_imgViewProfileImage.frame.origin.x+_imgViewProfileImage.frame.size.width+10, 10.0, 200.0, 30.0)];
        _lblUserName.backgroundColor = [UIColor clearColor];
        _lblUserName.textAlignment = NSTextAlignmentLeft;
        _lblUserName.textColor = [UIColor blackColor];
        _lblUserName.text =[[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpName"];
        [cell.contentView addSubview:_lblUserName];

        
        
        
        ////*********Add Divider*********
        UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 59.0f, tableView.frame.size.width, 0.7f)];
        _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
        _imgViewDivider.alpha = 2.0;
        [cell.contentView addSubview:_imgViewDivider];
        if(indexPath.row == selectedIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
   
    
    
    
	return cell;
}


- (void)reloadVisibleCells
{
    [self.tableView beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [indexPaths addObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}


#pragma mark - Action methods

- (IBAction)editAction:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)cancelAction:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

// after selection of contact it is called as done button
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// The user tapped one of the OK/Cancel buttons.
	if (buttonIndex == 0)
	{
		// Delete what the user selected.
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
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
            
            [addedFavrListArray addObject:[self.contactDataArray objectsAtIndexes:indicesOfItemsToDelete]];
            [self.contactDataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            
            NSLog(@"addFavrListArray %@", addedFavrListArray);
            
            
            // Tell the tableView that we deleted the objects
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            // Delete everything, delete the objects from our data model.
            [self.contactDataArray removeAllObjects];
            
            // Tell the tableView that we deleted the objects.
            // Because we are deleting all the rows, just reload the current table section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // Exit editing mode after the deletion.
        [self.tableView setEditing:NO animated:YES];
        [self updateButtonsToMatchTableState];
	}
}

- (IBAction)deleteAction:(id)sender
{
    // Open a dialog with just an OK button.
	NSString *actionTitle;
    if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
    }
    else
    {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
    }
    
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
    NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];
    
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    // Show from our table view (pops up in the middle of the table).
	[actionSheet showInView:self.view];
}

- (IBAction)addAction:(id)sender
{
    // Tell the tableView we're going to add (or remove) items.
    [self.tableView beginUpdates];
    
    // Add an item to the array.
    [self.contactDataArray addObject:@"New Item"];
    
    // Tell the tableView about the item that was added.
    NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:(self.contactDataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPathOfNewItem]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Tell the tableView we have finished adding or removing items.
    [self.tableView endUpdates];
    
    // Scroll the tableView so the new item is visible
    [self.tableView scrollToRowAtIndexPath:indexPathOfNewItem
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
    
    // Update the buttons if we need to.
    [self updateButtonsToMatchTableState];
}


#pragma mark - Other Methods

- (IBAction)backBtnAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) showAlert :(NSString *)title :(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (IBAction)doneBtnAct:(UIBarButtonItem *)sender
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
    
    if ([contact_Group isEqualToString:(NSString *)kContact])
    {
        if (self.contactDataArray.count==0) {
            
            UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please add contacts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alert show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }

    }
    else if ([contact_Group isEqualToString:(NSString *)kGroup])
    {
        
        if (self.groupDataArray.count==0) {
            
            UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please create group." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alert show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }

    }

    
    
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
        }
        
        singleUser = @"0";
        multiUser = @"1";
        groupUser = @"0";
        
        
        // Delete the objects from our data model.
        
        [addedFavrListArray addObject:[self.contactDataArray objectsAtIndexes:indicesOfItemsToDelete]];
//        [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
        
        NSLog(@"addFavrListArray %@", addedFavrListArray );
        NSLog(@"[addedFavrListArray objectAtIndex:0] %@", [addedFavrListArray objectAtIndex:0]);
        NSLog(@"[[addedFavrListArray objectAtIndex:0] objectAtIndex:0] %@", [[addedFavrListArray objectAtIndex:0] objectAtIndex:0]);
        NSLog(@"userId %@", [[[addedFavrListArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:3]);
        
        NSDate *date = [NSDate date];
        NSString *dateString = [[NSString alloc] initWithFormat:@"%@", date];
        NSLog(@"date string %@", dateString);
        
        
        
        NSString *helperId = [[[addedFavrListArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:3];
        NSString *helpeeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        NSMutableArray *helperIdArray =[[NSMutableArray alloc] init];
        NSMutableArray *helperNameArray =[[NSMutableArray alloc] init];
        NSMutableArray *helperImageArray =[[NSMutableArray alloc] init];
        for (int i = 0;  i < [[addedFavrListArray objectAtIndex:0] count];  i++)
        {
            [helperIdArray addObject:[[[addedFavrListArray objectAtIndex:0] objectAtIndex:i] objectAtIndex:3]];
            [helperNameArray addObject:[[[addedFavrListArray objectAtIndex:0] objectAtIndex:i] objectAtIndex:0]];
            [helperImageArray addObject:[[[addedFavrListArray objectAtIndex:0] objectAtIndex:i] objectAtIndex:2]];
        }
        
        
        if (helperIdArray.count < 1)
        {
            [self showAlert:@"Message":@"Please pick contact first"];
            return ;
        }
        
        if (appDelegate().editType ==editYes) {
            
            NSString *favrId = [[NSUserDefaults standardUserDefaults]objectForKey:@"favrId"];
            [PFCloud callFunctionInBackground:@"delete2"
                               withParameters:@{@"favrId": favrId}
                                        block:^(NSString *results, NSError *error) {
                                            if ([results intValue])
                                            {
                                            }
                                        }];

        }
        
        
        
      
        [appDelegate() showMBHUD:@"Please Wait..."];
        
        
        NSLog(@"helperId = %@, favrTitleString = %@, favrDescriptionString = %@, helpeeId = %@", helperId, self.favrTitleString, self.favrDescriptionString, helpeeId);
        [PFCloud callFunctionInBackground:@"createFavr"
                           withParameters:@{
                                            @"helpeeId" : helpeeId,
                                            @"favrTitle" : self.favrTitleString,
                                            @"favrDescription" : self.favrDescriptionString,
                                            @"helper" : helperIdArray,
                                            @"singleFavr" : singleUser,
                                            @"multicastFavr" : multiUser,
                                            @"grpFavr" : groupUser,
                                            @"when": whenString,
                                            @"isForwardable":privicyString,
                                            @"quidPro": quidProString,
                                            @"helpeeImage": helpeeImage,
                                            @"helpeeName": helpeeName,
                                            @"helperImage":helperImageArray,
                                            @"helperName":helperNameArray
                                            }
                                    block:^(NSString *results, NSError *error) {
                                        
                                        [appDelegate() dismissMBHUD];
                                        [self showStatus:@"Favr Created Successfully" timeout:5];
                                        appDelegate().updatePendingOutGoing = updateYes;
//                                        if (!error) {
//                                            NSLog(@"result: %@",results);
//                                            
//                                            if([results isEqualToString:@"You are not registered with us, try SignUp!"])
//                                            {
//                                                [hud hide:YES];
////                                                [self showAlertWithText:@"Favr" :results];
//                                            }
//                                            else if([results isEqualToString:@"Username/Password doesnt match !"])
//                                            {
//                                                [hud hide:YES];
////                                                [self showAlertWithText:@"Favr" :results];
//                                            }
//                                            else{
////                                                [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"loggedInUserPassword"];
////                                                [[NSUserDefaults standardUserDefaults] setObject:self.txtEmailId.text forKey:@"loggedInUserEmail"];
////                                                [[NSUserDefaults standardUserDefaults] setObject:results forKey:@"userId"];
////                                                [[NSUserDefaults standardUserDefaults]synchronize];
////                                                [self performSegueWithIdentifier:@"loginToLandingSague"  sender:nil];
//                                                
//                                            }
//                                        }
                                    }];

        
        // Tell the tableView that we deleted the objects
//        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        
        
        NSString *helperId;// = [[addedFavrListArray objectAtIndex:0] objectAtIndex:3];
        NSString *helperImage;
        NSString *helperName;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.groupSelected == 1)
        {
            if (self.contactDataArray.count < 1)
            {
                [self showAlert:@"Message":@"Please add contacts first"];
                return ;
            }
            [addedFavrListArray addObject:[self.contactDataArray objectAtIndex:selectedIndex]];
            singleUser = @"1";
            multiUser = @"0";
            groupUser = @"0";
            helperId = [[addedFavrListArray objectAtIndex:0] objectAtIndex:3];
            helperImage =[[addedFavrListArray objectAtIndex:0] objectAtIndex:2];
            helperName =[[addedFavrListArray objectAtIndex:0] objectAtIndex:0];
        }
        else if (appDelegate.groupSelected == 3)
        {
            if (self.contactDataArray.count < 1)
            {
                [self showAlert:@"Message":@"Please add group first"];
                return ;
            }
            singleUser = @"0";
            multiUser = @"0";
            groupUser = @"1";
            [addedFavrListArray addObject:[self.groupDataArray objectAtIndex:selectedIndex]];
            helperId = [[addedFavrListArray objectAtIndex:0] valueForKey:@"objectId"];
            helperImage =[[addedFavrListArray objectAtIndex:0] valueForKey:@"grpImage"];
            helperName =[[addedFavrListArray objectAtIndex:0] valueForKey:@"grpName"];
        }
        
        
        //        [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
        
//        NSLog(@"addFavrListArray %@", addedFavrListArray );
//        NSLog(@"[addedFavrListArray objectAtIndex:0] %@", [addedFavrListArray objectAtIndex:0]);
//        NSLog(@"[[addedFavrListArray objectAtIndex:0] objectAtIndex:0] %@", [[addedFavrListArray objectAtIndex:0] objectAtIndex:0]);
//        NSLog(@"userId %@", [[addedFavrListArray objectAtIndex:0] objectAtIndex:3]);
        
        NSDate *date = [NSDate date];
        NSString *dateString = [[NSString alloc] initWithFormat:@"%@", date];
        NSLog(@"date string %@", dateString);
        
        
        if (helperId.length < 1)
        {
            [self showAlert:@"Message":@"Please pick contact first"];
            return ;
        }
        
        NSArray *helperNamearray =[NSArray arrayWithObject:helperName];
        NSArray *helperImagearray =[NSArray arrayWithObject:helperImage];
       
        NSArray *helperIdArray = [NSArray arrayWithObject:helperId];
        NSString *helpeeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        
        
        if (appDelegate.editType ==editYes) {
            
            NSString *favrId = [[NSUserDefaults standardUserDefaults]objectForKey:@"favrId"];
            [PFCloud callFunctionInBackground:@"delete2"
                               withParameters:@{@"favrId": favrId}
                                        block:^(NSString *results, NSError *error) {
                                            if ([results intValue])
                                            {
                                            }
                                        }];
            
        }
        
       
        [appDelegate showMBHUD:@"Please Wait..."];
        
        
        NSLog(@"helperId = %@, favrTitleString = %@, favrDescriptionString = %@, helpeeId = %@", helperId, self.favrTitleString, self.favrDescriptionString, helpeeId);
        [PFCloud callFunctionInBackground:@"createFavr"
                           withParameters:@{
                                            @"helpeeId": helpeeId,
                                            @"favrTitle": self.favrTitleString,
                                            @"favrDescription":self.favrDescriptionString,
                                            @"helper": helperIdArray,
                                            @"singleFavr" : singleUser,
                                            @"multicastFavr" : multiUser,
                                            @"grpFavr" : groupUser,
                                            @"when": whenString,
                                            @"isForwardable":privicyString,
                                            @"quidPro": quidProString,
                                            @"helpeeImage": helpeeImage,
                                            @"helpeeName": helpeeName,
                                            @"helperImage":helperImagearray,
                                            @"helperName":helperNamearray
                                            }
                                    block:^(NSString *results, NSError *error) {
                                        
                                        if ([results integerValue]==0) {
                                            
                                        }
                                        else{
                                            [appDelegate dismissMBHUD];
                                            [self showStatus:@"Favr Created Successfully" timeout:5];
                                            appDelegate.updatePendingOutGoing = updateYes;
                                        }
                                       
                                    
        }];
        
        
        // Delete everything, delete the objects from our data model.
//        [self.dataArray removeAllObjects];
//        
//        // Tell the tableView that we deleted the objects.
//        // Because we are deleting all the rows, just reload the current table section
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // Exit editing mode after the deletion.
//    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];

//    NSString *actionTitle;
//    if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
//        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
//    }
//    else
//    {
//        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
//    }
//    
//    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
//    NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
//                                                             delegate:self
//                                                    cancelButtonTitle:cancelTitle
//                                               destructiveButtonTitle:okTitle
//                                                    otherButtonTitles:nil];
//    
//	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    
//    // Show from our table view (pops up in the middle of the table).
//	[actionSheet showInView:self.view];
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
    [self.navigationController popToViewController:[array objectAtIndex:array.count-4] animated:YES];
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        //Do not forget to import AnOldViewController.h
//        if ([controller isKindOfClass:[PendingFavrVC class]]) {
//            
//            [self.navigationController popToViewController:controller
//                                                  animated:YES];
//            break;
//        }
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)contactGroupSegmentControl:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex==0)
    {
        contact_Group =[NSString stringWithFormat:@"%@",kContact];
    }
    else{
        contact_Group =[NSString stringWithFormat:@"%@",kGroup];
        if ([self.groupDataArray count] <=0)
        {
            self.groupDataArray = [[NSMutableArray alloc] init];
            userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            [PFCloud callFunctionInBackground:@"getGroupForUser"
                               withParameters:@{
                                                @"userId": userId
                                                }
                                        block:^(NSArray *results, NSError *error)
             {
                 groupIDArray = [[NSMutableArray alloc] init];
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
                      temproryGroupDetailsArray = [[NSMutableArray alloc] init];
                      
                      for (int i = 0; i< results.count; i++)
                      {
                          [temproryGroupDetailsArray addObject:[results objectAtIndex:i]];
                          NSMutableDictionary *groupDetailsDict = [[NSMutableDictionary alloc] init];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"objectId"] forKey:@"objectId"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpAdmin"] forKey:@"grpAdmin"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpDescription"] forKey:@"grpDescription"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpImage"] forKey:@"grpImage"];
                          [groupDetailsDict setObject:[[results objectAtIndex:i] valueForKey:@"grpName"] forKey:@"grpName"];
                          [self.groupDataArray addObject:groupDetailsDict];
                      }
                      //                                        [groupDetailsArray removeAllObjects];
                      //                                        groupDetailsArray = [[NSArray alloc] initWithArray:temproryGroupDetailsArray];
                      NSLog(@"results array %@", results);
                      [[NSUserDefaults standardUserDefaults] setObject:self.groupDataArray forKey:@"groupDetails"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      [self.tableView reloadData];
//                      for (int i = 0; i< results.count; i++)
//                      {
//                          [temproryGroupDetailsArray addObject:[results objectAtIndex:i]];
//                          
//                      }
//                      //                                        [groupDetailsArray removeAllObjects];
//                      self.groupDataArray = [[NSArray alloc] initWithArray:temproryGroupDetailsArray];
//                      NSLog(@"results array %@", results);
//                      //                                        [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"groupDetails"];
//                      //                                        [[NSUserDefaults standardUserDefaults] setObject:groupDetailsArray forKey:@"contact1Details"];
//                      [self.tableView reloadData];
                  }
                  ];
                 
             }
             ];

        }
        else
        {
            [self.tableView reloadData];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
//    if (self.tableView.editing)
//    {
//        // Show the option to cancel the edit.
//        self.navigationItem.rightBarButtonItem = self.cancelButton;
//
//        [self updateDeleteButtonTitle];
//        
//        // Show the delete button.
//        self.navigationItem.leftBarButtonItem = self.deleteButton;
//    }
//    else
//    {
//        // Not in editing mode.
//        self.navigationItem.leftBarButtonItem = self.addButton;
//        
//        // Show the edit button, but disable the edit button if there's nothing to edit.
//        if (self.dataArray.count > 0)
//        {
//            self.editButton.enabled = YES;
//        }
//        else
//        {
//            self.editButton.enabled = NO;
//        }
//        self.navigationItem.rightBarButtonItem = self.editButton;
//    }
}

- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.contactDataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
//        self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
    }
    else
    {
        NSString *titleFormatString =
        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
//        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    contactListArray = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"contactDetails"]];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [contactListArray count];
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *cellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    cell.textLabel.text = [[contactListArray objectAtIndex:indexPath.row] objectAtIndex:0];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[contactListArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//    cell.imageView.layer.cornerRadius = 27.0f;
//    cell.imageView.layer.masksToBounds=YES;
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)backBtnAct:(UIBarButtonItem *)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
