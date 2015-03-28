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
    
    NSData *jsonData = [self getJSONForModel];
    
    
    
    
    // Creamos un modelo
    AGTLibrary *model = [[AGTLibrary alloc] init];
    
    AGTBook *testBook = [model primerLibro];
    
    // Controladores
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:testBook];

    
    NSLog(@"URL: %@", testBook.imageURL);
    NSLog(@"Número de libros en el array: %d", [model booksCount]);
    
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
    // Averiguar la url a la carpeta de caches
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
        
        [defaults setObject:@"1" forKey:FIRST_BOOT];
        [defaults synchronize];
        
        // Descargamos el JSON y lo guardamos en Documents de mi Sandbox
        json = [self downloadJSON];
        BOOL rc = [json writeToURL:url
                           options:NSDataWritingAtomic
                             error:&err];
        
        // Comprobar que se guardó
        if (rc == NO) {
            // Error!
            NSLog(@"Error al guardar: %@", err.localizedDescription);
        }
        
    // ... y si no es el primer arranque....
    } else {
        
        // Leemos el JSON del directorio Documents
        NSData *readData = [NSData dataWithContentsOfURL:url
                                                 options:NSDataReadingMappedIfSafe
                                                   error:&err];
        // Comprobar que se leyó
        if (readData == nil) {
            // Error!
            NSLog(@"Error al leer: %@", err.localizedDescription);
        } else {
            NSLog(@"Hemos leido: %@", [[NSString alloc] initWithData:readData
                                                            encoding:NSUTF8StringEncoding]);
        }
    }
    
    return json;
}

-(NSData *) downloadJSON {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return data;
}

@end
