//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Mixi on 26/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTBookViewController.h"
#import "AGTLibrary.h"
#import "Settings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Obtenemos el JSON en formato NSData, ya sea descargándolo o leyéndolo del directorio Documents.
    NSData *jsonData = [self getJSONForModel];
    
    // Creamos un modelo de librería
    AGTLibrary *model = [[AGTLibrary alloc] initWithJSON:jsonData];
    
    //AGTBook *testBook = [model primerLibro];
    AGTBook *testBook = [model randomLibro];
    
    // Controladores
    //AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:testBook];
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:testBook];
    
    //NSLog(@"Los tags son: %@", [[model tags] componentsJoinedByString:@", "]);
    //NSLog(@"Libros con el tag python: %d", [model bookCountForTag:@"python"]);
    
    NSLog(@"Prueba método 'booksCount': %d", [model booksCount]);
    NSLog(@"Prueba método 'tags': %@", [[model tags] componentsJoinedByString:@", "]);
    NSLog(@"Prueba método 'bookCountForTag: alrorithms': %d", [model bookCountForTag:@"algorithms"]);
    NSArray *arrayDeLibrosOrdenado = [model booksForTag:@"algorithms"];
    NSLog(@"Prueba método 'booksForTag: algorithms'");
    for (AGTBook *each in arrayDeLibrosOrdenado) {
        NSLog(@"Libro: %@", each.title);
    }
    AGTBook *libro = [model bookForTag:@"algorithms"
                               atIndex:4];
    NSLog(@"Prueba método 'booksForTag: algorithms atIndex: 0' %@", libro.title);
    

    
    self.window.rootViewController = bookVC;
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma marks - Utils

-(NSData *) getJSONForModel {
    NSData *json;
    // Averiguar la url a la carpeta de Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    // Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:@"books_readable.json"];
    NSError *err = nil;
    
    // Comprobamos si arrancamos la aplicación por primera vez
    // Si arrancamos por primera vez....
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:FIRST_BOOT]) {
        NSLog(@"Primer arranque!!!");
        [defaults setObject:@"1" forKey:FIRST_BOOT];
        [defaults synchronize];
        
        // Descargamos el JSON y lo guardamos en Documents de mi Sandbox
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        
        json = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&err];
        //NSData *modifiedJson = [self downloadExtrasAndChangeToLocal: json];
        //if (modifiedJson != nil) {
        if (json != nil) {
            
            BOOL rc = [json writeToURL:url
            //BOOL rc = [modifiedJson writeToURL:url
                               options:NSDataWritingAtomic
                                 error:&err];
            
            // Comprobar que se guardó
            if (rc == NO) {
                // Error!
                NSLog(@"Error al guardar: %@", err.localizedDescription);
            }
        } else {
            
            // Error al descargar los datos del servidor
            NSLog(@"Error al descargar datos del servidor: %@", err.localizedDescription);
        }
    // ... y si no es el primer arranque....
    } else {
        NSLog(@"NO ES EL Primer arranque!!!");
        // Leemos el JSON del directorio Documents
        json = [NSData dataWithContentsOfURL:url
                                     options:NSDataReadingMappedIfSafe
                                       error:&err];
        // Comprobar que se leyó
        if (json == nil) {
            // Error!
            NSLog(@"Error al leer: %@", err.localizedDescription);
        }
    }
    
    return json;
}


-(NSData *) downloadExtrasAndChangeToLocal: (NSData *) json {
    NSError *err = nil;
    NSData  *modifiedJson;
    NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:json
                                                            options:kNilOptions
                                                              error:&err];
    
    NSMutableArray *modifiedJSONObjects = [[NSMutableArray alloc] initWithCapacity:[JSONObjects count]];
    
    // Averiguar la url a la carpeta de Application Support.
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory//NSApplicationSupportDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    if (JSONObjects != nil) {
        // Para cada libro ....
        for(NSDictionary *dict in JSONObjects){
            
            // 0) Copiamos el NSDictionary en un NSMutableDictionary
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            
            // 1)Accedemos al componente urlPortada, la descargamos y modificamos la url del json por la local
            
            // 1.1) Descargamos la imagen del libro en un NSData.
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]]];
            NSURLResponse *response = [[NSURLResponse alloc] init];
            NSData *downloadedData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&err];
            
            // 1.2) Añadir el componente del nombre del fichero
            url = [url URLByAppendingPathComponent:[[dict objectForKey:@"image_url"]lastPathComponent]];
            
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
            [mutDict setObject:[NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&err] forKey:@"image_url"];
            
            NSLog(@"local_image_url: %@", url);
            
            
            /* DESCARGAREMOS EL PDF CUANDO ACCEDAMOS A LA LISTA DE LECTURA DEL PDF
             
            // 2) Accedemos al componente urlPDF, la descargamos y modificamos la url del json por la local
            
            // 2.1) Descargamos la imagen del libro en un NSData.
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"pdf_url"]]];
            response = [[NSURLResponse alloc] init];
            downloadedData = [NSURLConnection sendSynchronousRequest:request
                                                            returningResponse:&response
                                                                        error:&err];
            
            // 2.2) Añadir el componente del nombre del fichero
            url = [url URLByAppendingPathComponent:[[dict objectForKey:@"pdf_url"]lastPathComponent]];
            
            // 2.3) Guardamos la imagen en la carpeta y comprobamos que no devuelve error.
            rc = [downloadedData writeToURL:url
                                    options:NSDataWritingAtomic
                                      error:&err];
            if (rc == NO) {
                // Error!
                NSLog(@"Error al guardar el pdf descargado: %@", err.localizedDescription);
            }
            
            // 1.4) Actualizamos la url del pdf en el JSON por la url local.
            [mutDict setObject:[NSString stringWithContentsOfURL:url
                                                        encoding:NSUTF8StringEncoding
                                                           error:&err] forKey:@"pdf_url"];
            
            NSLog(@"local_pdf_url: %@", url);
            */
            
            // 3) Añadimos el diccionario modificado al NSMutableArray
            [modifiedJSONObjects addObject:mutDict];
        }
    }else{
        // Se ha producido un error al parsear el JSON
        NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
    }
    
    // Convertir el NSMutableDictionary en JSON
    modifiedJson = [NSJSONSerialization dataWithJSONObject:modifiedJSONObjects
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&err];
    
    return modifiedJson;
}

@end
