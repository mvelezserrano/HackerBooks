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
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) NSArray *tags;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *pdfURL;

@property (nonatomic) BOOL isFavorite;


// Designated
-(id) initWithTitle: (NSString *) title
            authors: (NSArray *) authors
               tags: (NSArray *) tags
           imageURL: (NSString *) imageURL
             pdfURL: (NSString *) pdfURL;


// Inicializador a partir de un diccionario JSON
-(id) initWithDictionary: (NSDictionary *) dict;


@end