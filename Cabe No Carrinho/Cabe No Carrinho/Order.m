//
//  Order.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "Order.h"

@implementation Order

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.uuid = [dictionary objectForKey:@"id"];
        self.identifier = [dictionary objectForKey:@"name"];
        self.address = [dictionary objectForKey:@"address"];
        self.reward = [[dictionary objectForKey:@"reward"] integerValue];
        self.status = (OrderStatus)[[dictionary objectForKey:@"status"] integerValue];
        NSArray *items = [dictionary objectForKey:@"items"];
        NSMutableArray *tempItems = [NSMutableArray array];
        for (NSDictionary *itemDictionary in items) {
            Item *item = [[Item alloc] initWithDictionary:itemDictionary];
            [tempItems addObject:item];
        }
        self.items = [tempItems copy];
    }
    return self;
}

@end
