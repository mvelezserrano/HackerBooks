//
//  AGTSimplePDFViewController.h
//  HackerBooks
//
//  Created by Mixi on 31/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTBook;

@interface AGTSimplePDFViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *browser;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, strong) AGTBook *model;

-(id) initWithModel:(AGTBook *) model;

@end