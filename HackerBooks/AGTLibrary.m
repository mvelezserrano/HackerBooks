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
        
        /*if ([[NSJSONSerialization JSONObjectWithData:json
                                             options:kNilOptions
                                               error:&error] isKindOfClass:[NSArray class]]) {
            //NSLog(@"Es un NSArray!");
        } else {
            //NSLog(@"Es un NSDictionary!");
        }*/
        
        NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData:json
                                                                options:kNilOptions
                                                                  error:&error];
        if (JSONObjects != nil) {
            // No ha habido error
            for(NSDictionary *dict in JSONObjects){
                //AGTBook *book = [[AGTBook alloc] initWithDictionary:dict];
                
                AGTBook *book = [[AGTBook alloc] initWithTitle:[dict objectForKey:@"title"]
                                                       authors:[dict objectForKey:@"authors"]
                                                          tags:[dict objectForKey:@"tags"]
                                                      imageURL:[dict objectForKey:@"image_url"]
                                                      //imageURL:[self downloadImageAndChangeURL:[dict objectForKey:@"image_url"]]
                                                        pdfURL:[dict objectForKey:@"pdf_url"]];
                
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
            }
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
        }
        
        // Ordenar books
        [self.arrayOfBooks sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Ordenar tags
        [self.arrayOfTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // Añadimos tag favorite como el primero de todos.
        [self.arrayOfTags insertObject:@"Favorites"
                               atIndex:0];
    }
    
    return self;
}

- (NSString *) downloadImageAndChangeURL: (NSString *) imageURL {
    
    NSError *err = nil;
    
    // Averiguar la url a la carpeta Documents.
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    // 0) Copiamos el NSDictionary en un NSMutableDictionary
    //NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    
    // 1)Accedemos al componente urlPortada, la descargamos y modificamos la url del json por la local
    
    // 1.1) Descargamos la imagen del libro en un NSData.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *downloadedData = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response
                                                               error:&err];
    
    // 1.2) Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:[imageURL lastPathComponent]];
    
    NSLog(@"local_image_url: %@", url);
    
    // 1.3) Guardamos la imagen en la carpeta y comprobamos que no devuelve error.
    BOOL rc = [downloadedData writeToURL:url
                                 options:NSDataWritingAtomic
                                   error:&err];
    if (rc == NO) {
        // Error!
        NSLog(@"Error al guardar la imagen descargada: %@", err.localizedDescription);
    }
    
    // 1.4) Actualizamos la url de la imagen en el JSON por la url local de la imagen.
    /*[mutDict setObject:[NSString stringWithContentsOfURL:url
                                                encoding:NSUTF8StringEncoding
                                                   error:&err] forKey:@"image_url"];
    */
    
    
    return [NSString stringWithContentsOfURL:url
                                    encoding:NSUTF8StringEncoding
                                       error:&err];
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




@end