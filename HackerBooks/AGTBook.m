//
//  AGTBook.m
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTBook.h"

@implementation AGTBook

-(id) initWithTitle: (NSString *) title
            authors: (NSString *) authors
               tags: (NSString *) tags
           imageURL: (NSURL *) imageURL
             pdfURL: (NSURL *) pdfURL
           favorite: (BOOL) isFavorite
         downloaded: (BOOL) downloaded {
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _imageURL = imageURL;
        _pdfURL = pdfURL;
        _isFavorite = isFavorite;
        _downloaded = downloaded;
    }
    
    return self;
}

-(id) initWithDictionary: (NSDictionary *) dict {
    return [self initWithTitle:[dict objectForKey:@"title"]
                       authors:[dict objectForKey:@"authors"]
                          tags:[dict objectForKey:@"tags"]
                      imageURL:[dict objectForKey:@"image_url"]
                        pdfURL:[dict objectForKey:@"pdf_url"]
                      favorite: NO
                    downloaded: NO];
}


-(NSDictionary *) asJSONDictionary {
    
    return @{@"title"      : self.title,
             @"authors"    : self.authors,
             @"tags"       : self.tags,
             @"image_url"  : [self.imageURL path],
             @"pdf_url"    : [self.pdfURL path]};
}



-(NSComparisonResult)localizedCaseInsensitiveCompare: (AGTBook*)other {
    return [self.title localizedCaseInsensitiveCompare: other.title];
}

-(void) setIsFavorite:(BOOL)isFavorite {
    
    _isFavorite=isFavorite;
    [self notifyChanges];
}

-(void) notifyChanges {
    
    // Mandamos una notificación por el cambio de favorito
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{BOOK_KEY : self};
    
    NSNotification *n = [NSNotification notificationWithName:BOOK_FAVORITE_NOTIFICATION_NAME
                                                      object:self
                                                    userInfo:dict];
    [nc postNotification:n];
}





















@end