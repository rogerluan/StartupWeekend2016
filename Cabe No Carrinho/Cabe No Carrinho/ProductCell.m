//
//  ProductCell.m
//  CaboNoCarrinho
//
//  Created by Roger Luan on 06/11/16.
//  Copyright © 2016 Roger Oba. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation ProductCell

- (IBAction)didStep:(UIStepper *)sender {
    self.quantityLabel.text = [NSString stringWithFormat:@"%.ld", (long)sender.value];
    [self productCell:self didStep:sender];
}

- (void)setItem:(Item *)item {
    _item = item;
    self.nameLabel.text = item.product.name;
    self.priceLabel.text = item.product.averagePrice.stringValue;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)item.quantity];
    self.stepper.value = item.quantity;
}

- (void)productCell:(ProductCell *)cell didStep:(UIStepper *)stepper {
    if ([self.delegate respondsToSelector:@selector(productCell:didStep:)]) {
        [self.delegate productCell:self didStep:stepper];
    }
}

@end
