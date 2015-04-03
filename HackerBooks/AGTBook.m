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
             pdfURL: (NSString *) pdfURL
           favorite: (BOOL) isFavorite {
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _imageURL = imageURL;
        _pdfURL = pdfURL;
        _isFavorite = isFavorite;
    }
    
    return self;
}

-(id) initWithDictionary: (NSDictionary *) dict {
    return [self initWithTitle:[dict objectForKey:@"title"]
                       authors:[dict objectForKey:@"authors"]
                          tags:[dict objectForKey:@"tags"]
                      imageURL:[dict objectForKey:@"image_url"]
                        pdfURL:[dict objectForKey:@"pdf_url"]
                      favorite: NO];
}


-(NSDictionary *) asJSONDictionary {
    
    return @{@"title"      : self.title,
             @"authors"    : self.authors,
             @"tags"       : self.tags,
             @"image_url"  : [self.imageURL path],
             @"pdf_url"    : self.pdfURL};
}



-(NSComparisonResult)localizedCaseInsensitiveCompare: (AGTBook*)other {
    return [self.title localizedCaseInsensitiveCompare: other.title];
}

@end