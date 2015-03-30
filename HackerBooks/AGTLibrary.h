//
//  AGTLibrary.h
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AGTBook;

@interface AGTLibrary : NSObject


-(id) initWithJSON: (NSData *) json;

-(AGTBook *) primerLibro;

-(AGTBook *) randomLibro;

// Número total de libros
-(NSUInteger) booksCount;

// Array inmutable (NSArray) con todas las
// distintas temáticas (tags) en orden alfabético.
// No puede bajo ningún concepto haber ninguna repetida.
-(NSArray *) tags;

// Cantidad de libros que hay en una temática.
// Si el tag no existe, debe de devolver cero
-(NSUInteger) bookCountForTag:(NSString*) tag;


// Array inmutable (NSArray) de los libros
// (instancias de AGTBook) que hay en
// una temática.
// Un libro puede estar en una o más
// temáticas. Si no hay libros para una
// temática, ha de devolver nil.
-(NSArray *) booksForTag: (NSString *) tag;


// Un AGTBook para el libro que está en la posición
// 'index' de aquellos bajo un cierto
// tag. Mira a ver si puedes usar el método anterior
// para hacer parte de tu trabajo.
// Si el indice no existe o el tag no existe, ha de devolver nil.
-(AGTBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index;

  
@end