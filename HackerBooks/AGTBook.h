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
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *pdfURL;

@property (nonatomic) BOOL isFavorite;


// Designated
-(id) initWithTitle: (NSString *) title
            authors: (NSArray *) authors
               tags: (NSArray *) tags
           imageURL: (NSURL *) imageURL
             pdfURL: (NSURL *) pdfURL;


// Inicializador a partir de un diccionario JSON
-(id) initWithDictionary: (NSDictionary *) dict;


@end