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
    - (void)tilePages;
    - (BOOL)isDisplayingPageForIndex:(NSInteger)index;
    - (PDFScrollView *)dequeueRecycledPage;
    - (void)addCurrentPageLabel;
    - (void)updateCurrentPageLabel;
    - (void)addScrollView;
    - (void)addIndexPopUpButton;
@end

@implementation PageViewController

@synthesize recycledPages;
@synthesize visiblePages;
@synthesize scrollView;
@synthesize pageCount;
@synthesize labelCurrentPage;
@synthesize currentPageIndex;

- (void)dealloc
{
    [scrollView release];
    [labelCurrentPage release];
    [recycledPages release];
    [visiblePages release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    [self tilePages];
}

- (void)tilePages
{
    CGRect visibleBounds = [scrollView bounds];
    
    int currentPage = (floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds)));
    self.currentPageIndex = currentPage+1;
    [self updateCurrentPageLabel];
    
    int firstNeededPageIndex = MAX(currentPage--, 1);
    
    int lastNeededPageIndex = firstNeededPageIndex + 3;
    lastNeededPageIndex = MIN(lastNeededPageIndex, self.pageCount);
    
    for (PDFScrollView *pageView in visiblePages) 
    {
        if(pageView.pageIndex < firstNeededPageIndex || pageView.pageIndex > lastNeededPageIndex)
        {
            [recycledPages addObject:pageView];
            [pageView removeFromSuperview];
        }
    }
    
    [visiblePages minusSet:recycledPages];
    
    [recycledPages removeAllObjects];
    
    // Add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) 
    {
        if(![self isDisplayingPageForIndex:index])
        {
            PDFScrollView *page = [[[PDFScrollView alloc] initWithFrame:CGRectMake(0, 
                                                                                  1004 * (index - 1), 
                                                                                  768, 
                                                                                  1004) 
                                                           andFileName:@"alice.pdf" 
                                                              withPage:index] autorelease];
            [scrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
}

- (PDFScrollView *)dequeueRecycledPage
{
    PDFScrollView *page = [recycledPages anyObject];
    if(page)
    {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index
{
    for (PDFScrollView *page in visiblePages) 
    {
        if (page.pageIndex == index) 
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // http://stackoverflow.com/questions/4732386/how-to-find-the-total-number-of-pages-in-pdf-file-loaded-in-objective-c
    NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"alice.pdf" withExtension:nil];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    self.pageCount = CGPDFDocumentGetNumberOfPages(pdf);
    
    visiblePages = [[NSMutableSet alloc] init];
    recycledPages = [[NSMutableSet alloc] init];
    
    // Add scroll view
    [self addScrollView];
    // Add index popup button
    [self addIndexPopUpButton];
    
    PDFScrollView *pageA = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)       
                                                    andFileName:@"alice.pdf" withPage:1];
    
    PDFScrollView *pageB = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, 1004 * 1, 768, 1004) 
                                                   andFileName:@"alice.pdf" withPage:2];
    
    [scrollView addSubview:pageA];
    [visiblePages addObject:pageA];
    [scrollView addSubview:pageB];
    [visiblePages addObject:pageB];
    
    [self addCurrentPageLabel];
    self.currentPageIndex = 1;
    [self updateCurrentPageLabel];
}

#pragma mark -
- (void)addScrollView
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, 768, 1004);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(768, 1004 * pageCount);
    [self.view addSubview:scrollView];
}

- (void)addIndexPopUpButton
{
    UIButton *buttonPopup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonPopup.frame = CGRectMake(20, 50, 60, 60);
    [buttonPopup setTitle:@"Pages" forState:UIControlStateNormal];
    [buttonPopup addTarget:self action:@selector(showIndexPopup:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)showIndexPopup:(id)sender
{
    IndexViewController *indexViewController = [[[IndexViewController alloc] init] autorelease];
    [self.view addSubview:indexViewController.view];
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
