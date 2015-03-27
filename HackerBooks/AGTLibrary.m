//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"

@interface AGTLibrary()

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSMutableArray *tags;

@end

@implementation AGTLibrary

#pragma mark - Init

-(id) init {
    if (self = [super init]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (data != nil) {
            NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
            
            if (JSONObjects != nil) {
                // No ha habido error
                for(NSDictionary *dict in JSONObjects){
                    AGTBook *book = [[AGTBook alloc] initWithDictionary:dict];
                    [self.books addObject:book];
                }
            }else{
                // Se ha producido un error al parsear el JSON
                NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
            }
            
        } else{
            // Error al descargar los datos del servidor
            NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
        }
    }
    
    return self;
}


-(AGTBook *) primerLibro {
    return [self.books objectAtIndex:0];
}


-(NSUInteger) booksCount {
    return self.books.count;
}


-(NSArray *) tags {
    /* Creamos un NSMutableArray donde iremos almacenando
     los tags leídos. Recorremos todos los libros del array 'books' y
     leemos uno a uno todos sus tags. Si el tag leído ya existe
     en el NSMutableArray, lo descartamos, sino, lo añadimos. De este
     modo descartamos los repetidos.
     Hay que ordenar alfabéticamente el NSMutableArray antes de devolverlo.
     Finalmente convertimos el NSMutableArray en un NSArray para
     devolerlo como resultado del método.*/
    
    NSArray *arrayRetorno;
    
    return arrayRetorno;
}


-(NSUInteger) bookCountForTag:(NSString*) tag {
    /* Creamos una variable NSUInteger que inicializaremos
     a 0, y que contendrá el número de libros que contienen
     el tag pasado por parámetro.
     Después, iteramos el NSArray 'books' pasando por cada libro.
     Leemos uno a uno todos sus tags. Si el tag leído es igual
     al tag pasado por parámetro, incrementaremos la variable contador.*/
    
    NSUInteger entero=0;
    
    return entero;
}


-(NSArray *) booksForTag: (NSString *) tag {
    /* Creamos un NSMutableArray donde iremos almacenando las
     instancias AGTBook que contengan el tag.
     Iteramos el NSArray 'books' pasando por cada libro.
     Leemos uno a uno todos sus tags. Si el tag leído es igual
     al tag pasado por parámetro, añadimos la instancia al 
     NSMutableAraray.
     
     Finalmente convertimos el NSMutableArray en un NSArray para
     devolerlo como resultado del método. Si no hay ningún libro
     que contenga el tag, devolveremos nil.*/
    
    NSArray *arrayRetorno;
    
    return arrayRetorno;
}



-(AGTBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index {
    /* Obtenemos el array de libros para ese tag llamando al método
     anterior y devolvemos el objeto en la posición index. */
    
    
    AGTBook *bookRetorno;
    
    return bookRetorno;
}


@end