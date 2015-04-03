//
//  AGTBook.h
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGTBook : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *authors;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSURL *imageURL;
@property (copy, nonatomic) NSString *pdfURL;

@property (nonatomic) BOOL isFavorite;


// Designated
-(id) initWithTitle: (NSString *) title
            authors: (NSString *) authors
               tags: (NSString *) tags
           imageURL: (NSURL *) imageURL
             pdfURL: (NSString *) pdfURL;


// Inicializador a partir de un diccionario JSON
-(id) initWithDictionary: (NSDictionary *) dict;

-(NSDictionary *) asJSONDictionary;

-(NSComparisonResult)localizedCaseInsensitiveCompare: (AGTBook*)other;

@end