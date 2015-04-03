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
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // Comprobamos si existen los favoritos
    if (![def objectForKey:FAVORITES_DICTIONARY]) {
        
        // guardamos un valor por defecto
        [def setObject:[[NSDictionary alloc] init]
                forKey:FAVORITES_DICTIONARY];
        [def synchronize];
    }
    
    BOOL isFirstBoot=NO;
    // Comprobamos si es el primer arranque
    if (![def boolForKey:FIRST_BOOT]) {
        NSLog(@"Primer arranque!!!");
        [def setBool:YES
                forKey:FIRST_BOOT];
        [def synchronize];
        isFirstBoot = YES;
    }
    
    // Valor por defecto para el último libro seleccionado
    if (![def objectForKey:LAST_SELECTED_BOOK]) {
        
        // guardamos un valor por defecto
        [def setObject:@[@1, @0]
                forKey:LAST_SELECTED_BOOK];
        [def synchronize];
    }
    
    // Obtenemos el JSON en formato NSData, ya sea descargándolo o leyéndolo del directorio Documents.
    NSData *jsonData = [self getJSONDependingOnBoot: isFirstBoot];
    
    
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
    NSURL *documentsUrl = [urls lastObject];
    
    // Añadir el componente del nombre del fichero
    NSError *err = nil;
    
    // Si es el primer arranque ...
    if (firstBoot) {
        // ... descargamos el JSON y lo guardamos en Documents de mi Sandbox
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        json = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&err];
        
        [self downloadJSONAndImages: json
               inDocumentsDirectory:[urls lastObject]];
        
        if (json == nil) {
            NSLog(@"Error al descargar datos del servidor: %@", err.localizedDescription);
        }
        
    // ... y si no es el primer arranque....
    } else {
        NSLog(@"Leemos el json del disco");
        // Obtenemos el json del disco duro.
        /*json = [NSData dataWithContentsOfURL:[documentsUrl URLByAppendingPathComponent:@"books_readable.json"]
                                     options:NSDataReadingMappedIfSafe
                                       error:&err];*/
        json = [fm contentsAtPath:[[documentsUrl URLByAppendingPathComponent:@"books_readable.json"] path]];
        if (json == nil) {
            NSLog(@"Error al leer: %@", err.localizedDescription);
        }
    }
    
    return json;
}


-(void) downloadJSONAndImages: (NSData *) json inDocumentsDirectory: (NSURL *) documentsUrl {
    
    // Guardamos el json en el disco
    [self saveData:json toDocumentDirectory:[documentsUrl URLByAppendingPathComponent:@"books_readable.json"]];
    NSError *err = nil;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:json
                                                            options:kNilOptions
                                                              error:&err];
    if (JSONArray != nil) {
        // Para cada libro ....
        for(NSDictionary *dict in JSONArray){
            
            // Descargamos la imagen y la guardamos en en el disco.
            NSData *downloadedImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]]
                                                                options:kNilOptions
                                                                  error:&err];
            
            NSURL *imageLocalUrl = [documentsUrl URLByAppendingPathComponent:[[dict objectForKey:@"image_url"]lastPathComponent]];
            [self saveData:downloadedImageData toDocumentDirectory:imageLocalUrl];
        }
    }else{
        NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
    }
}


-(void) saveData: (NSData *) data toDocumentDirectory: (NSURL *) directory{
    NSError *err;
    BOOL result = [data writeToURL:directory
                         options:NSDataWritingAtomic
                           error:&err];
    if (result == NO) {
        NSLog(@"Error al guardar la imagen descargada: %@", err.localizedDescription);
    }
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
    
    /* En el caso de que tuviéramos seleccionado el último libro en la sección 
     de favoritos y lo desmarcamos como favorito, la sección se quedaría vacía.
     Si en ese momento salimos de la app, ésta guarda esa posición como la del
     último libro consultado. Así que al volver a arrancar, no mostraría ningún
     libro porque ya no existe ningún libro en esa posición (book == nil). Es 
     por ese motivo que obtendremos el primer libro de la primera sección posterior
     a la de 'Favorites'.*/
    while (book==nil) {
        section+=1;
        pos=0;
        book = [library bookForTag:[[library tags] objectAtIndex:section]
                           atIndex:pos];
    }
    
    // Lo devuelvo
    return book;
    
}

@end
