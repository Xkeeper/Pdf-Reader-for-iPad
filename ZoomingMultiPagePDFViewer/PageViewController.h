//
//  ZoomingMultiPagePDFViewerViewController.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFScrollView;

@interface PageViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    
    int pageCount;
    UILabel *labelCurrentPage;
    NSInteger currentPageIndex;
}

@property (nonatomic, assign) int pageCount;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;
@property (nonatomic, retain) UILabel *labelCurrentPage;
@property (nonatomic, assign) NSInteger currentPageIndex;

@end
