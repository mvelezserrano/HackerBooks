//
//  AGTBookViewController.h
//  HackerBooks
//
//  Created by Mixi on 27/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTLibraryTableViewController.h"

@class AGTBook;

@interface AGTBookViewController : UIViewController <UISplitViewControllerDelegate, AGTLibraryTableViewControllerDelegate>

@property (strong, nonatomic) AGTBook *model;

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UILabel *bookTags;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;

@property (strong, nonatomic) IBOutlet UIView *portraitView;

// Vista horizontal
@property (weak, nonatomic) IBOutlet UIImageView *bookImageLandscape;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLandscape;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorsLandscape;
@property (weak, nonatomic) IBOutlet UILabel *bookTagsLandscape;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitchLandscape;

@property (strong, nonatomic) IBOutlet UIView *landscapeView;

- (IBAction)displayPDF:(id)sender;
- (IBAction)setFavorite:(id)sender;

- (id)initWithModel:(AGTBook *)model;

@end