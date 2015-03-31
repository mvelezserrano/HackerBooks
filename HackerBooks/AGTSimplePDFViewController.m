//
//  AGTSimplePDFViewController.m
//  HackerBooks
//
//  Created by Mixi on 31/3/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTSimplePDFViewController.h"
#import "AGTBook.h"


@implementation AGTSimplePDFViewController

-(id) initWithModel:(AGTBook *) model {
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        
        _model = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Asignar delegados!!!!
    self.browser.delegate = self;
    
    /* Asegurarse de que no se ocupa toda la pantalla cuando
     estás en un combinador */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sincronizar modelo --> vista
    [self syncViewToModel];
}


#pragma mark - UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    // Paro y oculto el activityView
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
}





#pragma mark - Utils

- (void)syncViewToModel {
    
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    /*NSError *err = nil;
    //NSLog(@"URl del pdf: %@", self.model.pdfURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.model.pdfURL]];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *downloadedPDF = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:&response
                                                               error:&err];
    
    if (downloadedPDF!=nil) {
        [self.browser loadData:downloadedPDF
                      MIMEType:@"application/pdf"
              textEncodingName:@"utf-8"
                       baseURL:nil];
    } else {
        // Error al descargar los datos del servidor
        NSLog(@"Error al descargar datos del servidor: %@", err.localizedDescription);
    }*/
    
}


@end
