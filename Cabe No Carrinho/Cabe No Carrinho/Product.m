//
//  Product.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.uuid = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
        self.url = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        self.averagePrice = [NSNumber numberWithDouble:[[dictionary objectForKey:@"average_price"] doubleValue]];
    }
    return self;
}

@end
