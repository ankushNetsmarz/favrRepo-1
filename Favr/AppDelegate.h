//
//  AppDelegate.h
//  Favr
//
//  Created by Weexcel on 28/04/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//
//   98  197  210


#define twitterApiKey               @"NbdqXUIrOyfs1F3ahNj5oqBoo"
#define twitterSecretKey            @"PjlvAOmpWRn4t5GctmTBVbKGG0G49tLLxB7xokvz4thR25EMho"


#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "MBProgressHUD.h"
#import <Quickblox/Quickblox.h>
#import <GooglePlus/GooglePlus.h>

typedef enum {
    Logout,
    Login,
} userLogout;
typedef enum {
    helper,
    helpee,
} chatType;
typedef enum {
    editYes,
    editNo,
} editType;

typedef enum {
    fromregistrationVC,
    fromloginVC,
} getrootType;


typedef enum {
    updateYes,
    updateNo,
} updatePendingOutGoing;

typedef enum {
    isFacebookYes,
    isFacebookNo,
} Facebook;
typedef enum {
    isTwitterYes,
    isTwitterNo,
} Twitter;
typedef enum {
    isLinkedInYes,
    isLinkedInNo,
} LinkedIn;
typedef enum {
    isGooglePlusYes,
    isGooglePlusNo,
} GooglePlus;

typedef enum {
    isContactAddedYes,
    isContactAddedNo,
} contactStatus;

typedef enum {
    isGroupAddedYes,
    isGroupAddedNo,
} groupStatus;

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPDeepLinkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) int groupSelected;
@property (assign, nonatomic) int loginSignupFlag;
@property (assign, nonatomic) NSString *addContactUserId;

@property(assign,nonatomic)userLogout userLogout;
@property(assign,nonatomic)chatType chatType;
@property(assign,nonatomic)editType editType;
@property(assign,nonatomic) getrootType  getrootType;
@property(assign,nonatomic) updatePendingOutGoing updatePendingOutGoing;


@property(assign,nonatomic) contactStatus contactStatus;
@property(assign,nonatomic) groupStatus groupStatus;


@property(assign,nonatomic) Facebook   Facebook;
@property(assign,nonatomic) Twitter    Twitter;
@property(assign,nonatomic) LinkedIn   LinkedIn;
@property(assign,nonatomic) GooglePlus GooglePlus;

@property(assign,nonatomic) BOOL isFromSignUpPage;

@property(assign,nonatomic) BOOL isPendingOutgoingDone;
@property(assign,nonatomic) BOOL isPendingIncommingDone;
@property(assign,nonatomic) BOOL isFavrOutgoingDone;
@property(assign,nonatomic) BOOL isFavrIncommingDone;

@property(assign,nonatomic) BOOL isNumberVerified;

//******UI Reachibility
@property (nonatomic, retain) Reachability              *internetReach;
@property (nonatomic, retain) Reachability              *wifiReach;
@property int internetWorking;



@property (nonatomic, strong) QBChatRoom *chatRoom;
@property (nonatomic, strong)NSMutableArray*  getDialogs;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,retain)MBProgressHUD *hud;
@property (nonatomic,strong)NSString *loginUserName;


/// Authorize charges for future purchases paid for with PayPal.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopeFuturePayments;
/// Share basic account information.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopeProfile;
/// Basic Authentication.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopeOpenId;
/// Share your personal and account information.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopePayPalAttributes;
/// Share your email address.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopeEmail;
/// Share your account address.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopeAddress;
/// Share your phone number.
@property (nonatomic,strong) NSString * kPayPalOAuth2ScopePhone;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)showMBHUD:(NSString*)strText;
-(void)dismissMBHUD;

- (void) updateInterfaceWithReachability: (Reachability*) curReach;
- (void)CheckInternetConnection;



@end
AppDelegate *appDelegate(void);