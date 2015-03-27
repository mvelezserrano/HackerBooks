//
//  AGTBookViewController.h
//  HackerBooks
//
//  Created by Mixi on 27/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTBook.h"

@interface AGTBookViewController : UIViewController

@property (strong, nonatomic) AGTBook *model;

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UILabel *bookTags;

- (id)initWithModel:(AGTBook *)model;

@end