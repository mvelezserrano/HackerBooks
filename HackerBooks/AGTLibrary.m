//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"
#import "Settings.h"

@interface AGTLibrary()

@property (strong, nonatomic) NSMutableArray *arrayOfBooks;
@property (strong, nonatomic) NSMutableArray *arrayOfTags;

@property (strong, nonatomic) NSMutableDictionary *dictionaryOfTags;
@property (strong, nonatomic) NSMutableArray *arrayOfUpdatedBookDicts;

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
        // Averiguar la url a la carpeta Documents.
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                                   inDomains:NSUserDomainMask];
        NSURL *documentsUrl = [urls lastObject];
        
        // Obtener el diccionario con los favoritos en el nsuserdefaults.
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSDictionary *favorites = [def objectForKey:FAVORITES_DICTIONARY];
        
        
        if (JSONObjects != nil) {
            // No ha habido error
            for(NSDictionary *dict in JSONObjects){
                
                // Obtenemos la url local de la carátula del libro ya descargada.
                NSURL *imageLocalUrl = [documentsUrl URLByAppendingPathComponent:[[dict objectForKey:@"image_url"]lastPathComponent]];
                
                // Mirar si es favorito o no.
                BOOL favorite = NO;
                if ([favorites objectForKey:[dict objectForKey:@"title"]]) {
                    favorite = [[favorites objectForKey:[dict objectForKey:@"title"]] boolValue];
                }
                
                // Creamos el AGTBook.
                AGTBook *book = [[AGTBook alloc] initWithTitle:[dict objectForKey:@"title"]
                                                       authors:[dict objectForKey:@"authors"]
                                                          tags:[dict objectForKey:@"tags"]
                                                      imageURL:imageLocalUrl
                                                        pdfURL:[dict objectForKey:@"pdf_url"]
                                                      favorite:favorite];
                
                
                // Añadimos el libro al NSMutableArray de libros 'arrayOfBooks'
                [self.arrayOfBooks addObject:book];
                
                // Convierto el string de tags en un array.
                NSMutableArray *bookTags = [self createArrayFromJSONMultipleString:[dict objectForKey:@"tags"]];
                if (book.isFavorite) {
                    [bookTags addObject:@"Favorites"];
                }
                
                // Para cada tag del libro que estamos tratando...
                for (NSString *bookTag in bookTags) {
                    // Si el tag aún no ha estado catalogado....
                    if (![self.dictionaryOfTags objectForKey:bookTag]) {
                        
                        // Creamos un array que contendrá todos los libros con ese tag, y el cuál
                        // inicializamos con el libro actual al ser el primero que contiene ese tag.
                        NSArray *tagBookArray = @[book];
                        
                        // Guardamos ese array de libros en un diccionario con la key del tag actual
                        [self.dictionaryOfTags setObject:tagBookArray
                                                  forKey:bookTag];
                        
                        // Finalmente añadimos el tag al NSMutableArray 'arrayOfTags' que contiene todos
                        // los tags sin que se repitan.
                        [self.arrayOfTags addObject:bookTag];
                    
                    // Pero si el tag ya ha sido catalogado...
                    } else {
                        
                        
                        // Obtenemos del 'dictionaryOfTags' el array de libros que actualmente tienen
                        // el tag actual, convirtiéndolo en un NSMutableArray.
                        NSMutableArray *arr = [[self.dictionaryOfTags objectForKey:bookTag] mutableCopy];
                        // Añadimos el nuevo libro a ese array de libros.
                        [arr addObject:book];
                        // Finalmente sustituimos el array actual por el actualizado con el nuevo libro.
                        [self.dictionaryOfTags setObject:arr
                                                  forKey:bookTag];
                    }
                }
                
                // Convertimos el libro en un diccionario...
                NSDictionary *dictBook = [book asJSONDictionary];
                
                // ... y lo añadimos al array de diccionarios de libros actualizados.
                [self.arrayOfUpdatedBookDicts addObject:dictBook];
            }
        }else{
            NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
        }
        
        /// Una vez tratados todos los libros de la librería....
        
        // Ordenamos alfabéticamente los libros...
        [self.arrayOfBooks sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Eliminamos el tag 'Favorites' ....
        [self.arrayOfTags removeObject:@"Favorites"];
        
        // Ordenamos alfabéticamente los tags...
        [self.arrayOfTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // ... para añadirlo de nuevo como el primero de todos.
        [self.arrayOfTags insertObject:@"Favorites" atIndex:0];
        
        
        // Añadimos el tag 'Favorite' al dictionaryOfTags en caso de que aún no exista.
        if (![self.dictionaryOfTags objectForKey:@"Favorites"]) {
            [self.dictionaryOfTags setObject:[[NSArray alloc] init] forKey:@"Favorites"];
        }
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

-(NSMutableArray*) createArrayFromJSONMultipleString: (NSString *)JSONMultipleString{
    
    NSMutableArray *elements = [[JSONMultipleString componentsSeparatedByString:@", "] mutableCopy];
    
    return elements;
}


-(NSArray *) asJSONArray {
    
    return [self.arrayOfUpdatedBookDicts copy];
}


-(void) setBookFavorite: (AGTBook *) aBook {
    
    // Obtenemos del 'dictionaryOfTags' el array de libros que actualmente tienen
    // el tag 'Favorite', convirtiéndolo en un NSMutableArray.
    NSMutableArray *arr = [[self.dictionaryOfTags objectForKey:@"Favorites"] mutableCopy];
    
    // Si el libro estaba como favorito, lo quitamos, sino, lo añadimos.
    if (aBook.isFavorite) {
        [arr addObject:aBook];
        //NSLog(@"El libro NO era favorito y lo añadimos...");
    } else {
        [arr removeObject:aBook];
        //NSLog(@"El libro era favorito y lo quitamos...");
    }
    
    // Leo el diccionario de favoritos del NSUserDefaults.
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *favorites = [[def objectForKey:FAVORITES_DICTIONARY] mutableCopy];
    
    // Guardo en el diccionario si un libro es o no favorito.
    [favorites setValue:[NSNumber numberWithBool:aBook.isFavorite]
                 forKey:aBook.title];
    
    // Vuelvo a guardar el diccionario en el NSUserDefaults.
    [def setObject:favorites forKey:FAVORITES_DICTIONARY];
    [def synchronize];
    
    // Finalmente sustituimos el array actual por el actualizado con el nuevo libro.
    [self.dictionaryOfTags setObject:arr
                              forKey:@"Favorites"];
}




@end