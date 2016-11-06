//
//  Product.h
//  CaboNoCarrinho
//
//  Created by Roger Luan on 05/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSNumber *averagePrice;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
