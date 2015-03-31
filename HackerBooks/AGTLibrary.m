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

@property (strong, nonatomic) NSMutableDictionary *dictionaryOfTags;

@end

@implementation AGTLibrary

#pragma mark - Init

-(id) initWithJSON: (NSData *) json {
    if (self = [super init]) {
        self.arrayOfBooks = [[NSMutableArray alloc] init];
        self.arrayOfTags = [[NSMutableArray alloc] init];
        self.dictionaryOfTags = [[NSMutableDictionary alloc] init];
        
        
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
                [self.arrayOfBooks addObject:book];
                
                NSArray *bookTags = [self createArrayFromJSONMultipleString:[dict objectForKey:@"tags"]];

                for (NSString *bookTag in bookTags) {
                    if (![self.dictionaryOfTags objectForKey:bookTag]) {
                        
                        // V1) GUARDAMOS EN UN DICCIONARIO EL NÚMERO DE LIBROS CON LA KEY DEL TAG
                        /*[self.dictionaryOfTags setObject:[NSNumber numberWithInteger:1]
                                                  forKey:bookTag];
                        [self.arrayOfTags addObject:bookTag];*/
                        //NSLog(@"Añadimos el tag: %@", bookTag);
                        
                        
                        // V2) GUARDAMOS EN UN DICCIONARIO UN ARRAY DE LIBROS CON LA KEY DEL TAG
                        NSArray *tagBookArray = @[book];
                        [self.dictionaryOfTags setObject:tagBookArray
                                                  forKey:bookTag];
                        [self.arrayOfTags addObject:bookTag];
                    
                    
                    
                    } else {
                        // V1) INCREMENTAMOS EN +1 EL CONTADOR DE TAGS.
                        /*int tempCount = [[self.dictionaryOfTags objectForKey:bookTag] intValue];
                        tempCount++;
                        [self.dictionaryOfTags setObject:[NSNumber numberWithInteger:tempCount]
                                                  forKey:bookTag];*/
                        
                        // V2) AÑADIMOS EL LIBRO AL ARRAY DE LIBROS CON LA KEY DEL TAG.
                        NSMutableArray *arr = [[self.dictionaryOfTags objectForKey:bookTag] mutableCopy];
                        [arr addObject:book];
                        [self.dictionaryOfTags setObject:arr
                                                  forKey:bookTag];
                    }
                }
            }
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
        }
        
        
        
        // Ordenar books
        [self.arrayOfBooks sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSLog(@"Longitud del arrayOfBooks: %d", [self.arrayOfBooks count]);
        /*for (AGTBook *eachBook in self.arrayOfBooks) {
            NSLog(@"Título: %@", eachBook.title);
        }*/
        
        int sumaLibros=0;
        // Ordenar tags
        for (id key in self.dictionaryOfTags) {
            //sumaLibros+=[[self.dictionaryOfTags objectForKey:key] intValue];
            sumaLibros+=[[self.dictionaryOfTags objectForKey:key] count];
            //NSLog(@"El tag: %@ , lo tienen %@ libros", key, [self.dictionaryOfTags objectForKey:key]);
        }
        //NSLog(@"Valor sumaLibros: %d", sumaLibros);
        
                  
        //self.arrayOfTags = [self.dictionaryOfTags allValues];
        [self.arrayOfTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSLog(@"Longitud del arrayOfTags: %d", [self.arrayOfTags count]);

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


// Array inmutable (NSArray) con todas las
// distintas temáticas (tags) en orden alfabético.
// No puede bajo ningún concepto haber ninguna repetida.
-(NSArray *) tags {
    
    return [self.arrayOfTags copy];
}


// Cantidad de libros que hay en una temática.
// Si el tag no existe, debe de devolver cero
-(NSUInteger) bookCountForTag:(NSString*) tag {
    
    /*if ([[self.dictionaryOfTags objectForKey:tag] integerValue]) {
        return [[self.dictionaryOfTags objectForKey:tag] integerValue];
    } else {
        return 0;
    }*/
    
    return [[self.dictionaryOfTags objectForKey:tag] count];
}


// Array inmutable (NSArray) de los libros
// (instancias de AGTBook) que hay en
// una temática.
// Un libro puede estar en una o más
// temáticas. Si no hay libros para una
// temática, ha de devolver nil.
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
    
    NSMutableArray *booksWithTag = [[NSMutableArray alloc] init];
    
    /*for (AGTBook *each in self.arrayOfBooks) {
        <#statements#>
    }*/
    
    return [booksWithTag copy];
}


// Un AGTBook para el libro que está en la posición
// 'index' de aquellos bajo un cierto
// tag. Mira a ver si puedes usar el método anterior
// para hacer parte de tu trabajo.
// Si el indice no existe o el tag no existe, ha de devolver nil.
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