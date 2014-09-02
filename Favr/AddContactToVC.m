//
//  AddContactToVC.m
//  Favr
//
//  Created by Ankush on 25/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "AddContactToVC.h"

@interface AddContactToVC ()

@end

@implementation AddContactToVC
@synthesize contactDataArray;

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
    
    contactListArray = [[NSMutableArray alloc] init];
    self.contactDataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"contactDetails"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactDataArray.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
//    [self updateDeleteButtonTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate] ;
//    
//    if (appDelegate.groupSelected == 1 || appDelegate.groupSelected == 3)
//    {
        selectedIndex = indexPath.row;
        [tableView reloadData];
//    }
//    else
//    {
////        [self updateButtonsToMatchTableState];
//    }
    
    
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
        
        ////*********Add Profile image*********
        UIImageView *_imgViewProfileImage  =[[UIImageView alloc]initWithFrame:CGRectMake(3.0, 9.0, 40.0, 40.0)];
        _imgViewProfileImage.backgroundColor = [UIColor clearColor];
        [_imgViewProfileImage sd_setImageWithURL:[NSURL URLWithString:[[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
        _imgViewProfileImage.layer.cornerRadius = 40/2;
        _imgViewProfileImage.layer.masksToBounds=YES;
        [cell.contentView addSubview:_imgViewProfileImage];
        
        
        ////*********Add User Name*********
        UILabel *_lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(_imgViewProfileImage.frame.origin.x+_imgViewProfileImage.frame.size.width+10, 15.0, 200.0, 30.0)];
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
        
        
        
    }
    
//    if ([contact_Group isEqualToString:(NSString *)kContact])
//    {
        //        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        //        cell.accessoryView.frame = CGRectMake(5.0, 5.0, 5.0, 5.0);
        //    cell.accessoryType
//        cell.textLabel.text = [[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:0];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.contactDataArray objectAtIndex:indexPath.row] objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//        cell.imageView.layer.cornerRadius = 27.0f;
//        cell.imageView.layer.masksToBounds=YES;
    
        
//        if (appDelegate.groupSelected == 1)
//        {
            if(indexPath.row == selectedIndex)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
//        }
    
        //	cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
//    }
//    else if ([contact_Group isEqualToString:(NSString *)kGroup])
//    {
//        cell.textLabel.text = [[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpName"];
//        cell.imageView.layer.cornerRadius = 24.0f;
//        cell.imageView.layer.masksToBounds=YES;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpImage"]] placeholderImage:[UIImage imageNamed:@"profileImage.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
//        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
//        cell.detailTextLabel.text = [[self.groupDataArray objectAtIndex:indexPath.row] valueForKey:@"grpDescription"];
//        
//        
//        if(indexPath.row == selectedIndex)
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        
//    }

    
    
    
	return cell;
}

#pragma mark OtherMethod
// navigates to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneBtnAct:(UIBarButtonItem *)sender
{
    
    [contactListArray addObject:[self.contactDataArray objectAtIndex:selectedIndex]];
    helperId = [[contactListArray objectAtIndex:0] objectAtIndex:3];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.addContactUserId = helperId;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
