//
//  ZoomingMultiPagePDFViewerViewController.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagingUIViewController.h"

@class PDFScrollView;
@class IndexViewController;

@interface PageViewController : PagingUIViewController 
{
    UILabel *labelCurrentPage;
    IndexViewController *indexViewController; 
    BOOL handleNotification;
}

@property (nonatomic, assign) BOOL handleNotification;
@property (nonatomic, retain) UILabel *labelCurrentPage;

- (void)showHideIndexPopup:(id)sender;

@end
