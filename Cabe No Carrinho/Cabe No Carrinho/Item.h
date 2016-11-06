//
//  Item.h
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Item : NSObject

@property (assign, nonatomic) NSInteger quantity;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) Product *product;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)jsonDictionary;
- (instancetype)initWithProduct:(Product *)product;

@end
