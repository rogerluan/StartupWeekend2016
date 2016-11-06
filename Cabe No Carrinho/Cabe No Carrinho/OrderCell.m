//
//  OrderCell.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell()

@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rewardLabel;

@end

@implementation OrderCell

- (void)setOrder:(Order *)order {
    _order = order;
#warning bring default image here
    self.orderImageView.image = [UIImage imageNamed:@"placeholder"];
    self.nameLabel.text = order.identifier;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld produtos", (long)order.items.count];
    double totalPrice = 0;
    for (Item *item in order.items) {
        totalPrice += item.product.averagePrice.doubleValue;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"R$ %.2f", totalPrice];
    self.rewardLabel.text = [NSString stringWithFormat:@"Ganhe R$ %ld", (long)order.reward];
}

- (IBAction)buyButtonPressed:(UIButton *)sender {
    [self didChooseOrder:self.order];
}

- (void)didChooseOrder:(Order *)order {
    if ([self.delegate respondsToSelector:@selector(orderCell:didChooseOrder:)]) {
        [self.delegate orderCell:self didChooseOrder:order];
    }
}

@end
