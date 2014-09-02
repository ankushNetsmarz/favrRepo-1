//
//  AppDelegate.m
//  Favr
//
//  Created by Weexcel on 28/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>
#import "AccessContactVC.h"

#import "LeftSlideMenuVC.h"
#import "RightSlideMenuVC.h"
#import "SlideNavigationController.h"
#import "Quickblox/Quickblox.h"
#import "Reachability.h"


@implementation AppDelegate
@synthesize groupSelected;
@synthesize loginSignupFlag;
@synthesize addContactUserId;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize hud = _hud;
@synthesize userLogout = _userLogout;
@synthesize chatType = _chatType;
@synthesize chatRoom = _chatRoom;
@synthesize getDialogs = _getDialogs;
@synthesize loginUserName = _loginUserName;
@synthesize editType = _editType;

@synthesize kPayPalOAuth2ScopeFuturePayments =_kPayPalOAuth2ScopeFuturePayments;
@synthesize kPayPalOAuth2ScopeProfile = _kPayPalOAuth2ScopeProfile;
@synthesize kPayPalOAuth2ScopeOpenId = _kPayPalOAuth2ScopeOpenId;
@synthesize kPayPalOAuth2ScopePayPalAttributes = _kPayPalOAuth2ScopePayPalAttributes;
@synthesize kPayPalOAuth2ScopeEmail = _kPayPalOAuth2ScopeEmail;
@synthesize kPayPalOAuth2ScopeAddress  = _kPayPalOAuth2ScopeAddress;
@synthesize kPayPalOAuth2ScopePhone = _kPayPalOAuth2ScopePhone;
@synthesize updatePendingOutGoing = _updatePendingOutGoing;

@synthesize getrootType = _getrootType;
@synthesize Facebook = _Facebook;
@synthesize Twitter = _Twitter;
@synthesize LinkedIn = _LinkedIn;
@synthesize GooglePlus = _GooglePlus;
@synthesize isFromSignUpPage = _isFromSignUpPage;
@synthesize contactStatus = _contactStatus;
@synthesize groupStatus = _groupStatus;

@synthesize isNumberVerified = _isNumberVerified;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
       
    NSLog(@"document directory %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    _getDialogs = [[NSMutableArray alloc]init];
    
    _userLogout = Login;
    _updatePendingOutGoing = updateNo;
    _contactStatus  = isContactAddedNo;
    _groupStatus = isGroupAddedNo;
    
    
    [QBSettings setApplicationID:11524];
    [QBSettings setAuthorizationKey:@"AFwuBUxEB3UvWZJ"];
    [QBSettings setAuthorizationSecret:@"8ZVFkrcbYZwHAVA"];
    [QBSettings setAccountKey:@"P9ZsMADae6SyxxkRTTxa"];
    
    
    [Parse setApplicationId:@"FAErcgGLrgrlSokwv5UTugwVkrIzNQGbrtvTInTV"
                  clientKey:@"2hMlmafpYE3kiLVxurYBaTHQ6StngudjXYMxcUgZ"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard"
															 bundle: nil];
	
	LeftSlideMenuVC *leftMenu = (LeftSlideMenuVC*)[mainStoryboard
                                                   instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
	
	RightSlideMenuVC *rightMenu = (RightSlideMenuVC*)[mainStoryboard
                                                      instantiateViewControllerWithIdentifier: @"RightMenuViewController"];
	
	[SlideNavigationController sharedInstance].rightMenu = rightMenu;
	[SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];



   return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"URL = %@", url);
    NSString* string = [NSString stringWithFormat:@"%@",url];
    if([string hasPrefix:@"com.development.favrpushnotification:/oauth2callback?"]){
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }

    else{
        // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
        BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        // You can add your app-specific url handling code here if needed
        return wasHandled;
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo = %@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
    }
    else{
    }
//    if ([self shouldSendPushMessage:[userInfo valueForKey:@"userInfo"]]) {
//        //UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:<#(NSString *)#> message:<#(NSString *)#> delegate:<#(id)#> cancelButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil]
//        [PFPush handlePush:userInfo];
//    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Fav" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fav.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark- Method to Initialize the Activity Indicator

-(void)showMBHUD:(NSString*)strText{
    _hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = strText;
}
-(void)dismissMBHUD{
 //   [_hud hide:YES];
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    [self.hud removeFromSuperview];
    self.hud = nil;
}
#pragma mark- Check Internet Connection using reachability methods

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
	if(curReach == self.internetReach)
	{
		NSLog(@"Internet");
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
		switch (netStatus)
		{
			case NotReachable:
			{
				self.internetWorking = -1;
				NSLog(@"Internet NOT WORKING");
				break;
			}
			case ReachableViaWiFi:
			{
				self.internetWorking = 0;
				break;
			}
			case ReachableViaWWAN:
			{
				self.internetWorking = 0;
				break;
				
			}
		}
	}
}

-(void)CheckInternetConnection
{
	self.internetReach = [Reachability reachabilityForInternetConnection];
	[self.internetReach startNotifer];
	[self updateInterfaceWithReachability: self.internetReach];
}






@end
AppDelegate *appDelegate(void){

    return  (AppDelegate*)[UIApplication sharedApplication].delegate;

}
