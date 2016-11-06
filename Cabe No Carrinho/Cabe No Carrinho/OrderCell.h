//
//  OrderCell.h
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@protocol OrderCellDelegate;

@interface OrderCell : UITableViewCell

@property (assign, nonatomic) id<OrderCellDelegate> delegate;
@property (strong, nonatomic) Order *order;

@end

@protocol OrderCellDelegate <NSObject>

@optional
- (void)orderCell:(OrderCell *)cell didChooseOrder:(Order *)order;

@end
