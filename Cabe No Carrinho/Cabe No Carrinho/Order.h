//
//  Order.h
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusOrdered = 0,
    OrderStatusBuying,
    OrderStatusBought,
    OrderStatusDelivered
};

@interface Order : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger reward;
@property (assign, nonatomic) OrderStatus status;
@property (strong, nonatomic) NSArray <Item *> *items;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)jsonDictionary;

@end
