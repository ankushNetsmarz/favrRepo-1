//
//  GroupNameAndDetailVC.m
//  Favr
//
//  Created by Ankush on 04/07/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "GroupNameAndDetailVC.h"

@interface GroupNameAndDetailVC ()

@end

@implementation GroupNameAndDetailVC
@synthesize groupMemberArray;

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
    // Do any additional setup after loading the view from its nib.
    
    self.groupImageViewObj.layer.cornerRadius = 124/2;
    self.groupImageViewObj.layer.masksToBounds = YES;
    
    rectGroup = self.groupInfoView.frame;
    NSLog(@"group member array %@", groupMemberArray);
    self.groupTitleTxtFld.delegate = self;
    self.GroupDescTxtView.delegate = self;
    
}
#pragma mark- call method to resign keyboard when user touch the uiview


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [_groupTitleTxtFld resignFirstResponder];
    [_GroupDescTxtView resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.groupTitleTxtFld.text = @"";
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.GroupDescTxtView.text = @"";
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = self.groupInfoView.frame;
    rect.origin.y = rect.origin.y - 50;
    self.groupInfoView.frame = rect;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.groupInfoView.frame = rectGroup;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = self.groupInfoView.frame;
    rect.origin.y = rect.origin.y - 160;
    self.groupInfoView.frame = rect;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.groupInfoView.frame = rectGroup;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    [textView resignFirstResponder];
    return YES;
}


// compress image data to 30% of its actual size before uploading
- (UIImage *)compressForUpload:(UIImage *)original :(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma mark OtherMethod
// creation of group
- (IBAction)createGroup:(UIBarButtonItem *)sender {
    
    
    [self.groupTitleTxtFld resignFirstResponder];
    [self.GroupDescTxtView resignFirstResponder];
    
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
    
    
    
    NSData *imagedata1 = UIImagePNGRepresentation(self.groupImageViewObj.image);
    NSData *imagedata = UIImagePNGRepresentation([self compressForUpload:self.groupImageViewObj.image :.3]);
    NSString *encodedBase64Image = [imagedata base64Encoding];
    
    NSMutableArray *groupMemberIDs = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", [[groupMemberArray objectAtIndex:0] objectAtIndex:0]);
    for (int i = 0; i < [[groupMemberArray objectAtIndex:0] count]; i++)
    {
        [groupMemberIDs addObject:[[[groupMemberArray objectAtIndex:0] objectAtIndex:i] objectAtIndex:3]];
    }
    NSLog(@"group members %@", groupMemberIDs);
    NSString *groupAdmin = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    [groupMemberIDs addObject:groupAdmin];
    
    [PFCloud callFunctionInBackground:@"createGroup"
                       withParameters:@{
                                        @"grpDescription": self.GroupDescTxtView.text,
                                        @"grpName": self.groupTitleTxtFld.text,
                                        @"grpUser":groupMemberIDs,
                                        @"grpAdmin":groupAdmin,
                                        @"grpImage": encodedBase64Image
                                        }
                                block:^(NSString *results, NSError *error) {
                                    
                                    [appDelegate() dismissMBHUD];
                                    appDelegate().updatePendingOutGoing = updateYes;
                                    appDelegate().groupStatus = isGroupAddedYes;
                                    [self showStatus:@"Group Created Successfully" timeout:5];
                                    
                                }];
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
    [self.navigationController popToViewController:[array objectAtIndex:array.count-3] animated:YES];
}

// picking image for group
- (IBAction)groupImageBtnAct:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// pickerview delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.groupImageViewObj.image = image;
    //Or you can get the image url from AssetsLibrary
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

// navigates to previous view
- (IBAction)backBtnAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
