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
            authors: (NSArray *) authors
               tags: (NSArray *) tags
           imageURL: (NSString *) imageURL
             pdfURL: (NSString *) pdfURL{
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _imageURL = imageURL;
        _pdfURL = pdfURL;
        
    }
    
    return self;
}

-(id) initWithDictionary: (NSDictionary *) dict {
    return [self initWithTitle:[dict objectForKey:@"title"]
                       authors:[self createArrayFromJSONMultipleString:[dict objectForKey:@"authors"]]
                          tags:[self createArrayFromJSONMultipleString:[dict objectForKey:@"tags"]]
                      imageURL:[dict objectForKey:@"image_url"]
                        pdfURL:[dict objectForKey:@"pdf_url"]];
}


#pragma mark - Utils

-(NSArray*) createArrayFromJSONMultipleString: (NSString *)JSONMultipleString{
    
    NSArray *elements = [JSONMultipleString componentsSeparatedByString:@", "];
    
    return elements;
}

@end
