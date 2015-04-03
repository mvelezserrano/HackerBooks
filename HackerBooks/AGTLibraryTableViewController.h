//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Mixi on 31/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#define BOOK_DID_CHANGE_NOTIFICATION_NAME @"bookDidChangeNotification"
#define BOOK_FAVORITE_NOTIFICATION_NAME @"bookFavoriteNotification"
#define BOOK_KEY @"bookKey"

#import <UIKit/UIKit.h>
@class AGTBook;
@class AGTLibrary;
@class AGTLibraryTableViewController;

@protocol AGTLibraryTableViewControllerDelegate <NSObject>

@optional

- (void) libraryTableViewController: (AGTLibraryTableViewController *) libVC
                      didSelectBook: (AGTBook *) book;

@end

@interface AGTLibraryTableViewController : UITableViewController <AGTLibraryTableViewControllerDelegate>

@property (strong, nonatomic) AGTLibrary *model;
@property (weak, nonatomic) id<AGTLibraryTableViewControllerDelegate> delegate;

- (id) initWithModel: (AGTLibrary *) model
               style: (UITableViewStyle) style;

@end
