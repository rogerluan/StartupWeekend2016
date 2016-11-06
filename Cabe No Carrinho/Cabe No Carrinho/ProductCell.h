//
//  ProductCell.h
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@protocol ProductCellDelegate;

@interface ProductCell : UITableViewCell

@property (assign,nonatomic) id<ProductCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) Item *item;

@end

@protocol ProductCellDelegate <NSObject>

@optional
- (void)productCell:(ProductCell *)cell didStep:(UIStepper *)stepper;

@end
