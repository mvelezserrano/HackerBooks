//
//  AGTLibraryTableViewController.m
//  HackerBooks
//
//  Created by Mixi on 31/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTLibraryTableViewController.h"
#import "AGTBook.h"
#import "AGTLibrary.h"
#import "AGTBookViewController.h"
#import "Settings.h"
#import "AGTBookTableViewCell.h"

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

- (id) initWithModel: (AGTLibrary *) model
               style: (UITableViewStyle) style {
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = @"AGT Library";
        
        // Alta en notificación
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(notifyThatFavoriteChange:)
                   name:BOOK_FAVORITE_NOTIFICATION_NAME
                 object:nil];
        [nc addObserver:self
               selector:@selector(notifyThatPDFDownloaded:)
                   name:BOOK_DOWNLOADED
                 object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"AGTBookTableViewCell"
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[AGTBookTableViewCell cellId]];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}


- (void) dealloc {
    
    // Me doy de baja de las notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Tantas secciones como tags más una de favoritos.
    return [[self.model tags] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    /* Para saber el número de filas que habrá en cada sección, hacemos un count 
     del número de libros que tienen ese tag.*/
    return [[self.model booksForTag:[[self.model tags] objectAtIndex:section]] count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Averiguar de qué libro estamos hablando
    AGTBook *book = [self.model bookForTag:[[self.model tags] objectAtIndex:indexPath.section]
                                   atIndex:indexPath.row];
    
    //NSLog(@"Section: %d, Row: %d", indexPath.section, indexPath.row);
    
    // Crear una celda
    static NSString *cellId = @"BookCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        // La tenemos que crear nosotros desde cero
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellId];
    }

    
    // Sincronizar modelo (libro) --> vista (celda)
    cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:book.imageURL]];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.authors;
    
    
    // Devolvemos la celda
    return cell;
}
*/

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Averiguar de qué libro estamos hablando
    AGTBook *book = [self.model bookForTag:[[self.model tags] objectAtIndex:indexPath.section]
                                   atIndex:indexPath.row];
    
    // Crear una celda
    AGTBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AGTBookTableViewCell cellId]
                                                            forIndexPath:indexPath];
    
    // Sincronizar modelo (libro) --> vista (celda)
    if (book.downloaded) {
        cell.bookIcon.image = [UIImage imageNamed:@"open_book.png"];
    } else {
        cell.bookIcon.image = [UIImage imageNamed:@"closed_book.png"];
    }
    
    cell.bookTitle.text = book.title;
    cell.bookAuthors.text = book.authors;
    
    return cell;
}





- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.model tags] objectAtIndex:section];
}



#pragma mark - Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // Averiguar de qué libro me están hablando.
    AGTBook *book = [self.model bookForTag:[[self.model tags] objectAtIndex:indexPath.section]
                                   atIndex:indexPath.row];
    
    // Avisar al delegado (siempre y cuando entienda el mensaje).
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        // Si que lo entiende, lo mandamos...
        [self.delegate libraryTableViewController:self
                                didSelectBook:book];
    }
    
    // Mandamos una notificación
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{BOOK_KEY : book};
    
    NSNotification *n = [NSNotification notificationWithName:BOOK_DID_CHANGE_NOTIFICATION_NAME
                                                      object:self
                                                    userInfo:dict];
    [nc postNotification:n];
    
    
    // Guardamos las coordenadas del último libro seleccionado
    NSArray *coords = @[@(indexPath.section), @(indexPath.row)];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:coords
            forKey:LAST_SELECTED_BOOK];
    [def synchronize];
}


#pragma mark - AGTUniverseTableViewControllerDelegate

- (void) libraryTableViewController: (AGTLibraryTableViewController *) libVC
                      didSelectBook: (AGTBook *) book {
    
    // Creamos un AGTBookViewController
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:book];
    
    // Hago un push
    [self.navigationController pushViewController:bookVC
                                         animated:YES];
}


#pragma mark - Notifications

// BOOK_FAVORITE_NOTIFICATION_NAME     --> Para saber los métodos que reciben esta notificación.
- (void) notifyThatFavoriteChange:(NSNotification *) notification {
    
    // Sacamos el libro cambiado
    AGTBook *book = [notification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizar la librería añadiendo el libro al tag 'Favorite'
    [self.model setBookFavorite:book];
    
    // Recargar la tabla
    [self.tableView reloadData];
    
}


// BOOK_DOWNLOADED
- (void) notifyThatPDFDownloaded: (NSNotification *) notification {
    
    // Recargar la tabla
    [self.tableView reloadData];
}





@end
