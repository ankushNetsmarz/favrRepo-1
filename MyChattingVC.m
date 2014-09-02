//
//  СhatViewController.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/18/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "MyChattingVC.h"
#import "ChatMessageTableViewCell.h"
#import "SlideNavigationController.h"
#import "LocalStorageService.h"

#import "ChatService.h"
#import "ChatHistory.h"
#import "ChatImageScrollView.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "UIBarButtonItem+WEPopover.h"
#import "UIImage+Scale.h"
#import "ChatVideoPlayVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface MyChattingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;

- (IBAction)sendMessage:(id)sender;

@end

@implementation MyChattingVC
@synthesize libraryType = _libraryType;
#pragma mark ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isSelectImage = NO;
    isCalltoSeeVideoPics = NO;
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.messages = [NSMutableArray array];
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initializeTextView];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(IBAction)backBtnFunctionality:(id)sender{

    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
    
}
-(void)initializeTextView{
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(46, 3, 200, 40)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [self.textView setBackgroundColor:[UIColor darkTextColor]];
    
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.textView.returnKeyType = UIReturnKeyGo; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.textView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    iscallImagePicker = NO;

    
    if ( isSelectImage == NO) {
        
        // Set keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        // Set chat notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
                                                     name:kNotificationDidReceiveNewMessage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)
                                                     name:kNotificationDidReceiveNewMessageFromRoom object:nil];
        // Set title
        if(self.dialog.type == QBChatDialogTypePrivate){
            QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(self.dialog.recipientID)];
            self.title = recipient.login == nil ? recipient.email : recipient.login;
        }else{
            self.title = self.dialog.name;
        }
        
        // Join room
        if(self.dialog.type != QBChatDialogTypePrivate){
            appDelegate.chatRoom = [self.dialog chatRoom];
            [[ChatService instance] joinRoom:appDelegate.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
                // joined
                NSLog(@"joined");
            }];
        }
        
        
        
        NSLog(@"___________________________________________%@",self.dialog.ID);
        
        if (isCalltoSeeVideoPics==YES) {
            isCalltoSeeVideoPics = NO;
        }
        else{
            // get messages history
            [QBChat messagesWithDialogID:self.dialog.ID extendedRequest:nil delegate:self];

        }
        
        
        
    }
    
   
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (iscallImagePicker == YES) {
        
        iscallImagePicker = NO;
        
    }else{
    
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [appDelegate.chatRoom leaveRoom];
    
    }
   
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark Actions
-(void)fullScreenImageView:(UIButton *)sender
{
    isCalltoSeeVideoPics = YES;
    
      QBChatAbstractMessage *message = self.messages[sender.tag];
    NSLog(@"____________________%@",message.text);
    
    if (([message.text hasPrefix:@"http://"]||[message.text hasPrefix:@"https://"]) && [message.text hasSuffix:@".mp4"])
    {
        
        ChatVideoPlayVC *videoPlayVC = [[ChatVideoPlayVC alloc] init];
        videoPlayVC.strVideoURL = message.text;
        [self.navigationController pushViewController:videoPlayVC animated:YES];
        
        
    }else{
        
        NSLog(@"sender.tag %i", sender.tag);
        NSLog(@"full screen image view");
        
        ChatImageScrollView *chatImageScrollView = [[ChatImageScrollView alloc] init];
        chatImageScrollView.messageArray = self.messages;
        chatImageScrollView.currentImageName =message.text;
        [self.navigationController pushViewController:chatImageScrollView animated:YES];
    
    }
    
    
}



- (IBAction)sendMessage:(id)sender{
    if(self.textView.text.length == 0){
        return;
    }
    
    
    [appDelegate CheckInternetConnection];
    if([appDelegate internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    
    
    // create a message
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.text = self.textView.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    // 1-1 Chat
    if(self.dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [self.dialog recipientID];
        message.senderID = [LocalStorageService shared].currentUser.ID;
    
        
        
        NSLog(@"sender User ID:_____________________________%lu",(unsigned long)message.senderID);
        NSLog(@"receiver User ID:_____________________________%lu",(unsigned long)message.recipientID);
        
        [[ChatService instance] sendMessage:message];
        
        // save message
        [self.messages addObject:message];
        
        NSLog(@"___________________%@",self.messages);
        
        // Group Chat
    }else {
        [[ChatService instance] sendMessage:message toRoom:appDelegate.chatRoom];
    }
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // Clean text field
    [self.textView setText:nil];
}


#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    
    QBChatMessage *message = notification.userInfo[kMessage];
    if(message.senderID != self.dialog.recipientID){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{
    QBChatMessage *message = notification.userInfo[kMessage];
    NSString *roomJID = notification.userInfo[kRoomJID];
    
    if(![appDelegate.chatRoom.JID isEqualToString:roomJID]){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    cell=nil;
    if(cell == nil){
        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;
        QBChatAbstractMessage *message = self.messages[indexPath.row];
        [cell configureCellWithMessage:message];
        [cell.backgroundImageBtnObj addTarget:self action:@selector(fullScreenImageView:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundImageBtnObj.tag = indexPath.row;

    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.messages.count<=0)
        return 0;
    
    QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}


#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.containerView.frame = containerFrame;
    
	
	// commit animations
	[UIView commitAnimations];
    
    self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                              self.messagesTableView.frame.origin.y,
                                              self.messagesTableView.frame.size.width,
                                              self.messagesTableView.frame.size.height-219);
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
    self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                              self.messagesTableView.frame.origin.y,
                                              self.messagesTableView.frame.size.width,
                                              self.messagesTableView.frame.size.height+219);
    
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}
- (IBAction)attactmentBtnAct:(UIButton *)sender
{
    UIActionSheet *attachmentActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Existing Photo", @"Choose Existing Video", nil];
    [attachmentActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.libraryType = photos;
        [self chooseExistingPhoto];
    }
    else if (buttonIndex == 1)
    {
        
        
        self.libraryType = videos;
        [self chooseExistingVideo];
        return;
        
        
        
        
        
//        UIImagePickerController *videoPickerController = [[UIImagePickerController alloc]init];
//        videoPickerController.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,kUTTypeVideo,kUTTypeImage, nil];
//        
////        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
////        imagePickerController.delegate = self;
////        NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.image", @"public.movie", nil];
////        [imagePickerController setMediaTypes:mediaTypesAllowed];
//        
//        [self presentModalViewController:videoPickerController animated:YES];
        /*
        
        [appDelegate showMBHUD:@"Please Wait..."];
        
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
        PFFile *imageFile = [PFFile fileWithName:@"video.mp4" data:imageData];
        PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
        userPhoto[@"imageName"] = @"My trip to Hawaii!";
        userPhoto[@"imageFile"] = imageFile;
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (succeeded)
            {
                
                QBChatMessage *message = [[QBChatMessage alloc] init];
                message.recipientID = self.opponent.ID;
                //            message.imageIdStr = [NSString stringWithFormat:@"%i", uploadedImageId];
                message.customParameters = [[NSMutableDictionary alloc] init];
                [message.customParameters setObject:[[NSString alloc] initWithFormat:@"%@",[userPhoto objectId]] forKey:@"customParameters"];
                //            message.customParameters = [[NSMutableDictionary alloc] init];
                //            [message.customParameters setObject:[NSString stringWithFormat:@"%i",uploadedImageId] forKey:@"imageID"];
                [[ChatService instance] sendMessage:message];
                // save message to history
              //  [[LocalStorageService shared] saveMessageToHistory:message withUserID:message.recipientID];
                NSString *docPath = [self docPath];
                NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[userPhoto objectId]]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    [imageData writeToFile:filePath atomically:YES];

                }
                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [appDelegate dismissMBHUD];
                [self.messagesTableView reloadData];
                
//                NSLog(@"Object id %@",[userPhoto objectId]);
//                [hud hide:YES];
//                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[userPhoto objectId]]];
//                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//                {
//                    [imageData writeToFile:filePath atomically:YES];
//                }
                
            }
        }];

        
        
//            PFFile *userImageFile = userPhoto[@"imageFile"];
//            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageDataaa, NSError *error)
//             {
//                 if (!error)
//                 {
//                     NSLog(@"Object id %@", [userPhoto objectId]);
//                     NSLog(@"data is %@", imageDataaa);
//                     NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"video.mp4"];
//                     if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//                     {
//                         [imageDataaa writeToFile:filePath atomically:YES];
//                     }
//                 }
//             }
//            ];
         */
        
    }
    else
    {
        
    }
}

-(void) chooseExistingPhoto
{
    iscallImagePicker = YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)chooseExistingVideo{
    iscallImagePicker = YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes =[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}
#pragma mark-----------------------ImagePicker Delegate Method--------------------------------------------------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    if ( self.libraryType == photos) {
        //You can retrieve the actual UIImage
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        //    self.profileImageView.image = image;
        //Or you can get the image url from AssetsLibrary
        
        isSelectImage = YES;
        UIImage *scaledImage = [[UIImage alloc]init];
        
        scaledImage = image;
        
        scaledImage =[scaledImage scaleToSize:CGSizeMake(200, 200)];
        
        
        NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
        NSString *pathStr = [path absoluteString];
        NSLog(@"path %@", path);
        ImageData = UIImagePNGRepresentation(scaledImage);
        
        NSData* toSave =UIImagePNGRepresentation(scaledImage);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
        
        NSDate *maxDate = [NSDate date];
        
        NSLog(@"max %@",maxDate);
        
        NSString *dateSTR=[[NSString alloc]initWithString:[dateFormatter stringFromDate:[NSDate date]]];
        
        NSString *imgPath=[[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"save%@.png",dateSTR]]];
        //
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:imgPath] == NO)
        {
        }
        else
        {
            [fileManager removeItemAtPath:imgPath error:NULL];
        }
        
        [toSave writeToFile:imgPath atomically:YES];
        toSave=nil;
        
        imagename = [NSString stringWithFormat:@"save%@.png",dateSTR];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:imagename] ;
        
        NSLog(@"Image name %@",writableDBPath);
        
        NSURL *_imageURL = [NSURL fileURLWithPath:writableDBPath];
        
        //	NSArray *inboxContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
        //
        //    UIImage *_userProfileImage;
        //    _userProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:_imageURL]];
        
        
        [appDelegate CheckInternetConnection];
        if([appDelegate internetWorking] ==0){
            
        }
        else
        {
            UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
            return;
        }

        
        NSLog(@"_________________%@",[NSData dataWithContentsOfURL:_imageURL]);
        [appDelegate showMBHUD:@"Sending image, Please Wait..."];
        
        
        
        PFFile *imageFile = [PFFile fileWithName:imagename data:[NSData dataWithContentsOfURL:_imageURL]];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (succeeded) {
                    
                    NSString *url = imageFile.url;
                    [appDelegate dismissMBHUD];
                    NSLog(@"imageURL_______________________________%@",url);
                    
                    // create a message
                    QBChatMessage *message = [[QBChatMessage alloc] init];
                    message.text = url;
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"save_to_history"] = @YES;
                    [message setCustomParameters:params];
                    
                    // 1-1 Chat
                    if(self.dialog.type == QBChatDialogTypePrivate){
                        // send message
                        message.recipientID = [self.dialog recipientID];
                        message.senderID = [LocalStorageService shared].currentUser.ID;
                        
                        
                        NSLog(@"sender User ID:_____________________________%lu",(unsigned long)message.senderID);
                        NSLog(@"receiver User ID:_____________________________%lu",(unsigned long)message.recipientID);
                        
                        [[ChatService instance] sendMessage:message];
                        
                        // save message
                        [self.messages addObject:message];
                        
                        NSLog(@"___________________%@",self.messages);
                        
                        // Group Chat
                    }else {
                        
                        // Join room
                        //                        appDelegate.chatRoom = [self.dialog chatRoom];
                        //                        [[ChatService instance] joinRoom:appDelegate.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
                        //                            // joined
                        //                            NSLog(@"joined");
                        //                             [[ChatService instance] sendMessage:message toRoom:appDelegate.chatRoom];
                        //                        }];
                        
                        [[ChatService instance] sendMessage:message toRoom:appDelegate.chatRoom];
                        
                        
                    }
                    
                    // Reload table
                    [self.messagesTableView reloadData];
                    if(self.messages.count > 0){
                        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    
                    
                    
                    
                }
            } else {
                // Handle error
            }        
        }];

    }
    else{
        
        
        NSURL* videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData * movieData = [NSData dataWithContentsOfURL:videoUrl];
       
        isSelectImage = YES;
        
        [appDelegate showMBHUD:@"Sending video, Please Wait..."];
       // NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
     //   NSData *myData = [NSData dataWithContentsOfFile:path];
        PFFile *imageFile = [PFFile fileWithName:@"video.mp4" data:movieData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            
            if (!error) {
                if (succeeded) {
                    
                    NSString *url = imageFile.url;
                    NSLog(@"VideoURL_______________________________%@",url);
                    
                    [appDelegate dismissMBHUD];
                    
                    // create a message
                    QBChatMessage *message = [[QBChatMessage alloc] init];
                    message.text = url;
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"save_to_history"] = @YES;
                    [message setCustomParameters:params];
                    
                    // 1-1 Chat
                    if(self.dialog.type == QBChatDialogTypePrivate){
                        // send message
                        message.recipientID = [self.dialog recipientID];
                        message.senderID = [LocalStorageService shared].currentUser.ID;
                        
                        
                        NSLog(@"sender User ID:_____________________________%lu",(unsigned long)message.senderID);
                        NSLog(@"receiver User ID:_____________________________%lu",(unsigned long)message.recipientID);
                        
                        [[ChatService instance] sendMessage:message];
                        
                        // save message
                        [self.messages addObject:message];
                        
                        NSLog(@"___________________%@",self.messages);
                        
                        // Group Chat
                    }else {
                        
                        [[ChatService instance] sendMessage:message toRoom:appDelegate.chatRoom];
                        
                        
                    }
                    
                    // Reload table
                    [self.messagesTableView reloadData];
                    if(self.messages.count > 0){
                        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    
                    
                    
                    
                    
                }
            } else {
                
                [appDelegate dismissMBHUD];
                // Handle error
            }
            
            
        }];
        
}
    
    
    ///[QBContent TUploadFile:[NSData dataWithContentsOfURL:_imageURL] fileName:@"save" contentType:@"image/png" isPublic:NO delegate:self];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    for(QBChatAttachment *attachment in message.attachments){
        // download file by ID
        [QBContent TDownloadFileWithBlobID:[attachment.ID integerValue] delegate:self];
    }
}
#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
    
    [appDelegate dismissMBHUD];
    
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class]) {
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        [self.messages addObjectsFromArray:[messages mutableCopy]];
        //
        [self.messagesTableView reloadData];
    }
    
    
    /*
    if(result.success && [result isKindOfClass:QBCFileUploadTaskResult.class]){
        
        // get uploaded file ID
        QBCFileUploadTaskResult *res = (QBCFileUploadTaskResult *)result;
        NSUInteger uploadedFileID = res.uploadedBlob.ID;
        
//        // Create chat message with attach
//        //
//        QBChatMessage *message = [QBChatMessage message];
//        
//        
//        QBChatAttachment *attachment = QBChatAttachment.new;
//        attachment.type = @"image";
//        message.recipientID = [self.dialog recipientID];
//        message.senderID = [LocalStorageService shared].currentUser.ID;
//        attachment.ID = [NSString stringWithFormat:@"%d", uploadedFileID];
//        [message setAttachments:@[attachment]];
//        
//        [[ChatService instance] sendMessage:message];
//        
//        [QBContent TDownloadFileWithBlobID:[attachment.ID integerValue] delegate:self];
        
        
        // create a message
        QBChatMessage *message = [[QBChatMessage alloc] init];
        message.text = imagename;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"save_to_history"] = @YES;
        [message setCustomParameters:params];
        
        // 1-1 Chat
        if(self.dialog.type == QBChatDialogTypePrivate){
            // send message
            message.recipientID = [self.dialog recipientID];
            message.senderID = [LocalStorageService shared].currentUser.ID;
            
            
            NSLog(@"sender User ID:_____________________________%lu",(unsigned long)message.senderID);
            NSLog(@"receiver User ID:_____________________________%lu",(unsigned long)message.recipientID);
            
            [[ChatService instance] sendMessage:message];
            
            // save message
            [self.messages addObject:message];
            
            NSLog(@"___________________%@",self.messages);
            
            // Group Chat
        }else {
            [[ChatService instance] sendMessage:message toRoom:self.chatRoom];
        }
        
        // Reload table
        [self.messagesTableView reloadData];
        if(self.messages.count > 0){
            [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

        
        
        
        
    }else{
        NSLog(@"Errors=%@", result.errors);
    }
    
    if(result.success && [result isKindOfClass:QBCFileDownloadTaskResult.class]){
        // extract image
        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
        UIImage *image = [UIImage imageWithData:res.file];
        
         NSLog(@"***************Finally Get Image******************");
        
        
    }else{
        NSLog(@"Errors=%@", result.errors);

    }
    
    */
    
}

-(NSString *)docPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}



@end
