//
//  ChatImageScrollView.m
//  Favr
//
//  Created by Ankush on 01/08/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "ChatImageScrollView.h"
#import "UIImageView+WebCache.h"

@interface ChatImageScrollView ()

@end

@implementation ChatImageScrollView
@synthesize imageScrollView;
@synthesize pageControl;
@synthesize messageArray;
@synthesize currentImageId;
@synthesize currentImageName = _currentImageName;


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
    imageIdArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < messageArray.count; i++)
    {
         QBChatAbstractMessage *message = messageArray[i];
        [self configureCellWithMessage:message];
        
    }
    
    NSLog(@"imageIdArray %@", imageIdArray);
    [self initiateScrollView:imageIdArray.count];
    
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = imageIdArray.count;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:57.0/255.0 green:175.0/255.0 blue:191.0/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
}

- (void)configureCellWithMessage:(QBChatAbstractMessage *)message{

    if (([message.text hasPrefix:@"http://"]||[message.text hasPrefix:@"https://"]) && [message.text hasSuffix:@".png"])
    {
        [imageIdArray addObject:message.text];
        
    }


}
-(void)viewWillAppear:(BOOL)animated{
    
    
    for (int i = 0; i < imageIdArray.count; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        
        if ([[imageIdArray objectAtIndex:i] isEqualToString:_currentImageName]) {
            [self.imageScrollView setContentOffset:CGPointMake(xOrigin,0) animated:YES];
            pageControl.currentPage = i;
            return;
            
        }
        
        
    }

    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ScrollView

-(void)initiateScrollView:(int)numberOfPage{
//    NSInteger numberOfViews = 3;
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    for (int i = 0; i < numberOfPage; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width+40;
       
            UIImageView *demoImage = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin-20, 0, 280, 400)];
            demoImage.tag = i;
            demoImage.contentMode = UIViewContentModeScaleAspectFit;
            [demoImage sd_setImageWithURL:[NSURL URLWithString:[imageIdArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            [self.imageScrollView addSubview:demoImage];
            
        
        
        
    }
    self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width * numberOfPage, 200);
    self.imageScrollView.delegate=self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.imageScrollView.isDragging || self.imageScrollView.isDecelerating){
        self.pageControl.currentPage = lround(self.imageScrollView.contentOffset.x / (self.imageScrollView.contentSize.width / self.pageControl.numberOfPages));
        
        // Update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = imageScrollView.frame.size.width;
        
       int page = floor((imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //   NSLog(@"the page_____________%d",page);
       pageControl.currentPage = page;
        
        
    }
}


#pragma mark OtherMethod

- (IBAction)backBtnAct:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextBtnAct:(UIButton *)sender
{
    
}

@end
