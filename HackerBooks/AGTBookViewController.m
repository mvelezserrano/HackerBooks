//
//  AGTBookViewController.m
//  HackerBooks
//
//  Created by Mixi on 27/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)syncViewToModel {
    self.bookImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: self.model.imageURL]]];
    self.bookTitle.text = self.model.title;
    self.bookAuthors.text = self.model.authors;
    self.bookTags.text = self.model.tags;
}


#pragma marks - Actions

- (IBAction)displayPDF:(id)sender {
    
    // Creamos un PDFvC
    AGTSimplePDFViewController *pdfVC = [[AGTSimplePDFViewController alloc] initWithModel:self.model];
    
    // Hacemos push
    [self.navigationController pushViewController:pdfVC
                                         animated:YES];
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
