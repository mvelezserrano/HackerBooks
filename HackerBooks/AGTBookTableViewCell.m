//
//  AGTBookTableViewCell.m
//  HackerBooks
//
//  Created by Mixi on 4/4/15.
//  Copyright (c) 2015 Mixi. All rights reserved.
//

#import "AGTBookTableViewCell.h"

@implementation AGTBookTableViewCell


+ (NSString *) cellId {
    
    // Devolvemos como Id el identificador de la clase
    return NSStringFromClass(self);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void) prepareForReuse {
    
    // Mensaje que se recibe al reutilizar una celda. Se desinicializa aquí!
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
