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
#import "AGTSimplePDFViewController.h"
#import "AGTLibraryTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Valor por defecto para el último libro seleccionado
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:LAST_SELECTED_BOOK]) {
        
        // guardamos un valor por defecto
        [def setObject:@[@1, @0]
                forKey:LAST_SELECTED_BOOK];
        [def synchronize];
    }
    
    // Comprobamos si es el primer arranque
    if (![def boolForKey:FIRST_BOOT]) {
        NSLog(@"Primer arranque!!!");
        [def setBool:YES
                forKey:FIRST_BOOT];
        [def synchronize];
    } else {
        NSLog(@"NO ES el primer arranque!!!");
        [def setBool:YES    // --> PARA QUE SIEMPRE SEA EL PRIMER ARRANQUE!!!!!!
        //[def setBool:NO
              forKey:FIRST_BOOT];
        [def synchronize];
    }
    
    // Obtenemos el JSON en formato NSData, ya sea descargándolo o leyéndolo del directorio Documents.
    NSData *jsonData = [self getJSONDependingOnBoot: [def boolForKey:FIRST_BOOT]];
    
    
    // Creamos un modelo de librería
    AGTLibrary *model = [[AGTLibrary alloc] initWithJSON:jsonData];
    
    
    // Controladores
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:[self lastSelectedBookInModel: model]];
    AGTLibraryTableViewController *libTableVC = [[AGTLibraryTableViewController alloc] initWithModel:model
                                                                                               style:UITableViewStylePlain];
    
    
    // Combinadores
    UINavigationController *libNav = [[UINavigationController alloc] initWithRootViewController:libTableVC];
    UINavigationController *bookNav = [[UINavigationController alloc] initWithRootViewController:bookVC];
    
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[libNav, bookNav];
    
    
    // Asignamos delegados
    libTableVC.delegate = bookVC;
    splitVC.delegate = bookVC;
    
    // RISTRA DE TESTS!!!
    
    /*
    NSLog(@"Prueba método 'booksCount': %d", [model booksCount]);
    NSLog(@"Número de tags: %d", [[model tags] count]);
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
    */
    
    
    self.window.rootViewController = splitVC;
    
    
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

-(NSData *) getJSONDependingOnBoot: (BOOL) firstBoot {
    NSData *json;
    // Averiguar la url a la carpeta de Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    // Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:@"books_readable.json"];
    NSError *err = nil;
    
    if (firstBoot) {
        NSLog(@"Descargamos y leemos el json");
        // Descargamos el JSON y lo guardamos en Documents de mi Sandbox
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        
        json = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&err];
        json = [self downloadExtrasAndChangeToLocal: json];
        
        if (json != nil) {
            
            BOOL rc = [json writeToURL:url
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
        // Leemos el JSON del directorio Documents
        NSLog(@"Leemos el json del directorio Documents");
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
    NSLog(@"Entramos en downloadExtrasAndChangeToLocal método");
    NSError *err = nil;
    NSData  *modifiedJson;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:json
                                                            options:kNilOptions
                                                              error:&err];
    
    NSMutableArray *modifiedJSONArray = [[NSMutableArray  alloc] init];
    //NSMutableArray *modifiedJSONArray = [NSMutableArray arrayWithArray:JSONArray];
    
    // Averiguar la url a la carpeta Documents.
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *documentsUrl = [urls lastObject];
    //NSLog(@"url antes de entrar en el bucle del dict: %@", documentsUrl);
    
    if (JSONArray != nil) {
        // Para cada libro ....
        for(NSDictionary *dict in JSONArray){
            
            // 0) Copiamos el NSDictionary en un NSMutableDictionary
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            
            // 1)Accedemos al componente urlPortada, la descargamos y modificamos la url del json por la local
            
            // 1.1) Descargamos la imagen del libro en un NSData.
            NSData *downloadedImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]]
                                                                options:kNilOptions
                                                                  error:&err];
            
            // 1.2) Añadir el componente del nombre del fichero
            NSURL *imageLocalUrl = [documentsUrl URLByAppendingPathComponent:[[dict objectForKey:@"image_url"]lastPathComponent]];
            
            //NSLog(@"url de la imagen local: %@", imageLocalUrl);
            
            
            // 1.3) Guardamos la imagen en la carpeta y comprobamos que no devuelve error.
            BOOL rc = [downloadedImageData writeToURL:imageLocalUrl
                                              options:NSDataWritingAtomic
                                                error:&err];
            if (rc == NO) {
                // Error!
                NSLog(@"Error al guardar la imagen descargada: %@", err.localizedDescription);
            }
            
            
            // 1.4) Actualizamos la url de la imagen en el JSON por la url local de la imagen.
            /*[mutDict setObject:[NSString stringWithContentsOfURL:imageLocalUrl
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil] forKey:@"image_url"];*/
            [mutDict setObject:[imageLocalUrl path] forKey:@"image_url"];
            
            //NSLog(@"url de la imagen descargada: %@", [mutDict objectForKey:@"image_url"]);
            
            // 2) Añadimos el diccionario modificado al NSMutableArray
            [modifiedJSONArray addObject:mutDict];
        }
    }else{
        // Se ha producido un error al parsear el JSON
        NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
    }
    
    // Convertir el NSMutableDictionary en JSON
    modifiedJson = [NSJSONSerialization dataWithJSONObject:[NSArray arrayWithArray: modifiedJSONArray]
                                                   options:kNilOptions
                                                     error:&err];
    
    if (modifiedJson == nil) {
        NSLog(@"Error al crear el modifiedJson: %@", err.localizedDescription);
    }
    
    return modifiedJson;
}


-(AGTBook *) lastSelectedBookInModel: (AGTLibrary *) library{
    
    // Obtengo el NSUserDefaults
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // Saco las coordenadas del último libro seleccionado
    NSArray *coords = [def objectForKey:LAST_SELECTED_BOOK];
    NSUInteger section = [[coords objectAtIndex:0] integerValue];
    NSUInteger pos = [[coords objectAtIndex:1] integerValue];
    
    
    // Obtengo el libro
    AGTBook *book = [library bookForTag:[[library tags] objectAtIndex:section]
                                atIndex:pos];
    
    // Lo devuelvo
    return book;
    
}

@end
