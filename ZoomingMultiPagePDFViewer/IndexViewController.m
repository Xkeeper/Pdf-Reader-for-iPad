//
//  IndexViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IndexViewController.h"
#import "PDFScrollView.h"

@interface IndexViewController (Private)
- (void)addGestureRecognizer;
@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 804, 768, 192);
    self.scrollView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor lightGrayColor];
        
    [self addGestureRecognizer];
    
    [self tilePages];
}

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget: self
                                            action: @selector(changePage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer: tap];
    [tap release];
}

- (void)changePage:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.scrollView];
    // NSLog(@"location tap x : %f, y : %f", location.x, location.y);
    
    NSLog(@"User Tapped page %f on index view controller.", ceilf(location.x/192));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_CURRENT_PAGE" 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:[NSNumber 
                                                                                                   numberWithFloat:ceilf(location.x/192)] 
                                                                                           forKey:@"PAGE"]];
    
}

- (CGRect)rectForPage:(NSInteger)pageIndex
{
    return CGRectMake(192 * (pageIndex - 1), 
                      0, 
                      192, 
                      256);
}

- (CGRect)rectForView
{
    return CGRectMake(0, 
                      804, 
                      768, 
                      192);
}

- (CGSize)contentSizeForScrollView
{
    return CGSizeMake(768 * pageCount / 4, 192);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)calculateFirstLastNeededPageIndex
{
    CGRect visibleBounds = scrollView.bounds;
    int currentPage = (floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    currentPage *= 4;
    
    self.currentPageIndex = currentPage + 1;
    self.firstNeededPageIndex = MAX(currentPage - 4, 1);
    
    self.lastNeededPageIndex = firstNeededPageIndex + 12;
    self.lastNeededPageIndex = MIN(lastNeededPageIndex, self.pageCount);    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
