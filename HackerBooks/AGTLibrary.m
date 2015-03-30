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

@property (strong, nonatomic) NSMutableArray *arrayOfBooks;
@property (strong, nonatomic) NSMutableArray *arrayOfTags;

@end

@implementation AGTLibrary

#pragma mark - Init

-(id) initWithJSON: (NSData *) json {
    if (self = [super init]) {
        self.arrayOfBooks = [[NSMutableArray alloc] init];
        self.arrayOfTags = [[NSMutableArray alloc] init];
        
        
        NSError *error;
        if ([[NSJSONSerialization JSONObjectWithData:json
                                             options:kNilOptions
                                               error:&error] isKindOfClass:[NSArray class]]) {
            //NSLog(@"Es un NSArray!");
        } else {
            //NSLog(@"Es un NSDictionary!");
        }
        
        NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:json
                                                                options:kNilOptions
                                                                  error:&error];
        if (JSONObjects != nil) {
            // No ha habido error
            for(NSDictionary *dict in JSONObjects){
                AGTBook *book = [[AGTBook alloc] initWithDictionary:dict];
                
                
                /* Gestionar el array de tags desde aquí!!!!!!! */
                NSArray *bookTags = [self createArrayFromJSONMultipleString:[dict objectForKey:@"tags"]];
                NSMutableArray *tagsToAdd = [[NSMutableArray alloc] init];
                for (NSString *bookTag in bookTags) {
                    //[self.arrayOfTags addObject:bookTag];
                    NSLog(@"El tag del libro es: %@", bookTag);
                    if ([self.arrayOfTags count]==0) {
                        NSLog(@"Añadimos el primer tag");
                        //[self.arrayOfTags arrayByAddingObject:bookTag];
                        [tagsToAdd addObject:bookTag];
                    } else {
                        for (NSString *tagAlreadySaved in self.arrayOfTags) {
                            NSLog(@"Entramos al for de los salvados, con el tag salvado: %@", tagAlreadySaved);
                            if (([bookTag caseInsensitiveCompare:tagAlreadySaved])!=NSOrderedSame) {
                                NSLog(@"Pero no son iguales!!!");
                                // El tag no existe
                                [tagsToAdd addObject:bookTag];
                                break;
                            } else {
                                NSLog(@"YA EXISTE!!!");
                            }
                        }
                    }
                }
                
                [self.arrayOfTags addObjectsFromArray:tagsToAdd];
                NSLog(@"Añadimos %d elementos a arrayOfTags", [tagsToAdd count]);
                [tagsToAdd removeAllObjects];
                
                /* Si aún no se ha creado el NSMutableArray, lo creamos con el primer libro, sino
                 añadimos el libro al NSMutableArray. */
                [self.arrayOfBooks addObject:book];
            }
            NSLog(@"Longitud del arrayOfTags: %d", [self.arrayOfTags count]);
            NSLog(@"Longitud del arrayOfBooks: %d", [self.arrayOfBooks count]);
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
        }
        
        // Ordenar books
        //[self.arrayOfBooks sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Ordenar tags
        //[self.arrayOfTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return self;
}


-(AGTBook *) primerLibro {
    return [self.arrayOfBooks objectAtIndex:0];
}

-(AGTBook *) randomLibro {
    return [self.arrayOfBooks objectAtIndex:arc4random() % [self.arrayOfBooks count]];
}


-(NSUInteger) booksCount {
    return self.arrayOfBooks.count;
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
    NSArray *array = [self.arrayOfTags copy];
    
    return array;
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



#pragma mark - Utils

-(NSArray*) createArrayFromJSONMultipleString: (NSString *)JSONMultipleString{
    
    NSArray *elements = [JSONMultipleString componentsSeparatedByString:@", "];
    
    return elements;
}



@end