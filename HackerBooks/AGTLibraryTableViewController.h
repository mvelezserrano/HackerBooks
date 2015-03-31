//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Mixi on 31/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTLibrary;

@interface AGTLibraryTableViewController : UITableViewController

@property (strong, nonatomic) AGTLibrary *model;

- (id) initWithModel: (AGTLibrary *) model
               style: (UITableViewStyle) style;

@end
