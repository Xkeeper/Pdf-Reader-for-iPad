//
//  ZoomingMultiPagePDFViewerViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageViewController.h"
#import "PDFScrollView.h"
#import "IndexViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PageViewController (Private)
    - (BOOL)isDisplayingPageForIndex:(NSInteger)index;
    - (void)addCurrentPageLabel;
    - (void)updateCurrentPageLabel;
    - (void)addIndexPopUpButton;
    - (void)scrollToPage:(int)pageIndex;
@end

@implementation PageViewController

@synthesize labelCurrentPage;
@synthesize handleNotification;

- (void)changePage:(NSNotification *)notification
{
    self.currentPageIndex = [[notification.userInfo objectForKey:@"PAGE"] intValue];
    self.handleNotification = YES;
    
    [self tilePages];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [labelCurrentPage release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGRect)rectForPage:(NSInteger)pageIndex
{
    return CGRectMake(0, 
                      1004 * (pageIndex - 1), 
                      768, 
                      1004);
}

- (CGRect)rectForView
{
    return CGRectMake(0, 
                      1004, 
                      768, 
                      1004);
}

- (CGSize)contentSizeForScrollView
{
    return CGSizeMake(768, 1004 * pageCount);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    [super scrollViewDidEndDecelerating:theScrollView];
    [self updateCurrentPageLabel];
}

- (void)calculateFirstLastNeededPageIndex
{
    int currentPage;
    
    if (handleNotification)
    {
        currentPage = self.currentPageIndex;
    }
    else
    {
        CGRect visibleBounds = scrollView.bounds;
        currentPage = (floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds)));
        self.currentPageIndex = currentPage + 1;
    }

    self.firstNeededPageIndex = MAX(currentPage--, 1);
    self.lastNeededPageIndex = firstNeededPageIndex + 3;
    self.lastNeededPageIndex = MIN(lastNeededPageIndex, self.pageCount);    
    
    if (handleNotification)
    {
        [self scrollToPage:self.currentPageIndex];
    }
    
    self.handleNotification = NO;
}

- (void)scrollToPage:(int)pageIndex
{
    [self.scrollView scrollRectToVisible:CGRectMake(0, (pageIndex-1)*1024, 768, 1024) animated:YES];
}

- (void)tilePages
{
    [super tilePages];
    
    [self updateCurrentPageLabel];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePage:) name:@"CHANGE_CURRENT_PAGE" object:nil];
    self.handleNotification = NO;  
    
    [self addIndexPopUpButton];
    
    [self addCurrentPageLabel];
    self.currentPageIndex = 1;
    [self updateCurrentPageLabel];
    
    [self tilePages];
}

- (void)addIndexPopUpButton
{
    UIButton *buttonPopup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonPopup.frame = CGRectMake(20, 50, 60, 60);
    [buttonPopup setTitle:@"Pages" forState:UIControlStateNormal];
    [buttonPopup addTarget:self action:@selector(showHideIndexPopup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPopup];
}

- (void)addCurrentPageLabel
{
    labelCurrentPage = [[UILabel alloc] init];
    self.labelCurrentPage.frame = CGRectMake(0, 0, 100, 70);
    self.labelCurrentPage.backgroundColor = [UIColor clearColor];
    self.labelCurrentPage.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:labelCurrentPage];
}

- (void)updateCurrentPageLabel
{
    [self.labelCurrentPage setText:[NSString  stringWithFormat:@"%d", self.currentPageIndex]];    
}

#pragma mark -
- (void)showHideIndexPopup:(id)sender
{
    if(!indexViewController)
    {
        indexViewController = [[IndexViewController alloc] init];
        indexViewController.pageCount = self.pageCount;
        indexViewController.currentPageIndex = self.currentPageIndex;
        [self.view addSubview:indexViewController.view]; 
    }
    else
    {
        [indexViewController.view removeFromSuperview];
        [indexViewController release];
        indexViewController = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
