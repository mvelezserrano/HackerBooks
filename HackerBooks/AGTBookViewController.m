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

@interface AGTBookViewController ()

@end

@implementation AGTBookViewController

- (id)initWithModel:(AGTBook *)model {
    if (self = [super initWithNibName:nil
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sincronizar modelo --> vista
    [self syncViewToModel];
    
    // Si estoy dentro de un splitVC me pongo el botón
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
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
