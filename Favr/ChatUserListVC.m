//
//  ChatUserListVC.m
//  Favr
//
//  Created by Ankush on 08/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "ChatUserListVC.h"
#import "QuickBlox/QuickBlox.h"
#import "ChatSharedManager.h"
#import "MyChattingVC.h"

@interface ChatUserListVC ()
@property(nonatomic,strong) NSMutableArray* users;

@end

@implementation ChatUserListVC
int selectedIndex;


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
    // Do any additional setup after loading the view.
    
    self.users = [[ChatSharedManager sharedManager] chatUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW DATASOURCE & DELEGATES
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    QBUUser *user = (QBUUser *)self.users[indexPath.row];
    cell.tag = indexPath.row;
    cell.textLabel.text = user.login;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = (int)indexPath.row;
    //[self performSegueWithIdentifier:@"GotoChatPage" sender:nil];
    
    //    СhattingVC *destinationViewController = [[СhattingVC alloc] init];
    //    QBUUser *user = (QBUUser *)self.users[selectedIndex];
    //    destinationViewController.opponent = user;
    //
    //    [[SlideNavigationController sharedInstance] pushViewController:destinationViewController animated:YES];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard"
															 bundle: nil];
	
	MyChattingVC *chattingVC = (MyChattingVC*)[mainStoryboard
                                               instantiateViewControllerWithIdentifier:@"MyChattingVC"];
    
    QBUUser *user = (QBUUser *)self.users[selectedIndex];
    
    chattingVC.opponent = user;
//    [[SlideNavigationController sharedInstance] pushViewController:chattingVC animated:YES];
    [self.navigationController pushViewController:chattingVC animated:YES];
    
}

#pragma mark - OtherMethod
// navigates to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
