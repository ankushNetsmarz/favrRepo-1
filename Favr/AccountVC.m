//
//  AccountVC.m
//  Favr
//
//  Created by Ankush on 24/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "AccountVC.h"
#import "AddressBookUI/AddressBookUI.h"
@interface AccountVC ()

@end

@implementation AccountVC


#pragma mark - ViewLife Cycle
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
    reciprocationTitleEarned = [[NSArray alloc] initWithObjects:@"Good Karma", @"Cash", @"Gift Cards", @"Drinks", nil];
    reciprocationTitleOwed = [[NSArray alloc] initWithObjects:@"Good Karma", @"Cash", @"Gift Cards", @"Drinks", nil];
    combinedTitleReciprocation = [[NSArray alloc] initWithObjects:reciprocationTitleEarned, reciprocationTitleOwed, nil];
    
    reciprocationStatusEarned = [[NSArray alloc] initWithObjects:@"0", @"$0", @"$0", @"0", nil];
    reciprocationStatusOwed = [[NSArray alloc] initWithObjects:@"0", @"$0", @"$0", @"0", nil];
    combinedStatusReciprocation = [[NSArray alloc] initWithObjects:reciprocationStatusEarned, reciprocationStatusOwed, nil];
    
    _tableView.separatorColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1];
    
}




//+(NSArray *)getAllContacts
//{
//    
//    CFErrorRef *error = nil;
//    
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//    
//    __block BOOL accessGranted = NO;
//    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//            accessGranted = granted;
//            dispatch_semaphore_signal(sema);
//        });
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        
//    }
//    else { // we're on iOS 5 or older
//        accessGranted = YES;
//    }
//    
//    if (accessGranted) {
//        
//#ifdef DEBUG
//        NSLog(@"Fetching contact info ----> ");
//#endif
//        
//        
//        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
//        
//        
//        for (int i = 0; i < nPeople; i++)
//        {
//            ContactsData *contacts = [ContactsData new];
//            
//            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
//            
//            //get First Name and Last Name
//            
//            @try {
//                if(!(ABRecordCopyValue(person, kABPersonFirstNameProperty)== NULL)){
//                    NSString* fName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonFirstNameProperty)];
//                    contacts.firstNames = fName;
//                }
//                
//                NSString* lName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonLastNameProperty)];
//                contacts.lastNames =  lName;
//            }
//            @catch (NSException *exception) {
//                NSLog(@"error is: %@", exception);
//            }
//            @finally {
//                
//            }
//            
//            
//            if (!contacts.firstNames) {
//                contacts.firstNames = @"";
//            }
//            if (!contacts.lastNames) {
//                contacts.lastNames = @"";
//            }
//            
//            // get contacts picture, if pic doesn't exists, show standart one
//            
//            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
//            contacts.image = [UIImage imageWithData:imgData];
//            if (!contacts.image) {
//                contacts.image = [UIImage imageNamed:@"NOIMG.png"];
//            }
//            //get Phone Numbers
//            
//            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
//            
//            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
//            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
//                
//                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
//                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
//                [phoneNumbers addObject:phoneNumber];
//                
//                //NSLog(@"All numbers %@", phoneNumbers);
//                
//            }
//            
//            
//            [contacts setNumbers:phoneNumbers];
//            
//            //get Contact email
//            
//            NSMutableArray *contactEmails = [NSMutableArray new];
//            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
//            
//            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
//                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
//                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
//                
//                [contactEmails addObject:contactEmail];
//                // NSLog(@"All emails are:%@", contactEmails);
//                
//            }
//            
//            [contacts setEmails:contactEmails];
//            
//            
//            
//            [items addObject:contacts];
//            
//#ifdef DEBUG
//            //NSLog(@"Person is: %@", contacts.firstNames);
//            //NSLog(@"Phones are: %@", contacts.numbers);
//            //NSLog(@"Email is:%@", contacts.emails);
//#endif
//            
//            
//            
//            
//        }
//        return items;
//        
//        
//        
//    } else {
//#ifdef DEBUG
//        NSLog(@"Cannot fetch Contacts :( ");
//#endif
//        return NO;
//        
//        
//    }
//    
//}
//
//-(void)getContacts{
//    if ([self isABAddressBookCreateWithOptionsAvailable]) {
//        CFErrorRef error = nil; // no asterisk
//        ABAddressBookRef addressBook =
//        ABAddressBookCreateWithOptions(NULL, &error); // indirection
//        if (!addressBook) // test the result, not the error
//        {
//            NSLog(@"ERROR!!!");
//            return; // bail
//        }
//        CFArrayRef arrayOfPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//        NSLog(@"%@", arrayOfPeople); // let's see how we did}
//    }
//}
//-(BOOL)isABAddressBookCreateWithOptionsAvailable {
//    return &ABAddressBookCreateWithOptions != NULL;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *headerTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [headerTitleView setBackgroundColor:[ UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1]];
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 44)];
    sectionTitleLabel.textColor = [UIColor whiteColor];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
//    sectionTitleLabel.textAlignment = UITextAlignmentCenter;
    if (section == 0)
    {
        sectionTitleLabel.text = @"Reciprocation Earned" ;
    }
    else if (section == 1)
    {
        sectionTitleLabel.text = @"Reciprocation Owned" ;
    }
//    sectionTitleLabel.text = @"A";
    sectionTitleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    [sectionTitleLabel setAdjustsFontSizeToFitWidth:YES];
    [headerTitleView addSubview:sectionTitleLabel];
    return headerTitleView;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Reciprocation Earned" ;
    }
    else if (section == 1)
    {
        return @"Reciprocation Owned" ;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [combinedTitleReciprocation count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    AccountVCCell *cell = (AccountVCCell *)[ tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
//        cell = [[AccountVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountVCCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row % 4 == 0)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"check-icon"]];
        [cell.statusImageView setBackgroundColor:[UIColor blueColor]];
        cell.titleLabel.textColor = [UIColor blueColor];
    }
    else if (indexPath.row % 4 == 1)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"cash-icon"]];
        [cell.statusImageView setBackgroundColor:[UIColor greenColor]];
        cell.titleLabel.textColor = [UIColor greenColor];
    }
    else if (indexPath.row % 4 == 2)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"gift-icon"]];
        [cell.statusImageView setBackgroundColor:[UIColor orangeColor]];
        cell.titleLabel.textColor = [UIColor orangeColor];
    }
    else if (indexPath.row % 4 == 3)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"drink-icon"]];
        [cell.statusImageView setBackgroundColor:[UIColor redColor]];
        cell.titleLabel.textColor = [UIColor redColor];
    }
    
    cell.statusImageView.layer.cornerRadius = 12.0f;
    cell.statusImageView.layer.masksToBounds=YES;
    
    cell.titleLabel.text = [[combinedTitleReciprocation objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.statusBtn setTitle:[[combinedStatusReciprocation objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
    ////*********Add Divider*********
    UIImageView *_imgViewDivider = [[UIImageView alloc]initWithFrame:CGRectMake(8.0f, 43.0f, tableView.frame.size.width, 0.7f)];
    _imgViewDivider.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:197.0/255.0 blue:210.0/255.0 alpha:1.0];
    _imgViewDivider.alpha = 2.0;
    [cell.contentView addSubview:_imgViewDivider];
    
    return cell;
    
//    NSString *cellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.textLabel.text = [[combinedReciprocation objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[combinedTitleReciprocation objectAtIndex:0] count];
    }
    else if (section == 1)
    {
        return [[combinedTitleReciprocation objectAtIndex:0] count];
    }
    return 0;
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
