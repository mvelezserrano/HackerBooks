//
//  AGTBookViewController.m
//  HackerBooks
//
//  Created by Mixi on 27/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTBook.h"
#import "AGTBookViewController.h"
#import "AGTSimplePDFViewController.h"
#import "Settings.h"

@interface AGTBookViewController ()

@end

@implementation AGTBookViewController

- (id)initWithModel:(AGTBook *)model {
    
    // Cargar un xib u otro según el dispositivo
    // la macro IS_IPHONE la hemos definido en el fichero Settings.h
    NSString *nibName = nil;
    if (IS_IPHONE) {
        nibName = @"AGTBookViewControlleriPhone";
    }
    
    if (self = [super initWithNibName:nibName
                               bundle:nil]) {
        _model = model;
        self.title = model.title;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /* Asegurarse de que no se ocupa toda la pantalla cuando
     estás en un combinador */
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    if (IS_IPHONE) {
        [self addViewWithProperFrameForOrientation: @"landscape"];
        [self addViewWithProperFrameForOrientation: @"portrait"];
    
        // si estamos en landscape, añadimos la vista que tenemos para landscape
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            NSLog(@"Al cargar... detecta que estamos en horizontal");
            //[self addViewWithProperFrameForOrientation: @"landscape"];
            self.landscapeView.hidden = NO;
            self.portraitView.hidden = YES;
        } else {
            NSLog(@"Al cargar... detecta que estamos en vertical");
            //[self addViewWithProperFrameForOrientation: @"portrait"];
            self.landscapeView.hidden = YES;
            self.portraitView.hidden = NO;
        }
    }
    
    // Sincronizar modelo --> vista
    [self syncViewToModel];
    
    // Si estoy dentro de un splitVC me pongo el botón
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
        NSLog(@"Rotamos a vertical.");
        // estamos en portrait
        //[self.landscapeView removeFromSuperview];
        //[self addViewWithProperFrameForOrientation: @"portrait"];
        self.landscapeView.hidden = YES;
        self.portraitView.hidden = NO;
    }
    else {
        NSLog(@"Rotamos a horizontal.");
        // estamos en landscape
        //[self.portraitView removeFromSuperview];
        //[self addViewWithProperFrameForOrientation: @"landscape"];
        self.landscapeView.hidden = NO;
        self.portraitView.hidden = YES;
    }
}

- (void)addViewWithProperFrameForOrientation: (NSString *) orientation{
    // asignamos el frame a la vista en portrait para que se redimensione
    // si la añadimos directamente como view, al no estar dentro de un VC, no se va a redimensionar
    CGRect iPhoneScreen = [[UIScreen mainScreen] bounds];
    
    
    if ([orientation  isEqual: @"portrait"]) {
        NSLog(@"Estamos en vertical");
        CGRect portraitRect = CGRectMake(0, 0, iPhoneScreen.size.width, iPhoneScreen.size.height);
        self.portraitView.frame = portraitRect;
        [self.view addSubview:self.portraitView];
    } else {
        NSLog(@"Estamos en horizontal");
        CGRect landscapeRect = CGRectMake(0, 0, iPhoneScreen.size.height, iPhoneScreen.size.width);
        self.landscapeView.frame = landscapeRect;
        [self.view addSubview:self.landscapeView];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void) syncViewToModel {
    
    self.title = self.model.title;
    self.bookImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.model.imageURL]];
    self.bookTitle.text = self.model.title;
    self.bookAuthors.text = self.model.authors;
    self.bookTags.text = self.model.tags;
    
    if (self.model.isFavorite) {
        [self.favoriteSwitch setOn:YES];
    } else {
        [self.favoriteSwitch setOn:NO];
    }
    
    self.bookTitle.numberOfLines = 0;
    [self.bookTitle sizeToFit];
    
    self.bookAuthors.numberOfLines = 0;
    [self.bookAuthors sizeToFit];
    
    self.bookTags.numberOfLines = 0;
    [self.bookTags sizeToFit];
    
    // Modo Apaisado
    self.title = self.model.title;
    self.bookImageLandscape.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.model.imageURL]];
    self.bookTitleLandscape.text = self.model.title;
    self.bookAuthorsLandscape.text = self.model.authors;
    self.bookTagsLandscape.text = self.model.tags;
    
    if (self.model.isFavorite) {
        [self.favoriteSwitchLandscape setOn:YES];
    } else {
        [self.favoriteSwitchLandscape setOn:NO];
    }

    self.bookTitleLandscape.numberOfLines = 0;
    [self.bookTitleLandscape sizeToFit];
    
    self.bookAuthorsLandscape.numberOfLines = 0;
    [self.bookAuthorsLandscape sizeToFit];
    
    self.bookTagsLandscape.numberOfLines = 0;
    [self.bookTagsLandscape sizeToFit];
}


#pragma marks - Actions

- (IBAction)displayPDF:(id)sender {
    
    // Creamos un PDFvC
    AGTSimplePDFViewController *pdfVC = [[AGTSimplePDFViewController alloc] initWithModel:self.model];
    
    // Hacemos push
    [self.navigationController pushViewController:pdfVC
                                         animated:YES];
}


- (IBAction)setFavorite:(id)sender {
    
    if ([sender isOn]) {
        self.model.isFavorite = YES;
    } else {
        self.model.isFavorite = NO;
    }
    
    // Mandamos una notificación por el cambio de favorito
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{BOOK_KEY : self.model};
    
    NSNotification *n = [NSNotification notificationWithName:BOOK_FAVORITE_NOTIFICATION_NAME
                                                      object:self
                                                    userInfo:dict];
    [nc postNotification:n];
}


#pragma mark - UISplitViewControllerDelegate

- (void) splitViewController:(UISplitViewController *)svc
     willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    // Averiguar si la tabla se va a ver o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // La tabla está oculta y cuelga del botón: Ponemos ese botón en mi barra de navegación.
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    } else {
        // Se muestra la tabla: Oculto el botón de la barra de navegación.
        self.navigationItem.leftBarButtonItem = nil;
    }
}



#pragma mark - AGTLibraryTableViewControllerDelegate

- (void) libraryTableViewController: (AGTLibraryTableViewController *) libVC
                      didSelectBook: (AGTBook *) book {
    
    // Actualizo el modelo
    self.model = book;
    
    // Sincronizo modelo --> vista(s);
    [self syncViewToModel];
}



#pragma mark - Utils

- (NSString *)arrayToString:(NSArray *)array
{
    NSString *repr;
    
    if ([array count] == 1) {
        repr = [array lastObject];
    }
    else {
        repr = [[array componentsJoinedByString:@", "] stringByAppendingString:@"."];
    }
    
    return repr;
}


@end
