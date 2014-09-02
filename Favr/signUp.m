//
//  signUp.m
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "signUp.h"
#import <Parse/Parse.h>
#import "ChatSharedManager.h"
#import "UIImage+Scale.h"
@interface signUp ()
{
}
@end

@implementation signUp
@synthesize usrEmail, usrPasswd;
@synthesize profileImage, usrName;
@synthesize isSelectImage = _isSelectImage;
static int const KAllInputField = 5;

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
    _isSelectImage = NO;
    // Do any additional setup after loading the view.
    self.txtFullName.text = self.usrName;
    self.txtEmail.text = self.usrEmail;
    self.txtPassword.text=self.usrPasswd;
    NSData *data =  UIImagePNGRepresentation(self.profileImage);
    if (data.bytes)
    {
        self.profileImageView.image = self.profileImage;
    }
    self.profileImageView.layer.cornerRadius = 100.0f/2.0;
    self.profileImageView.layer.masksToBounds=YES;
    
    
    for(UIView* view in self.mainScrollView.subviews){
        if (view.tag == KAllInputField) {
            view.layer.cornerRadius= 15.0f;
            view.layer.masksToBounds=YES;
        }
    }
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = YES;
    [self.view addGestureRecognizer:_tap];
    
    
}

#pragma mark- call method to resign keyboard when user touch the uiview
-(void)hideKeyboard{
    CGPoint point = CGPointMake(0,0);
    [self.mainScrollView setContentOffset:point animated:YES];
    [_txtFullName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- call method to resign keyboard when user touch the uiview


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtFullName resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
}
- (IBAction)cancelSignUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signUpUser:(UIButton *)sender {
    
    
    [appDelegate() CheckInternetConnection];
    if([appDelegate() internetWorking] ==0){
        
    }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please connect to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
        return;
    }
    

    
    
    NSLog(@"________________________%d",self.txtFullName.text.length);
    
    NSString *UserName= [self.txtFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"________________________%d",UserName.length);
    
    
    if(UserName.length == 0 ){
        [self showAlertWithText:@"Error!" :@"Please enter a valid Full name"];
        self.txtFullName.text =@"";
        return;
    }
    
    
    if(self.txtEmail.text.length == 0 ){
        [self showAlertWithText:@"Error!" :@"Please enter a Email Address"];
        return ;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:_txtEmail.text])
    {
        
    }
    else{
        [self showAlertWithText:@"Error!" :@"Please enter a valid Email Address"];
        return;
    }
  
    if (self.txtPassword.text.length <8)
    {
        [self showAlertWithText:@"Error!" :@"Password should be atleast 8 character"];
        return ;
    }
    
    
    NSLog(@"________________________%@",UserName);
   
    [appDelegate() showMBHUD:@"Please Wait..."];
    
    if (_isSelectImage==YES) {
        
    }else{
    
    
    NSString* usrProfImagePath = @"~/Documents/userFBImage.png";
    UIImage* tempImage = [UIImage imageWithContentsOfFile:[usrProfImagePath stringByExpandingTildeInPath]];
NSData *imgData = UIImagePNGRepresentation(tempImage);
    if (imgData==nil) {
        if (_isSelectImage==NO) {
            self.profileImageView.image = [UIImage imageNamed:@"profileImage.png"];
        }
        
    }else{
        
    }
    }
    NSData *imagedata = UIImagePNGRepresentation(self.profileImageView.image);
    NSString *encodedBase64Image = [imagedata base64Encoding];
    NSString* userEmail =self.txtEmail.text;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    NSLog(@"email: %@", self.txtEmail.text);
    [PFCloud callFunctionInBackground:@"singUp"
       withParameters:@{@"emailId": self.txtEmail.text,
                        @"pwd":self.txtPassword.text,
                        @"fullName": UserName,
                        @"profileImage": encodedBase64Image}
                block:^(NSString *results, NSError *error) {
//                    if (!error) {
                        NSLog(@"result: %@",results);
                    
                    NSMutableArray *itemsArray = [results componentsSeparatedByString:@","];
                    
                    if (!error) {
                        if([results isEqualToString:@"You are already registered, Try LogIn !"])
                        {
                            [appDelegate() dismissMBHUD];
                            [self showAlertWithText:@"Favr" :results];
                        }
                        else{
                            
                            
                            appDelegate().getrootType  = fromregistrationVC;
                            appDelegate().loginSignupFlag = 1;
                            NSString *resultString = [[userEmail componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@"."];
                            NSLog (@"Result: %@", resultString);
                            NSString* chatUserName = resultString;
                            
                            [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"loggedInUserPassword"];
                            [[NSUserDefaults standardUserDefaults] setObject:self.txtEmail.text forKey:@"loggedInUserEmail"];
                            [[NSUserDefaults standardUserDefaults] setObject:[itemsArray objectAtIndex:0] forKey:@"userId"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            [self performSegueWithIdentifier:@"socialPage"  sender:nil];
                            [appDelegate() dismissMBHUD];
                            appDelegate().isFromSignUpPage = YES;
                            
                            
                            if ([[itemsArray objectAtIndex:1] isEqualToString:@"false"]) {
                                appDelegate().isNumberVerified = NO;
                            }
                            else{
                            appDelegate().isNumberVerified = YES;
                            
                            }
                           
                            
                            [[NSUserDefaults standardUserDefaults]setObject:chatUserName forKey:@"chatUserName"];
                            [[NSUserDefaults standardUserDefaults]setObject:self.txtPassword.text forKey:@"password"];
                            
                            [[ChatSharedManager sharedManager] setTxtUserName:chatUserName];
                            [[ChatSharedManager sharedManager] setTxtUserPassword:self.txtPassword.text];
                            [[ChatSharedManager sharedManager] loginChatFunction:@"REGISTER"];
                            
                            
                        }

                        
                    }else{
                    
                        [appDelegate() dismissMBHUD];
                        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Server not responding. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [_alertView show];
                    }
                        
                    
                }];
}

-(BOOL)validateFields{
    if(self.txtFullName.text.length == 0 ){
        [self showAlertWithText:@"Error" :@"Please enter a valid Full name"];
        return NO;
    }
    if(self.txtEmail.text.length == 0 ){
        [self showAlertWithText:@"Error" :@"Please enter a Email Address"];
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:_txtEmail.text])
    {
         [self showAlertWithText:@"Error" :@"Please enter a valid Email Address"];
        return YES;
    }
    else
        return NO;
    
    
    return YES;
}

-(void)showAlertWithText:(NSString*)title :(NSString*)message{
    UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [validationAlert show]
    ;
}
- (void)showLoadingWithLabel{
//	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    HUD.labelText = @"Loading";


}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGPoint point = CGPointMake(0,0);
    [self.mainScrollView setContentOffset:point animated:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint point = CGPointMake(0,152);
    [self.mainScrollView setContentOffset:point animated:YES];
    return YES;
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

- (IBAction)profileImageAct:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _isSelectImage = YES;
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _lblAddImage.text = @"Edit Image";
    
//    CGImageRef ref = image.CGImage;
//    int width = CGImageGetWidth(ref);
//    int height = CGImageGetHeight(ref);
//    width = width+50;
//    height = height+100;
//    if (width>320) {
//        width= 320;
//    }
//    if (height>480) {
//        height = 480;
//    }
    
    
//    NSLog(@"orig image size = %d x %d", width, height);
    
//    UIImage *scaledImage = [[UIImage alloc]init];
    
 //   scaledImage = image;
    
  //  scaledImage =[scaledImage scaleToSize:CGSizeMake(250, 250)];
    
    
    self.profileImageView.image = image;
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
