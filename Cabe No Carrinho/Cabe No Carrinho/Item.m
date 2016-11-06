//
//  Item.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.quantity = [[dictionary objectForKey:@"quantity"] integerValue];
        self.product = [[Product alloc] initWithDictionary:[dictionary objectForKey:@"product"]];
        self.productId = [dictionary objectForKey:@"product_id"];
    }
    return self;
}

- (NSDictionary *)jsonDictionary {
    return @{@"product_id":self.productId,
             @"quantity":[NSNumber numberWithInteger:self.quantity]};
}

- (instancetype)initWithProduct:(Product *)product {
    self = [super init];
    if (self) {
        self.quantity = 0;
        self.product = product;
        self.productId = product.uuid;
    }
    return self;
}

@end
