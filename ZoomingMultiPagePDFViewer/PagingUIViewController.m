//
//  PagingUIViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PagingUIViewController.h"
#import "PDFScrollView.h"

@implementation PagingUIViewController

@synthesize currentPageIndex;
@synthesize recycledPages;
@synthesize visiblePages;
@synthesize scrollView;
@synthesize pageCount;
@synthesize firstNeededPageIndex;
@synthesize lastNeededPageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addScrollView];
}

- (void)addScrollView
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = [self contentSizeForScrollView];
    [self.view addSubview:scrollView];
}

- (void)dealloc
{
    [recycledPages release];
    [visiblePages release];
    [scrollView release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)calculateFirstLastNeededPageIndex{}

- (void)tilePages
{
    [self calculateFirstLastNeededPageIndex];
    
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
            PDFScrollView *page = [[[PDFScrollView alloc] initWithFrame: [self rectForPage:index]
                                                            andFileName:@"alice.pdf" 
                                                               withPage:index] autorelease];
            [scrollView addSubview:page];
            [visiblePages addObject:page];
            
            NSLog(@"Creating page %d", index);
        }
    }
}

- (CGRect)rectForPage:(NSInteger)pageIndex
{
    return CGRectNull;
}

- (CGRect)rectForView
{
    return CGRectNull;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    [self tilePages];
}

- (CGSize)contentSizeForScrollView
{
    return CGSizeZero;
}


@end
