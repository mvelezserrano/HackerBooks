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
@property (strong, nonatomic) NSMutableArray *arrayOfUpdatedBookDicts;

@property (nonatomic) int contadorLibros;

@end

@implementation AGTLibrary

#pragma mark - Init

-(id) initWithJSON: (NSData *) json {
    if (self = [super init]) {
        self.arrayOfBooks = [[NSMutableArray alloc] init];
        self.arrayOfTags = [[NSMutableArray alloc] init];
        self.dictionaryOfTags = [[NSMutableDictionary alloc] init];
        
        NSError *err;
        
        NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:json
                                                                options:kNilOptions
                                                                  error:&err];
        // Averiguar la url a la carpeta de Application Support.
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                                   inDomains:NSUserDomainMask];
        NSURL *documentsUrl = [urls lastObject];
        
        
        if (JSONObjects != nil) {
            // No ha habido error
            for(NSDictionary *dict in JSONObjects){
                //AGTBook *book = [[AGTBook alloc] initWithDictionary:dict];
                
                /*
                // Create an NSData object from the contents of the given URL.
                NSData *downloadedImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]]
                                                               options:kNilOptions
                                                                 error:&err];
                
                // 1.2) Añadir el componente del nombre del fichero
                NSURL *imageLocalUrl = [documentsUrl URLByAppendingPathComponent:[[dict objectForKey:@"image_url"]lastPathComponent]];
                
                // 1.3) Guardamos la imagen en la carpeta y comprobamos que no devuelve error.
                BOOL rc = [downloadedImageData writeToURL:imageLocalUrl
                                                  options:NSDataWritingAtomic
                                                    error:&err];
                if (rc == NO) {
                    // Error!
                    NSLog(@"Error al guardar la imagen descargada: %@", err.localizedDescription);
                }
                */
                 
                NSLog(@"url de la imagen descargada: %@", [NSURL URLWithString:[dict objectForKey:@"image_url"]]);
                
                 
                AGTBook *book = [[AGTBook alloc] initWithTitle:[dict objectForKey:@"title"]
                                                       authors:[dict objectForKey:@"authors"]
                                                          tags:[dict objectForKey:@"tags"]
                                                      //imageURL: imageLocalUrl
                                                      imageURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]]
                                                        pdfURL:[dict objectForKey:@"pdf_url"]];
                self.contadorLibros+=1;
                
                [self.arrayOfBooks addObject:book];
                
                NSArray *bookTags = [self createArrayFromJSONMultipleString:[dict objectForKey:@"tags"]];

                for (NSString *bookTag in bookTags) {
                    if (![self.dictionaryOfTags objectForKey:bookTag]) {
                        
                        // Guardamos en un diccionario un array de libros con la key del tag
                        NSArray *tagBookArray = @[book];
                        [self.dictionaryOfTags setObject:tagBookArray
                                                  forKey:bookTag];
                        [self.arrayOfTags addObject:bookTag];
                    
                    } else {
                        
                        // Añadimos el libro al array de libros con la key del tag.
                        NSMutableArray *arr = [[self.dictionaryOfTags objectForKey:bookTag] mutableCopy];
                        [arr addObject:book];
                        [self.dictionaryOfTags setObject:arr
                                                  forKey:bookTag];
                    }
                }
                
                /*
                NSDictionary *dictBook = [book asJSONDictionary];
                NSLog(@"url de la imagen descargada: %@", [dictBook objectForKey:@"image_url"]);
                
                [self.arrayOfUpdatedBookDicts addObject:dictBook];
                */
            }
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
        }
        
        // Ordenar books
        [self.arrayOfBooks sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Ordenar tags
        [self.arrayOfTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Añadimos tag favorite como el primero de todos.
        [self.arrayOfTags insertObject:@"Favorites"
                               atIndex:0];
        
        //[self updateLocalJSONWithArray: [NSArray arrayWithArray:self.arrayOfUpdatedBookDicts]];
    }
    
    NSLog(@"Total de libros: %d", self.contadorLibros);
    
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
    
    return [[self.dictionaryOfTags objectForKey:tag] count];
}


// Array inmutable (NSArray) de los libros
// (instancias de AGTBook) que hay en
// una temática.
// Un libro puede estar en una o más
// temáticas. Si no hay libros para una
// temática, ha de devolver nil.
-(NSArray *) booksForTag: (NSString *) tag {
    
    NSMutableArray *booksWithTag = [[NSMutableArray alloc] initWithArray:[self.dictionaryOfTags objectForKey:tag]];
    [booksWithTag sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if ([booksWithTag count]==0) {
        return nil;
    } else {
        return [booksWithTag copy];
    }
}


// Un AGTBook para el libro que está en la posición
// 'index' de aquellos bajo un cierto
// tag. Mira a ver si puedes usar el método anterior
// para hacer parte de tu trabajo.
// Si el indice no existe o el tag no existe, ha de devolver nil.
-(AGTBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index {
    
    if ((index>[[self booksForTag:tag] count]-1)||(![self booksForTag:tag])) {
        return nil;
    } else {
        return [[self booksForTag:tag] objectAtIndex:index];
    }
}



#pragma mark - Utils

-(NSArray*) createArrayFromJSONMultipleString: (NSString *)JSONMultipleString{
    
    NSArray *elements = [JSONMultipleString componentsSeparatedByString:@", "];
    
    return elements;
}


-(NSArray *) asJSONArray {
    
    return [self.arrayOfUpdatedBookDicts copy];
}

-(void) updateLocalJSONWithArray: (NSArray *) arrayOfUpdatedBookDicts {
    
    // Averiguar la url a la carpeta de Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    // Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:@"books_readable.json"];
    
    NSError *err;
    NSData *updatedJSON = [NSJSONSerialization dataWithJSONObject:arrayOfUpdatedBookDicts
                                                          options:kNilOptions
                                                            error:&err];
    
    if (updatedJSON != nil) {
        BOOL rc = [updatedJSON writeToURL:url
                                  options:NSDataWritingAtomic
                                    error:&err];
        
        // Comprobar que se guardó
        if (rc == NO) {
            // Error!
            NSLog(@"Error al guardar: %@", err.localizedDescription);
        }
    } else {
        NSLog(@"Error al crear el updatedJSON: %@", err.localizedDescription);
    }
    
    
}



@end