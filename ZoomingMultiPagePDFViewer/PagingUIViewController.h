//
//  PagingUIViewController.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFScrollView;

@interface PagingUIViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    UIScrollView *scrollView;
    NSInteger currentPageIndex;
    int pageCount;
    
    int firstNeededPageIndex;
    int lastNeededPageIndex;
}

@property (nonatomic, assign) int firstNeededPageIndex;
@property (nonatomic, assign) int lastNeededPageIndex;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) int pageCount;

- (PDFScrollView *)dequeueRecycledPage;
- (CGRect)rectForPage:(NSInteger)pageIndex;
- (CGRect)rectForView;
- (void)tilePages;
- (CGSize)contentSizeForScrollView;
- (void)addScrollView;
- (void)calculateFirstLastNeededPageIndex;

@end
