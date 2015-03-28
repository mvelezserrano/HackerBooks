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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Creamos un modelo
    //AGTLibrary *model = [[AGTLibrary alloc] init];
    AGTBook *testBook = [[AGTBook alloc] initWithTitle:@"Título"
                                               authors:@[@"Autor 1", @"Autor 2"]
                                                  tags:@[@"Tag 1", @"Tag 2"]
                                              imageURL:@"http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg"
                                                pdfURL:@"https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf"];
    
    
    // Controladores
    //AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:[model primerLibro]];
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:testBook];

    
    NSLog(@"URL: %@", testBook.imageURL);
    
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

@end
