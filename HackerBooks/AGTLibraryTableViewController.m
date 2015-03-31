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

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

- (id) initWithModel: (AGTLibrary *) model
               style: (UITableViewStyle) style {
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = @"AGT Library";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Tantas secciones como tags más una de favoritos.
    //NSLog(@"NumberOfSections: %d", [[self.model tags] count]);
    
    return [[self.model tags] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    /* Buscamos en el array de tags, el NSString del tag que está en la posición 'section - 1',
      ya que la primera sección siempre será 'favoritos'. Para saber el número de filas que habrá
     en esa sección, hacemos un count del número de libros que tienen ese tag.*/
    
    //NSLog(@"Section: %@ , Rows: %d",[[self.model tags] objectAtIndex:section] ,[[self.model booksForTag:[[self.model tags] objectAtIndex:section]] count]);
    
    return [[self.model booksForTag:[[self.model tags] objectAtIndex:section]] count];
}


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
    cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: book.imageURL]]];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.authors;
    
    
    // Devolvemos la celda
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
    
    // Crear el controlador del libro
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithModel:book];
    
    // Hacemos push del controller
    [self.navigationController pushViewController:bookVC
                                         animated:YES];
    
}

@end
