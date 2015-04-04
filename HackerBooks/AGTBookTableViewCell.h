//
//  AGTBookTableViewCell.h
//  HackerBooks
//
//  Created by Mixi on 4/4/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGTBookTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bookIcon;
@property (strong, nonatomic) IBOutlet UILabel *bookTitle;
@property (strong, nonatomic) IBOutlet UILabel *bookAuthors;


+ (NSString *) cellId;

@end
